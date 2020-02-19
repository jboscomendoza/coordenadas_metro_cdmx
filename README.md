# Coordenadas de las estaciones del Metro de la Ciudad de México (CDMX)

Conjunto de datos con las coordenadas de las estaciones del Metro de la Ciudad de México. Incluye datos de las estaciones de las líneas 1 a 12.

La información de las coordenadas ha sido extraída de Wikipedia en Español, tomando como referencia el listado de estaciones siguiente:

* https://es.wikipedia.org/wiki/Anexo:Estaciones_de_metro_de_la_Ciudad_de_México

Los datos se encuentran disponibles en tres formatos de archivo diferentes.

* estaciones_coords.csv - Valores separados por comas.
* estaciones_coords.rds - Archivo compatible con R.
* estaciones_coorda.feather - Archivo feather, compatible con Python y R, requiere el paquete Feather para su lectura (https://github.com/wesm/feather)

Además de dos archivos usados en la extracción de datos:
 
 * extraccion.R - Código usado para hacer scrapping de datos con R.
 * estaciones_html.rds - HTML usado como base para el scapping de datos, compatible con R.
