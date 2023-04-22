#----Hoja 5
install.packages("XML")
library(XML)
bm.url <- "http://api.worldbank.org/v2/countries/all/indicators/NY.GDP.MKTP.CD?date=2019:2020&per_page=500&page=1"

bm.doc <- xmlParse(bm.url)

root.node <- xmlRoot(bm.doc)
root.node[1]
#Creamos un dataframe para acceder a todos los datos del xml
bm.data <- xmlSApply(root.node, function(x) xmlSApply(x, xmlValue))

#Usamos t() para transponer las filas y columnas
# TRASNPONER : trasladar o cambiar
bm.datos <- data.frame(t(bm.data), row.names = NULL)
