## BTC OHLC prices
## from Binance spot market
## in 30 minute intervals
BTC_LS <- cryptoQuotes::get_lsratio(
  ticker   = 'PI_ETHUSD',
  source   = 'kraken',
  interval = '2d',
  from     = Sys.Date() - 500
)