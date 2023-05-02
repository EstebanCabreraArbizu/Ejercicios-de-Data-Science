#----------CARGAR DATOS------------
hotel_bookings <- read.csv("C:\\Users\\ANDREA\\OneDrive - Universidad Peruana de Ciencias\\Desktop\\UPC V\\Fundamentos de Data Science\\TP1\\hotel_bookings.csv", header = TRUE,sep = ",")
View(hotel_bookings)

#---------PREPROCESAMIENTO DE DATOS----------
str(hotel_bookings)
summary(hotel_bookings)
colSums(is.na(hotel_bookings))
en_blanco<-function(x){
  sum = 0
  for(i in 1:ncol(x))
  {
    cat("En la columa ",colnames(x[i]), "total de valores en blanco : ", colSums(x[i]==""),"\n")
  }
}
#limpiamos a children NA
en_blanco(hotel_bookings)
ubicamos_vacios <- which(is.na(hotel_bookings$children))
ubicamos_vacios

freq <- table(hotel_bookings$children[hotel_bookings$children != 0])
moda <- as.numeric(names(freq)[which.max(freq)])
hotel_bookings$children <- ifelse(is.na(hotel_bookings$children), moda, hotel_bookings$children)

colSums(is.na(hotel_bookings))

#limpiamos de children = 0
num_zeros <- sum(hotel_bookings$children == 0)
num_zeros

valores_unicos <- c(valores_children <- unique(hotel_bookings$children))
valores_unicos 
hotel_bookings$children <- ifelse(hotel_bookings$children == 0, sample(valores_unicos , length(hotel_bookings$children), replace = TRUE), hotel_bookings$children)

num_zeros <- sum(hotel_bookings$children == 0)
num_zeros

#-------Librerias a usar -------------
install.packages("ggplot")
library(ggplot2)
install.packages("scales")
library(scales)
library(dplyr)

#---------ANÁLISIS DE DATOS EXPLORATORIO -----------
#1. ¿En que mes del año se realizaron mas reservaciones en Resort Hotel 
#y City Hotel y el tipo de habitacion?

#creamos una nueva data set que contengan los valores que nesecitamos
data_tabla1  <- xtabs(~hotel+reserved_room_type, data = hotel_bookings)
hotel_tipo_cuarto <- as.data.frame(data_tabla1 )
hotel_tipo_cuarto

# Agrupar por mes, hotel y habitación y contar reservas
reservacion_por_mes <-hotel_bookings%>%
  group_by(arrival_date_month, hotel, reserved_room_type) %>%
  summarise(reservations = n()) %>%
  ungroup()
View(reservacion_por_mes)

# Convertir arrival_date_month en un factor ordenado
reservacion_por_mes$arrival_date_month <- factor(reservacion_por_mes$arrival_date_month,
                                                 levels = month.name)
# Graficar usando ggplot2
ggplot(reservacion_por_mes , aes(x = arrival_date_month, y = reservations, fill = hotel)) +
  geom_col(position = "dodge") +
  geom_text(aes(label=reservations), position=position_dodge(width=0.05), vjust=-0.001,size = 3) +
  facet_wrap(~reserved_room_type,ncol = 3, scales = "free_y") +
  scale_fill_manual(values = c("#F8766D", "#00BFC4"),  name = "Tipo de Hotel") +
  labs(x = "Meses ", y = " Rervaciones ", title = "Reservaciones por mes , tipo de cuarto y tipo de hotel")



#2.¿Cuanto tiempo se tarda  en hacer una 
#reserva de acuerdo al canal de distribuscion en que realiza dicha reseva ?

hotel_bookings$hotel <- factor(hotel_bookings$hotel)
hotel_bookings$market_segment <- factor(hotel_bookings$market_segment)
hotel_bookings$distribution_channel <- factor(hotel_bookings$distribution_channel)

reservas_promedio <- hotel_bookings %>%
  group_by(hotel, market_segment, distribution_channel) %>%
  summarise(promedio_tiempo = mean(lead_time, na.rm = TRUE))

ggplot(reservas_promedio, aes(x = hotel, y = promedio_tiempo, fill = distribution_channel)) +
  geom_boxplot() +
  geom_hline(aes(yintercept = 69),
             color = "red",linetype = "dashed", lwd = 2) +
  labs(title = "Tiempo promedio de reserva por hotel y canal de distribución",
       x = "Hotel",
       y = "Tiempo promedio de reserva (días)",
       fill = "Canal de distribución"
  )

#3.	¿Cuál de los hoteles son preferidos por cada tipo de cliente?

# Agrupar por hotel, customer_type y market_segment y contar reservas
reservaciones_po_tipo <-hotel_bookings %>%
  group_by(hotel, customer_type, market_segment) %>%
  summarise(reservations = n()) %>%
  ungroup()
prop.table(table(reservaciones_po_tipo))
# Graficar usando ggplot2
ggplot(reservaciones_po_tipo, aes(x = hotel, y = reservations, fill = customer_type, pattern = market_segment)) +
  geom_col(position = "stack") +
  scale_fill_manual(values = c("#F8766D", "red", "#00BFC4", "#C77CFF"), name = "Customer type") +
  labs(x = "Tipo de Hotel", y = "Reservaciones", title = "Reservaciones por los tipos de clientes")
