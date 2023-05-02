#' @importFrom lubridate date, mdy_hm
data <- read.csv("") %>%
  mutate(Date.Reported = lubridate::date(mdy_hm(Date.Time.Reported)))

server <- function(input, output) {

  filtered_data <- reactive({
    classification_filter <- evaluate_classification(input$)

    data %>%

      filter(between()) %>%

      # classification filter
      filter(Category %in% classification_filter)
  })

  table_data <- reactive({
    classification_filter <- evaluate_classification()

    data %>%
      filter(between()) %>%

      # classification filter
      filter(Category %in% classification_filter) %>%

      select(state,
             city)

  })

  output$map <- renderLeaflet({

    leaflet(data) %>% addTiles() %>%
      fitBounds(~min(longitude), ~min(latitude), ~max(longitude), ~max(latitude))
  })

  observe({
    leaflet::leafletProxy("map", data = filtered_data()) %>%
      leaflet::clearMarkers() %>%
      leaflet::addMarkers(lng = ~longitude, lat = ~latitude,
                 popup = ~as.character(Classification))
  })

  output$table <- renderDataTable(table_data())

}
