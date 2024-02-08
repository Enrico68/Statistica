#!/usr/bin/env python
# coding: utf-8

# In[3]:


# get_ipython().run_line_magic('load_ext', 'jupyter_ai_magics')


# In[4]:


# NOTE: Replace 'PROVIDER_API_KEY' with the credential key's name,
# and replace 'YOUR_API_KEY_HERE' with the key.
# get_ipython().run_line_magic('env', 'OPENAI_API_KEY=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')


# # In[5]:


# get_ipython().run_cell_magic('ai', 'chatgpt', 'Hello world\n')


# # In[3]:


# get_ipython().run_cell_magic('ai', 'chatgpt', 'I need to get the same label function of the program SPSS in python \ncan you show me \n')


# In[4]:


import pandas as pd



# In[5]:


data = {'age': [25, 30, 35, 40],
        'gender': ['Male', 'Female', 'Male', 'Female']}
df = pd.DataFrame(data)

# Create a dictionary with variable labels
# variable_labels = {'age': 'Age in years',
#                    'gender': 'Gender'}

# Assign the variable labels to the DataFrame
df.rename(columns=variable_labels, inplace=True)


# In[6]:


print(df)


# In[8]:


df.head()


# In[ ]:


#get_ipython().run_cell_magic('ai', 'chatgpt', 'show how to use descriptive statistic with seaborn python\n')


# In[ ]:


#get_ipython().run_cell_magic('ai', 'chatgpt', 'show me how import spss datasets with seaborn \n')


# In[ ]:


#get_ipython().run_cell_magic('ai', 'chatgpt', 'show how to use descriptive statistic with pandas python\n')


# ## Statistica descrittiva
# ### Media
# 
# > Media = Somma di tutti i valori / Numero totale di valori
# 
# $[\bar{x} = \frac{\sum_{i=1}^{n} x_i}{n}]$
# 
# Dove:
# 
# * $\bar{x}$ rappresenta la media
# * $x_1$ rappresenta ogni valore individuale nel dataset
# * $n$ rappresenta il numero totale dei valori nel dataset
# 
# La media rappresenta una misura di tendenza centrale

# In[ ]:


#get_ipython().run_cell_magic('ai', 'chatgpt', "devo introdurre il tuo output dentro una cella jupyter. Quindi d'ora in poi mi drovai con vertire gli output in markdown \n")


# In[9]:


# Creazione di un dataframe
data = {'A' : [2,12,12,19,19,20,20,20,25]}
df = pd.DataFrame(data)


# In[10]:


valori_mediani = df.median()
print("Media")
print(valori_mediani)
valori_rank = df.rank()
print("Rank")
print(valori_rank)


# > Per trovare la mediana, è necessario individuare il punteggio che si trova al centro di questa classifica.
# elenco. Abbiamo nove punteggi, quindi il punteggio medio è il quinto (ha quattro punteggi sotto e quattro punteggi sopra).
# sotto e quattro sopra). La mediana è quindi 19, che è il quinto punteggio dell'elenco
# 
# Nell'esempio precedente è stato facile calcolare la mediana, dato che il numero di punteggi era dispari.
# Quando si ha un numero dispari di punteggi, c'è sempre un punteggio che rappresenta la mediana. Questo
# non è così, invece, quando abbiamo un numero pari di punteggi. Se aggiungiamo il punteggio di 26 alla
# all'elenco precedente, ora abbiamo un numero pari di punteggIn questa situazione la mediana sarà compresa tra i due punteggi mediani, cioè tra il quinto e il sesto punteggio.
# quinto e sesto punteggio. La nostra mediana è, in questo caso, la media dei due punteggi in quinta e sesta posizione:
# $ (19 + 20) , 2 = 19,5$.
# sesta posizione$: (19 + 20) , 2 = 19,$5.n).n)

# La moda in statistica si riferisce al valore o ai valori che appaiono più frequentemente in un insieme di dati. La formula per calcolare la moda dipende dal tipo di dati:
# 
# - Per dati nominali (categorie senza un ordine specifico), la moda è semplicemente il valore che compare più spesso.
# 
# - Per dati ordinali (categorie con un ordine specifico), puoi calcolare la moda come il valore con la massima frequenza.
# 
# In Python all'interno di Jupyter Notebook, puoi utilizzare la libreria `statistics` per calcolare la moda. Ad esempio:
# 
# ```python
# from statistics import mode
# 
# data = [1, 2, 2, 3, 3, 3, 4, 4, 5]
# moda = mode(data)
# moda
# ```
# 
# In questo caso, il valore moda per i dati è 3. Assicurati di aver importato la libreria `statistics` prima di utilizzare la funzione `mode`.

# In[8]:


from statistics import mode

moda = mode(data)
print (moda)


# In[9]:


get_ipython().run_line_magic('who_ls', '')


# In[ ]:


get_ipython().run_line_magic('pinfo', 'del')


# In[10]:


del df,data


# In[11]:


data = [2,12,12,19,19,19,20,20,20,25,26]
moda = mode(data)
print(moda)


# In[15]:


# Uno snippet che permette di inserire una serie di numeri, calcolare la moda, mediana e la media
input_numeri = input ("Inserisci una serie di numeri separati da spazio: ")
data = [int(numero) for numero in input_numeri.split()]
# Calcola la moda 
from statistics import mode
moda = mode(data)
# Calcola la mediana 
from statistics import median
mediana = median(data)
# Calcola la media
from statistics import mean
media = mean(data)
# Calcola il rank
from scipy.stats import rankdata
ranking = rankdata(data)



print(f"(Moda: {moda}")
print(f"(Mediana: {mediana}")
print(f"(Media: {media}")
print(f"(Ranking: {ranking}")


# In[ ]:


get_ipython().run_line_magic('pip', 'install --upgrade pip')


# In[4]:


from statistics import median, mean, mode


# In[5]:


#get_ipython().run_line_magic('whos', '')


# In[9]:


data = [96 , 107,
121 , 93,
86 , 81,
114 , 107,
94 , 114 ,
102 ,121,
86 ,100,
81 , 100,
100 ,118,
89 , 112]


# In[10]:


data


# In[1]:


import pandas as pd


# In[6]:


import pandas as pd

# Your dataset
dataset = pd.DataFrame({"walking_with_dogs": [9, 7, 10, 12, 6, 8],
                        "walking_without_dogs": [4, 5, 3, 6, 5, 1]})



# In[7]:


dataset


# In[9]:


from scipy.stats import trim_mean
trimmed_mean_with_dogs=trim_mean(dataset['walking_with_dogs'], proportiontocut=0.05)
trimmed_mean_without_dogs=trim_mean(dataset['walking_without_dogs'], proportiontocut=0.05)
print("5% trimmed mean for walking_with_dogs: ", trimmed_mean_with_dogs)
print("5% trimmed mean for walking_without_dogs: ", trimmed_mean_without_dogs)


# In[11]:


import numpy as np
from scipy.stats import skew
median=dataset.median()
variance=dataset.var()
deviazione_standard=dataset.std()
minimo=dataset.min()
print("Mediana del dataset è: ", median)
print("La varianza è: ", variance)
print("La deviazione standard è :", deviazione_standard)
print("Il minimo è :", minimo)
range_con_cani=np.ptp(dataset['walking_with_dogs'])
range_senza_cani=np.ptp(dataset['walking_without_dogs'])
print("il range con cani è: ", range_con_cani, "\nIl range senza cani è :" , range_senza_cani)
moda=dataset.mode()
print("La moda è: ", moda)
skeweness_con_cani = dataset["walking_with_dogs"].skew()
skeweness_senza_cani=dataset['walking_without_dogs'].skew()
print("La skeweness con cani è: ", skeweness_con_cani)
print("la skeweness senza cani è: ", skeweness_senza_cani)


from statistics import mean
valori = [5, 10, 15, 20, 25]  # esempio di valori nel campione
media = mean(valori)    # calcolo della media
print("La media dei valori è:", media)
# In[ ]:
valori = [10, 20, 5, 15, 25]  # esempio di valori

ranking = sorted(range(len(valori)), key=lambda x: valori[x])
# Key lambda restituisce la posizione della lista ordinata

for posizione, indice in enumerate(ranking):
    print(f"L'elemento {valori[indice]} si trova in posizione {posizione+1}")
