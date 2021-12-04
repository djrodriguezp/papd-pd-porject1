

library(shiny)


dataset<-read.csv("dataset/volcanic_eruption_database.csv")

shinyServer(function(input, output, session) {
  filteredTable_data <- reactive({
    if(length(input$dataset_tbl_rows_selected) > 0){
      dataset %>%  
        filter(row_number() %in% input$dataset_tbl_rows_selected)
    }
    else{
      dataset %>%  
        filter(row_number() %in% input$dataset_tbl_rows_all)
    }
  })
  
  output$dataset_tbl <-  DT::renderDataTable({
     dataset %>%   
      DT::datatable(filter = "top",
                              rownames = FALSE)
  })
  
  output$worldmap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(lat = filteredTable_data()$Latitude, lng = filteredTable_data()$Longitude) %>%
      setView(lng = 0, lat = 0, zoom = 1) %>% 
      addTiles() %>%
      addMarkers(filteredTable_data()$Longitude, filteredTable_data()$Latitude, popup = filteredTable_data()$Volcano.Name)
  })
})
