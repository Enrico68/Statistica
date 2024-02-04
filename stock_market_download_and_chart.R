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
