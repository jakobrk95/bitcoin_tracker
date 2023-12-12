library(httr2)
library(RPostgres)
library(DBI)

source('/home/rstudio/bitcoin_tracker/cred.R')


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
source("/home/rstudio/bitcoin_tracker/psql_queries.R")

psql_append_df(cred = cred_psql_docker, 
               schema_name = "bitcoin_tracker", 
               tab_name = "bitcoin", 
               df = df)

## Log

# Get the current datetime
date_time <- format(Sys.time(), digits = 0) 
# Check if "increment_one.rds" exists
if(file.exists("/home/rstudio/bitcoin_tracker/scraper.rds")){
  # If "increment_one.rds exists then we read it into memory
  increment_one <- readRDS(file = "/home/rstudio/bitcoin_tracker/scraper.rds")
  # We add one to the R object
  increment_one <- increment_one + 1
  # The R object is saved to the disk
  saveRDS(increment_one, file = "/home/rstudio/bitcoin_tracker/scraper.rds")  
  # We print the datetime and the value of increment_one.
  # This will be captured by the cronR logger and written to the .log file
  print(paste0(date_time, ": Value of scraper.rds is ", increment_one))
}else{
  # If "scraper.rds" does not exist we begin by 1
  increment_one <- 1
  # The R object is saved to the disk
  saveRDS(increment_one, file = "/home/rstudio/bitcoin_tracker/scraper.rds")  
  # We print the datetime and the value of increment_one.
  # This will be captured by the cronR logger and written to the .log file
  print(paste0(date_time, ": Value of scraper.rds is ", increment_one))
}


