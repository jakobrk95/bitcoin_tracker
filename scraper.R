library(httr2)
library(RPostgres)
library(DBI)

source('cred.R')


# This is the API scraper:

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

df <- data.frame(price = price)


# This part Transfers the data to the data base
source("psql_queries.R")

psql_append_df(cred = cred_psql_docker, 
               schema_name = "bitcoin_tracker", 
               tab_name = "bitcoin", 
               df = df)
