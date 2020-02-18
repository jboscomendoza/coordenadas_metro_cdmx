library(tidyverse)
library(rvest)
library(janitor)

estaciones <- read_html(x = "https://es.wikipedia.org/wiki/Anexo:Estaciones_de_metro_de_la_Ciudad_de_M%C3%A9xico")

estaciones_nombres <- 
  html_nodes(estaciones, ".wikitable") %>% 
  html_table(fill = TRUE) %>% 
  as.data.frame() %>% 
  clean_names() %>% 
  as_tibble()

safe_html <- safely(read_html, otherwise = "404")
estaciones_html_test <- map(estaciones_urls, safe_html)
map(estaciones_html_test, "error")

estaciones_urls <- 
  estaciones_nombres$estacion %>% 
  str_remove("/.*") %>% 
  str_replace_all(" ", "_") %>% 
  paste0("https://es.wikipedia.org/wiki/", ., "_(estación)") %>% 
  str_replace("(Universidad|Tasqueña|Sevilla|San_(Antonio|Joaquín)|Portales|Candelaria)_\\(estación\\)", 
              "\\1_(estación_del_Metro_de_Ciudad_de_México)")

safe_html <- safely(read_html, otherwise = "404")
estaciones_html_test <- map(estaciones_urls, safe_html)
map(estaciones_html_test, "error")

estaciones_html <- map(estaciones_urls, read_html)

write_rds(estaciones_html, "estaciones_html.rds")

estaciones_coords <- 
  map_chr(estaciones_html, function(estacion) {
    estacion %>% 
      html_nodes(".nourlexpansion") %>% 
      html_text() %>% 
      str_replace_all("\\D", ".") %>% 
      str_replace_all("\\.{2,}", "-") %>% 
      `[`(1)
  }) %>% 
  tibble(coords = .) %>% 
  separate(coords, into = c("a", "b", "lng", "lat"), sep = "-") %>%
  mutate_all(as.numeric) %>% 
  mutate(lat = lat * -1,
         estacion = estaciones_nombres$estacion) %>% 
  select(estacion, lng, lat)




