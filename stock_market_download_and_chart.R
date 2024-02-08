library(quantmod)
library(TTR)
getSymbols("BTC-USD", src = "yahoo", from = "2022-01-01")
getSymbols("^GSPC", src = "yahoo")
dim(`BTC-USD`)

plot(`BTC-USD`)
plot(GSPC)
names(`BTC-USD`)
lineChart(`BTC-USD`, line.type = 'h', theme = 'white', TA =NULL)
barChart(`BTC-USD`)
barChart(GSPC)
lineChart(GSPC, line.type = 'h', theme = 'white' )
candleChart(`BTC-USD` , TA = NULL, subset = '2024')
candleChart(`BTC-USD`, TA = NULL, subset = '2023-12::2024')

candleChart(`BTC-USD`, TA = NULL, theme = chartTheme('white', up.col='blue', dn.col='darkred'  ), subset = '2023-12::2024')
BTC <- `BTC-USD`
plot(BTC$`BTC-USD.Close`)

getSymbols("GDPCA", src = "FRED")
gdp <- GDPCA

                                        # Plotting the GDP data
plot(gdp, main = "US GDP", ylab = "GDP", col = "blue", lwd = 2)


Sys.setenv("QUANDL_API_KEY" = "LvXEZJ1pBbeVgTzNqmUu")

install.packages("Quandl")
library(Quandl)

Quandl.api_key("LvXEZJ1pBbeVgTzNqmUu")

revenue_data <- Quandl("SEC/MICROSOFT_10Q_MSFTR/revenues", start_date = "2000-01-01", end_date = "2022-12-31")

getFinancials("MSFT")
getFinancials

quandldata = Quandl("NSE/OIL", collapse="monthly", start_date="2013-01-01", type="ts")
plot(quandldata[,1])


revenue_data <- Quandl("RAYMOND_MSFTR/MSFT_REVENUE", start_date = "2000-01-01", end_date = "2022-12-31")
