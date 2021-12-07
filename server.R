library(shiny)
library(ggplot2)
library(hash)

brushed_dataset <- NULL
display_names <- hash()
display_names[["year"]]<- "Año"
display_names[["volcano_name"]]<- "Nombre Volcán"
display_names[["country"]]<- "País"
display_names[["volcano_type"]]<- "Tipo Volcán"
display_names[["explosivity_index"]]<- "Índice de Explosividad Volcánica"

shinyServer(function(input, output, session) {
  filteredTable_data <- reactive({
    filtered_dataset <- dataset
    if(!is.null(brushed_dataset)){
      filtered_dataset <- brushed_dataset 
    }
    if(length(input$dataset_tbl_map_rows_selected) > 0){
      filtered_dataset %>%  
        filter(row_number() %in% input$dataset_tbl_map_rows_selected)
    }
    else{
      filtered_dataset %>%  
        filter(row_number() %in% input$dataset_tbl_map_rows_all)
    }
  })
  
  getTableData <- reactive({
    filtered_dataset <- dataset
    if(!is.null(input$mouse_brush)){
      brushed_dataset <<- brushedPoints(filtered_dataset, input$mouse_brush)
    }

    if(!is.null(input$mouse_dblclick)){
      brushed_dataset <<- NULL
    }
    
    if(!is.null(brushed_dataset)){
      filtered_dataset <- brushed_dataset 
    }
    
    filtered_dataset %>%   
      DT::datatable(filter = "top",
                    rownames = FALSE)
  })
  output$dataset_tbl_map <-  DT::renderDataTable({
    getTableData()
  })
  
  observeEvent(input$mouse_brush,{
    output$dataset_tbl_map <-  DT::renderDataTable({
      getTableData()
    })
    
  })
  
  observeEvent(input$mouse_dblclick,{
    output$dataset_tbl_map <-  DT::renderDataTable({
      getTableData()
    })
    
  })
  
  output$worldmap <- renderLeaflet({
    leaflet() %>%
      #addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
      #addProviderTiles("Esri.WorldStreetMap",                   options = providerTileOptions(noWrap = TRUE)) %>%
      addMarkers(lng = filteredTable_data()$longitude, lat = filteredTable_data()$latitude, popup = filteredTable_data()$volcano_name) %>%
      setView(lng = 0, lat = 10, zoom = 1) %>% 
      addTiles()
      
  })
  
  
 
  
  
  
  
  filteredDataset <- reactive({
    filtered_dataset <- dataset
      if (length(input$plots_country) > 0){
        filtered_dataset <- filtered_dataset %>%
                            filter(country %in% input$plots_country)
      }
      if (length(input$plots_volcano_type) > 0){
        filtered_dataset <- filtered_dataset %>%
          filter(volcano_type %in% input$plots_volcano_type)
      }
      filtered_dataset %>%
        filter(year >= input$plots_year[1] & year <= input$plots_year[2]) 
  })
  
  
  output$eruptionsByYear <- renderPlot({
    filtered_dataset <- filteredTable_data()

    plot<- ggplot(data=filtered_dataset, aes(x=country)) +
      geom_bar( stat='count' ) + 
      geom_text(stat='count', aes(label=..count..), vjust=-1) + 
      ggtitle(paste("Erupciones por País")) +
      labs(y="Erupciones", x = "País") +
      theme(axis.text.x=element_text(angle = 45, hjust = 1))
    
    if(!is.null(brushed_dataset)){
      plot <- plot+ geom_bar(data=brushed_dataset, fill="royalblue3")
    }
    
    plot
  })
  
  
  output$eruptionsPlot <- renderPlot({
    filtered_dataset <- filteredDataset()
    filtered_dataset <- filtered_dataset %>%
                        rename(x_var = input$plots_xvar) %>%
                        select(x_var) %>%
                        filter(!is.na(x_var)) %>%
                        group_by(x_var) %>%
                        tally(sort = TRUE) %>%
                        rename( eruption_count = n)
                        if (input$plots_order == "Ascendente"){
                          filtered_dataset <- filtered_dataset %>% slice_tail(n=input$plots_top)
                        }else{
                          filtered_dataset <- filtered_dataset %>%  slice_head(n=input$plots_top)
    
                        }
     plot <- NULL
     if (input$plots_order == "Ascendente"){
       plot <- ggplot(data=filtered_dataset, aes(x=reorder(x_var,eruption_count), y=eruption_count)) 
     }
     else {
       plot <- ggplot(data=filtered_dataset, aes(x=reorder(x_var, -eruption_count), y=eruption_count)) 
     }
     
     plot + geom_bar( stat='identity',  fill=input$plots_color ) + 
     geom_text(stat='identity', aes(label=eruption_count), vjust=-1) + 
     ggtitle(paste("Erupciones por",display_names[[input$plots_xvar]])) +
     labs(y="Erupciones", x =  display_names[[input$plots_xvar]]) +
     theme(axis.text.x=element_text(angle = 45, hjust = 1))
    

  })

  SummarizePlot <- function(x,y, y_label){
    filtered_dataset <- filteredDataset() %>%
      rename(x_var = x) %>%
      rename(y_var = y) %>%
      select(x_var, y_var) %>%
      filter(!is.na(y_var)) %>%
      filter(!is.na(x_var)) %>%
      group_by(x_var) %>%
      summarize(TotalSum = sum(y_var)) %>%
      arrange(desc(TotalSum))
    if (input$plots_order == "Ascendente"){
      filtered_dataset <- filtered_dataset %>% slice_tail(n=input$plots_top)
    }else{
      filtered_dataset <- filtered_dataset %>%  slice_head(n=input$plots_top)
    }
    
    plot <- NULL
    if (input$plots_order == "Ascendente"){
      plot <- ggplot(data=filtered_dataset, aes(x=reorder(x_var,TotalSum), y=TotalSum)) 
    }
    else {
      plot <- ggplot(data=filtered_dataset, aes(x=reorder(x_var, -TotalSum), y=TotalSum)) 
    }
    plot<- plot + geom_bar( stat='identity', fill=input$plots_color ) + 
      geom_text(stat='identity', aes(label=TotalSum), vjust=-1) + 
      ggtitle(paste("Total de",y_label,"por", display_names[[x]])) +
      labs(y=y_label, x = display_names[[x]]) +
      theme(axis.text.x=element_text(angle = 45, hjust = 1))
    
    plot
  }
  
  output$deathsPlot <- renderPlot({
    SummarizePlot(input$plots_xvar, "deaths", "Muertes")
  })
  output$damagePlot <- renderPlot({
    SummarizePlot(input$plots_xvar, "damage_millions_of_dollars", "Daños en Millones de Dólares")
  })
  

  
  
  
  #################################################################### 
  
  observe({
    query <- parseQueryString(session$clientData$url_search)
    plots_xvar <- query[['plots_xvar']]
    plots_top <- query[['plots_top']]
    plots_color <- query[['plots_color']]
    
    if(!is.null(plots_xvar)){
      updateTabsetPanel(session, 'tabs', selected = "Graficas")
      updateSelectInput(session, 'plots_xvar', selected = plots_xvar)
    }
    if(!is.null(plots_top)){
      updateNumericInput(session, 'plots_top', value = as.numeric(plots_top))
    }
    if(!is.null(plots_color)){
      updateSelectInput(session, 'plots_color', selected = plots_color)
    }
  })
  
  observe({
    plots_xvar <- input$plots_xvar
    plots_top <- input$plots_top
    plots_color <- input$plots_color
    
    host_name <- session$clientData$url_hostname
    protocol <- session$clientData$url_protocol
    port <- session$clientData$url_port
    url_path <- session$clientData$url_pathname
    
    query <- paste('?', 'plots_xvar=', plots_xvar, '&plots_top=', plots_top, '&plots_color=', plots_color, sep = '')
    url <- paste(protocol, '//', host_name, ':', port, url_path, query, sep = '')
    updateTextInput(session, 'url_param', value = url)
    
  })
  
  ####################################################################  
  
  
  
  
})
