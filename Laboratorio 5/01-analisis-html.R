library(rvest)
library(xml2)
wpob.url <- "data/WorldPopulation-wiki.html"
tablas <- readHTMLTable(wpob.url)

most_wpob <- tablas[[5]]
head(most_wpob,3)

tabla_unica <- readHTMLTable(wpob.url, which = 5)
