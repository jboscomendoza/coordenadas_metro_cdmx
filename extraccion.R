library(tidyverse)
library(rvest)
library(janitor)
library(feather)

estaciones <- read_html(x = "https://es.wikipedia.org/wiki/Anexo:Estaciones_de_metro_de_la_Ciudad_de_M%C3%A9xico")

estaciones_nombres <- 
  html_nodes(estaciones, ".wikitable") %>% 
  html_table(fill = TRUE) %>% 
  as.data.frame() %>% 
  clean_names() %>% 
  as_tibble()

# # Proceso para identificar urls no validos
# estaciones_urls <- 
# estaciones_nombres$estacion %>% 
# str_remove("/.*") %>% 
# str_replace_all(" ", "_") %>% 
# paste0("https://es.wikipedia.org/wiki/", ., "_(estación)")
# 
# safe_html <- safely(read_html, otherwise = "404")
# estaciones_html_test <- map(estaciones_urls, safe_html)
# map(estaciones_html_test, "error")

estaciones_urls <- 
  estaciones_nombres$estacion %>% 
  str_remove("/.*") %>% 
  str_replace_all(" ", "_") %>% 
  paste0("https://es.wikipedia.org/wiki/", ., "_(estación)") %>% 
  str_replace("(Tasqueña|Sevilla|San_(Antonio|Joaquín)|Portales|Candelaria|Bellas Artes)_\\(estación\\)", 
              "\\1_(estación_del_Metro_de_Ciudad_de_México)") %>% 
  str_replace("(Universidad)_\\(estación\\)", 
              "\\1_(estación_del_Metro_de_la_Ciudad_de_México)")

estaciones_html <- map(estaciones_urls, read_html)

estaciones_coords <- 
  map_chr(estaciones_html, function(estacion) {
    estacion %>% 
      html_nodes(".nourlexpansion") %>% 
      html_text()  %>% 
      str_extract("(?<=/).*") %>% 
      `[`(1) %>% 
      str_trim()
  }) %>% 
  tibble(coords = .) %>% 
  separate(coords, into = c("lat", "lng"), sep = ",") %>% 
  mutate_all(as.numeric) %>% 
  mutate(estacion = estaciones_nombres$estacion,
         coord = paste(lat, lng, sep = ",")) %>% 
  select(estacion, lat, lng, coord) %>%
  data.frame()

write_feather(estaciones_coords, "estaciones_coords.feather")
write.csv(estaciones_coords, "estaciones_coords.csv", 
          row.names = FALSE, fileEncoding = "utf-8")
write_rds(estaciones_html, "estaciones_html.rds")
write_rds(estaciones_coords, "estaciones_coords.rds")
