library(cronR)

cmd <- cron_rscript(rscript = "scraper.R")
cron_add(cmd, frequency = '*/5 * * * *', id = 'job1', description = 'Scrape price')