#----Hoja 5----
#----ADQUISICION Y MANIPULACION DE DATOS SEMIESTRUCTURADOS CON R----
install.packages("jsonlite")
library(jsonlite)

ine.url <- "https://servicios.ine.es/wstempus/js/ES/DATOS_TABLA/2852?nult=5&tip=AM"
# Utilizamos la instrucción fromJSON() para cargar los
# datos contenido en ine.url en una variablede datos llamada pob.esp

pop.esp <- fromJSON(ine.url)
