
library(shiny)
library(leaflet)
library(DT)

shinyUI(fluidPage(

    titlePanel("Erupciones Volcánicas"),
    
    tabsetPanel(id = 'tabs',#selected="Graficas",
                tabPanel("Dataset y Mapa", 
                         fluidRow(
                           column(6,
                                  plotOutput("eruptionsByYear", 
                                             dblclick = "mouse_dblclick",
                                             brush = brushOpts("mouse_brush", resetOnNew = T, direction = "x"))
                                  
                           ),
                             column(6,
                                    leafletOutput("worldmap", width = "100%", height = 500),
                                    
                             )
                         ),
                         fluidRow(column(12),
                                  DT::dataTableOutput("dataset_tbl_map")
                                  )
               ),
                tabPanel("Graficas",  
                         sidebarLayout(
                           sidebarPanel(
                             selectInput("plots_xvar","Variable X", c("volcano_name","country", "year","volcano_type", "explosivity_index"), selected = "volcano_name"),
                             numericInput("plots_top", "Cantidad de Resultados", value=10),
                             selectInput("plots_order","Tipo de Orden", c("Ascendente","Descendente"), selected = "Descendente"),
                             sliderInput("plots_year", "Año Erupción", 
                                         min = min(dataset$year), 
                                         max = max(dataset$year), 
                                         value = c(min(dataset$year),max(dataset$year)), 
                                         step=1),
                             selectInput("plots_country","País", unique(dataset$country), multiple = TRUE),
                             selectInput("plots_volcano_type","Tipo de Volcán", unique(dataset$volcano_type), multiple = TRUE),
                             selectInput("plots_color","Color de Gráficas", colors_list , selected = "skyblue"),
                             textInput('url_param', 'Marcador:', value = '')
                           ), 
                           mainPanel(
                             plotOutput("eruptionsPlot"),
                             plotOutput("deathsPlot"),
                             plotOutput("damagePlot")
                           )
                         )
                )
    )
    
))
    
