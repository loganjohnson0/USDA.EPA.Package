#' @importFrom lubridate date, mdy_hm
pd_data <- read.csv("cleaned_data.csv") %>%
  mutate(Date.Reported = lubridate::date(mdy_hm(Date.Time.Reported)))

server <- function(input, output) {

  filtered_data <- reactive({
    classification_filter <- evaluate_classification(input$crimeClassify)

    pd_data %>%
      #filter(pd_data$Classification == 'input$crimeClassify') %>%
      filter(between(Date.Reported, input$date[1], input$date[2])) %>%

      # classification filter
      filter(Category %in% classification_filter)
  })

  table_data <- reactive({
    classification_filter <- evaluate_classification(input$crimeClassify)

    pd_data %>%
      filter(between(Date.Reported, input$date[1], input$date[2])) %>%

      # classification filter
      filter(Category %in% classification_filter) %>%

      select(Case.Number,
             Date.Reported,
             General.Location,
             Disposition,
             Category,
             Classification)

  })

  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(pd_data) %>% addTiles() %>%
      fitBounds(~min(longitude), ~min(latitude), ~max(longitude), ~max(latitude))
  })

  observe({
    leaflet::leafletProxy("map", data = filtered_data()) %>%
      leaflet::clearMarkers() %>%
      leaflet::addMarkers(lng = ~longitude, lat = ~latitude,
                 popup = ~as.character(Classification))
  })

  output$pd_table <- renderDataTable(table_data())

}
