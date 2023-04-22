#----Ejercicio 2----
library(XML)
bm.xml <- "data/cd_catalog.xml"

bm.document <- xmlParse(bm.xml)

root1.node <- xmlRoot(bm.document)
root1.node[1]
#Creamos un dataframe para acceder a todos los datos del xml
bm1.dataframe <- xmlSApply(root1.node, function(x) xmlSApply(x, xmlValue))

#Usamos t() para transponer las filas y columnas
# TRASNPONER : trasladar o cambiar
bm1.datos <- data.frame(t(bm1.dataframe), row.names = NULL)