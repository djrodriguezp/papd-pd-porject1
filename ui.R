
library(shiny)
library(leaflet)
library(DT)

shinyUI(fluidPage(

    titlePanel("Erupciones Volcanicas"),
    
    tabsetPanel(selected="Graficas", 
                tabPanel("Dataset y Mapa", 
                         fluidRow(
                             
                             column(12,
                                    leafletOutput("worldmap", width = "100%", height = 500),
                                    DT::dataTableOutput("dataset_tbl_map")
                             )
                         )
               ),
                tabPanel("Graficas",  
                         sidebarLayout(
                           sidebarPanel(
                             selectInput("plots_xvar","Variable X", c("Volcano.Name","Country", "year"), selected = "Volcano.Name"),
                             numericInput("plots_top", "Cantidad de Resultados", value=10),
                             selectInput("plots_order","Tipo de Orden", c("Ascendente","Descendente"), selected = "Descendente"),
                             sliderInput("plots_year", "Año Erupción", 
                                         min = min(dataset$year), 
                                         max = max(dataset$year), 
                                         value = c(min(dataset$year),max(dataset$year)), 
                                         step=1),
                             selectInput("plots_country","País", unique(dataset$Country), multiple = TRUE),
                             selectInput("plots_volcano_type","Tipo de Volcán", unique(dataset$Volcano.Type), multiple = TRUE),
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
    
