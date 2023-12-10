library(httr2)
source('PAT.R')

req <- request("https://alpha-vantage.p.rapidapi.com/query") %>%
  req_url_query(  "from_currency" = "BTC",
                  "function" = "CURRENCY_EXCHANGE_RATE",
                  "to_currency" = "USD") %>%
  req_headers('X-RapidAPI-Key' = API_key,
              'X-RapidAPI-Host' = API_host) 
resp <- req %>% 
  req_perform() 

price_str = resp_body_json(resp)$`Realtime Currency Exchange Rate`$`9. Ask Price`
price = as.numeric(price_str)
price