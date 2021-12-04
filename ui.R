
library(shiny)
library(leaflet)
library(DT)

shinyUI(fluidPage(

    titlePanel("Erupciones Volcanicas"),
    
    tabsetPanel(tabPanel("Mapa", 
                         sidebarLayout(
                           sidebarPanel(
                             numericInput("min", "limite inferior", value = 5)
                           ),
                           mainPanel(
                             leafletOutput("worldmap", width = "100%"),
                             DT::dataTableOutput("dataset_tbl")
                           )
                         )
                      ),
                tabPanel("Graficas", 
                         sidebarLayout(
                           sidebarPanel(
                           ),
                           mainPanel(
                           )
                         )
                )
    )
    
))
    
