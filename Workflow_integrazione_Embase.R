# =============================================================================
# WORKFLOW INTEGRAZIONE EMBASE CON DATABASE SQLITE ESISTENTE
# =============================================================================

library(tidyverse)
library(RSQLite)
library(DBI)
library(readr)

# -----------------------------------------------------------------------------
# PARTE 1: IMPORTAZIONE E PARSING DEL FILE EMBASE
# -----------------------------------------------------------------------------

# Funzione per processare il formato speciale di Embase
parse_embase_export <- function(filepath) {
  # Leggi tutte le righe del file
  all_lines <- readLines(filepath, encoding = "UTF-8")
  
  # Trova tutti gli indici dove inizia un nuovo record (righe con "TITLE")
  title_indices <- which(str_detect(all_lines, '^"TITLE"'))
  
  cat(sprintf("Trovati %d record nel file Embase\n", length(title_indices)))
  
  # Lista per memorizzare tutti i record
  records <- list()
  
  # Processa ogni record
  for (i in seq_along(title_indices)) {
    start_idx <- title_indices[i]
    end_idx <- ifelse(i < length(title_indices), 
                      title_indices[i + 1] - 1, 
                      length(all_lines))
    
    # Estrai le righe del record corrente
    record_lines <- all_lines[start_idx:end_idx]
    
    # Crea un record vuoto
    record <- list()
    
    # Processa ogni riga del record
    for (line in record_lines) {
      if (nchar(line) > 0 && !grepl("^-+$", line)) {
        # Usa read.csv per parsare la riga correttamente
        parsed <- try(read.csv(text = line, header = FALSE, stringsAsFactors = FALSE), 
                      silent = TRUE)
        
        if (!inherits(parsed, "try-error") && ncol(parsed) >= 2) {
          field_name <- parsed[1, 1]
          field_values <- as.character(parsed[1, 2:ncol(parsed)])
          field_values <- field_values[field_values != ""]
          
          if (length(field_values) > 0) {
            record[[field_name]] <- paste(field_values, collapse = "; ")
          }
        }
      }
    }
    
    if (length(record) > 0) {
      records[[i]] <- record
      
      # Progress indicator
      if (i %% 10 == 0) {
        cat(sprintf("Processati %d/%d record...\r", i, length(title_indices)))
      }
    }
  }
  
  cat("\n")
  
  # Converti la lista in dataframe
  df <- bind_rows(records)
  
  return(df)
}

# Importa il file Embase
cat("=== IMPORTAZIONE DATI EMBASE ===\n")
embase_data <- parse_embase_export("records.csv")

# Mostra informazioni di base
cat(sprintf("\nRecord importati: %d\n", nrow(embase_data)))
cat(sprintf("Campi disponibili: %d\n", ncol(embase_data)))
cat("\nPrimi 5 titoli:\n")
if (nrow(embase_data) >= 5) {
  for (i in 1:5) {
    cat(sprintf("%d. %s (%s)\n", 
                i, 
                substr(embase_data$TITLE[i], 1, 80),
                embase_data$`PUBLICATION YEAR`[i]))
  }
}

# -----------------------------------------------------------------------------
# PARTE 2: PULIZIA E STANDARDIZZAZIONE DEI DATI EMBASE
# -----------------------------------------------------------------------------

# Crea un dataframe pulito con i campi rilevanti
embase_clean <- embase_data %>%
  mutate(
    # Standardizza i nomi dei campi
    title = TITLE,
    authors = `AUTHOR NAMES`,
    year = as.integer(`PUBLICATION YEAR`),
    source_title = `SOURCE TITLE`,
    abstract = ABSTRACT,
    pmid = `MEDLINE PMID`,
    doi = DOI,
    language = `LANGUAGE OF ARTICLE`,
    publication_type = `PUBLICATION TYPE`,
    embase_id = `EMBASE ACCESSION NUMBER`,
    # Estrai keywords medici rilevanti
    medical_terms = `EMTREE MEDICAL INDEX TERMS`,
    medical_terms_major = `EMTREE MEDICAL INDEX TERMS (MAJOR FOCUS)`,
    author_keywords = `AUTHOR KEYWORDS`
  ) %>%
  select(title, authors, year, source_title, abstract, pmid, doi, 
         language, publication_type, embase_id, medical_terms, 
         medical_terms_major, author_keywords)

# -----------------------------------------------------------------------------
# PARTE 3: IDENTIFICAZIONE ARTICOLI RILEVANTI PER INSTABILITÀ EMODINAMICA
# -----------------------------------------------------------------------------

# Keywords per identificare studi su pazienti instabili
instability_keywords <- c(
  "hemodynamically unstable", "haemodynamically unstable",
  "shock", "hypotension", "hypotensive",
  "hemorrhage", "haemorrhage", "bleeding",
  "unstable patient", "circulatory failure",
  "resuscitation", "vasopressor", "catecholamine",
  "systolic blood pressure", "SBP <90", "SBP <80"
)

# Funzione per cercare keywords
contains_instability_keywords <- function(text, keywords) {
  if (is.na(text)) return(FALSE)
  text_lower <- tolower(text)
  any(sapply(keywords, function(kw) grepl(tolower(kw), text_lower, fixed = TRUE)))
}

# Identifica articoli potenzialmente rilevanti
embase_clean <- embase_clean %>%
  mutate(
    # Controlla presenza di keywords nel titolo/abstract
    has_instability_title = sapply(title, contains_instability_keywords, 
                                   keywords = instability_keywords),
    has_instability_abstract = sapply(abstract, contains_instability_keywords, 
                                      keywords = instability_keywords),
    has_wbct = grepl("whole.?body|total.?body|pan.?scan|polytrauma ct|wbct", 
                     tolower(paste(title, abstract)), perl = TRUE),
    # Classifica come potenzialmente rilevante
    potentially_relevant = (has_instability_title | has_instability_abstract) & has_wbct
  )

# Report sui risultati
cat("\n=== ANALISI RILEVANZA ===\n")
cat(sprintf("Articoli con keywords di instabilità: %d\n", 
            sum(embase_clean$has_instability_title | embase_clean$has_instability_abstract)))
cat(sprintf("Articoli con TC total body: %d\n", sum(embase_clean$has_wbct)))
cat(sprintf("Articoli potenzialmente rilevanti: %d\n", sum(embase_clean$potentially_relevant)))

# Mostra alcuni articoli rilevanti
relevant_articles <- embase_clean %>%
  filter(potentially_relevant) %>%
  select(title, authors, year, pmid)

if (nrow(relevant_articles) > 0) {
  cat("\nArticoli rilevanti identificati:\n")
  for (i in 1:min(5, nrow(relevant_articles))) {
    cat(sprintf("\n%d. %s\n   %s (%d)\n   PMID: %s\n", 
                i,
                substr(relevant_articles$title[i], 1, 100),
                strsplit(relevant_articles$authors[i], ";")[[1]][1],
                relevant_articles$year[i],
                relevant_articles$pmid[i]))
  }
}

# -----------------------------------------------------------------------------
# PARTE 4: INTEGRAZIONE CON DATABASE SQLITE ESISTENTE
# -----------------------------------------------------------------------------

# Connetti al database
con <- dbConnect(RSQLite::SQLite(), "trauma_metaanalysis.db")

# Crea tabella per i dati Embase se non esiste
if (!"embase_records" %in% dbListTables(con)) {
  dbExecute(con, "
    CREATE TABLE embase_records (
      embase_id TEXT PRIMARY KEY,
      title TEXT,
      authors TEXT,
      year INTEGER,
      source_title TEXT,
      abstract TEXT,
      pmid TEXT,
      doi TEXT,
      language TEXT,
      publication_type TEXT,
      medical_terms TEXT,
      medical_terms_major TEXT,
      author_keywords TEXT,
      has_instability_title INTEGER,
      has_instability_abstract INTEGER,
      has_wbct INTEGER,
      potentially_relevant INTEGER,
      date_imported DATE
    )
  ")
}

# Prepara i dati per l'inserimento
embase_for_db <- embase_clean %>%
  mutate(
    date_imported = Sys.Date(),
    # Converti booleani in interi per SQLite
    has_instability_title = as.integer(has_instability_title),
    has_instability_abstract = as.integer(has_instability_abstract),
    has_wbct = as.integer(has_wbct),
    potentially_relevant = as.integer(potentially_relevant)
  )

# Inserisci i dati nel database
dbWriteTable(con, "embase_records", embase_for_db, overwrite = TRUE)

cat(sprintf("\n✓ %d record Embase inseriti nel database\n", nrow(embase_for_db)))

# -----------------------------------------------------------------------------
# PARTE 5: CROSS-REFERENCE CON STUDI GIÀ PRESENTI
# -----------------------------------------------------------------------------

# Cerca corrispondenze tra Embase e studi già nel database
cat("\n=== CROSS-REFERENCING ===\n")

# Query per trovare potenziali duplicati basati su PMID
duplicates_pmid <- dbGetQuery(con, "
  SELECT 
    e.title as embase_title,
    e.year as embase_year,
    e.pmid,
    s.Title as existing_title,
    s.Year as existing_year
  FROM embase_records e
  INNER JOIN studies s ON e.pmid = s.PMID
  WHERE e.pmid IS NOT NULL AND s.PMID IS NOT NULL
")

if (nrow(duplicates_pmid) > 0) {
  cat(sprintf("Trovati %d potenziali duplicati basati su PMID\n", nrow(duplicates_pmid)))
} else {
  cat("Nessun duplicato trovato basato su PMID\n")
}

# Query per trovare studi nuovi rilevanti da Embase
new_relevant_studies <- dbGetQuery(con, "
  SELECT 
    title, authors, year, pmid, doi
  FROM embase_records
  WHERE potentially_relevant = 1
    AND pmid NOT IN (SELECT PMID FROM studies WHERE PMID IS NOT NULL)
  ORDER BY year DESC
")

cat(sprintf("\nNuovi studi rilevanti da Embase: %d\n", nrow(new_relevant_studies)))

# -----------------------------------------------------------------------------
# PARTE 6: CREAZIONE TABELLA DI SCREENING
# -----------------------------------------------------------------------------

# Crea una tabella per lo screening manuale
if (!"screening_embase" %in% dbListTables(con)) {
  dbExecute(con, "
    CREATE TABLE screening_embase (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      embase_id TEXT,
      title TEXT,
      authors TEXT,
      year INTEGER,
      abstract TEXT,
      pmid TEXT,
      doi TEXT,
      potentially_relevant INTEGER,
      screening_decision TEXT CHECK(screening_decision IN ('include', 'exclude', 'maybe', NULL)),
      exclusion_reason TEXT,
      screened_by TEXT,
      screening_date DATE,
      notes TEXT,
      FOREIGN KEY (embase_id) REFERENCES embase_records(embase_id)
    )
  ")
}

# Popola la tabella di screening con articoli rilevanti
screening_data <- dbGetQuery(con, "
  SELECT 
    embase_id, title, authors, year, abstract, pmid, doi, potentially_relevant
  FROM embase_records
  WHERE potentially_relevant = 1
     OR has_instability_title = 1
     OR has_instability_abstract = 1
")

# Inserisci nella tabella di screening (evita duplicati)
for (i in 1:nrow(screening_data)) {
  dbExecute(con, "
    INSERT OR IGNORE INTO screening_embase 
    (embase_id, title, authors, year, abstract, pmid, doi, potentially_relevant)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  ", params = list(
    screening_data$embase_id[i],
    screening_data$title[i],
    screening_data$authors[i],
    screening_data$year[i],
    screening_data$abstract[i],
    screening_data$pmid[i],
    screening_data$doi[i],
    screening_data$potentially_relevant[i]
  ))
}

cat(sprintf("\n✓ %d articoli aggiunti alla tabella di screening\n", nrow(screening_data)))

# -----------------------------------------------------------------------------
# PARTE 7: REPORT DI SINTESI
# -----------------------------------------------------------------------------

# Genera report riassuntivo
report <- dbGetQuery(con, "
  SELECT 
    COUNT(*) as total_embase,
    SUM(potentially_relevant) as relevant_articles,
    SUM(CASE WHEN pmid IS NOT NULL THEN 1 ELSE 0 END) as with_pmid,
    SUM(CASE WHEN doi IS NOT NULL THEN 1 ELSE 0 END) as with_doi,
    SUM(CASE WHEN language = 'English' THEN 1 ELSE 0 END) as english_articles
  FROM embase_records
")

year_distribution <- dbGetQuery(con, "
  SELECT 
    year,
    COUNT(*) as n_articles,
    SUM(potentially_relevant) as n_relevant
  FROM embase_records
  WHERE year >= 2010
  GROUP BY year
  ORDER BY year DESC
")

cat("\n=== REPORT FINALE ===\n")
cat(sprintf("Totale articoli Embase: %d\n", report$total_embase))
cat(sprintf("Articoli rilevanti: %d (%.1f%%)\n", 
            report$relevant_articles, 
            100 * report$relevant_articles / report$total_embase))
cat(sprintf("Con PMID: %d\n", report$with_pmid))
cat(sprintf("Con DOI: %d\n", report$with_doi))
cat(sprintf("In inglese: %d\n", report$english_articles))

cat("\nDistribuzione temporale (ultimi 5 anni):\n")
print(head(year_distribution, 5))

# Esporta lista di articoli da recuperare full-text
to_retrieve <- dbGetQuery(con, "
  SELECT 
    title, authors, year, pmid, doi
  FROM screening_embase
  WHERE potentially_relevant = 1
  ORDER BY year DESC
")

write.csv(to_retrieve, "embase_articles_to_retrieve.csv", row.names = FALSE)
cat(sprintf("\n✓ Lista di %d articoli da recuperare salvata in 'embase_articles_to_retrieve.csv'\n", 
            nrow(to_retrieve)))

# Chiudi connessione
dbDisconnect(con)

cat("\n=== WORKFLOW COMPLETATO ===\n")
cat("Prossimi passi:\n")
cat("1. Revisionare gli articoli nella tabella 'screening_embase'\n")
cat("2. Recuperare i full-text degli articoli rilevanti\n")
cat("3. Estrarre i dati di mortalità per la meta-analisi\n")
cat("4. Aggiornare la tabella 'mortality_data' con i nuovi studi\n")