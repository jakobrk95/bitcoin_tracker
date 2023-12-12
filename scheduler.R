library(cronR)

cmd <- cron_rscript(rscript = "/home/rstudio/bitcoin_tracker/scraper.R")
cron_add(command = cmd, frequency = '*/5 * * * *', id = 'job1', description = 'Scrape price')