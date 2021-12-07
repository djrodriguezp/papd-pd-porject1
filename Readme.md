# UNIVERSIDAD GALILEO
## Instituto de Investigación de Operaciones
### Postgrado en Análsis y Predicción de Datos
### Product Development - Proyecto 1
### Antonio Navas, Daniel Rodríguez y Luis Florian

#### Dashboard de Erupciones Volcánicas

- Dataset
El dataset contiene registro de activación de volcanes (erupción), desde el primer registro en el año 4360 AC hasta el año 2020 DC.  El dataset contiene 14 columnas y 835 filas.

- Dashboard
El dashboard fue realizado con shiny y presenta dos tabs, i) Dataset y Mapa y ii) Gráficas.

**i) Data Set y Mapa** \
- Inicialmente se muestra el dataset completo, visualizado en la misma página con un valor por default de 10 filas.  Esta cantidad se variar entre 10, 25, 50, 100.  Para visualizar el resto es requerido hacer click en opción next, en la parte inferior o elegir el número de página.

- El histograma y el mapa muestran inicialmente las erupciones de todos los países, pero en la parte de abajo se observa el dataset completo dividido por pages, las tuplas seleccionadas al hacer click se graficarán inmediatamente en el mapa y el histograma.

- En el mapa, los signo + y - son para zoom in y out, respectivamente.

- Al hacer click en la ubicación marcada en el mapa, se presenta el nombre del volcán.

- El search busca la palabra indicada en todas las variables.

**ii) Gráficas** \
- Se presentan los histogramas: Erupciones, total de muertes, total de daños en millones de dolares por: año, país, nombre de volcán, tipo de volcán o índice de explosividad. Para variar los histogramas se requiere elegir la variable a utilizar.

- También podemos variar la cantidad de resultados, ordenarlo por orden ascendente o descendente y elegir un rango específico de años.

- Se puede filtrar los datos de los histogramas por país, tipo de volcán, establecer el color de las gráficas entre 19 opciones de colores.

- Por último se genera una url para visalizar el dashboard por html. Esta dirección inicia mostrando la pestaña de gráficas.







