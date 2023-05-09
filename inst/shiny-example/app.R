library(leaflet)
library(shiny)
library(DT)
library(tidyverse)

#' @importFrom leaflet leafletProxy, clearMarkers, addMarkers

# ui object
ui <- fluidPage(
  titlePanel(p("FoodRecall", style = "color:#3474A7")),
  sidebarLayout(
    sidebarPanel(
      textInput("api_key", "Enter your API key from FDI:"),
      numericInput("limit", "Limit", value = 1000),
      textInput("city", "City"),
      #textInput("country", "Country"),
      #textInput("distribution_pattern", "Distribution Pattern"),
      textInput("recalling_firm", "Recalling Firm"),
      #radioButtons("search_mode", "Search Mode", choices = c("AND", "OR"), selected = "AND"),
      #textInput("state", "State"),
      #textInput("status", "Status"),
      selectInput("status", "Select Recall Status:",
                  choices = c("", "Ongoing", "Terminated", "Completed", "Pending"),
                  selected = ""),
      br(),
      actionButton("submit_button", "Submit"),
      br(),
      actionButton("clear_button", "Clear")

    ),
    mainPanel(
      tableOutput("recall_table")
    )
  )
)





#' @importFrom lubridate date, mdy_hm


server <- function(input, output) {

  api_key <- "kgeTDxh6dhWwVpfa7fEzfbxFuqbeMpWe6gobqpcM"

  # Create reactive values for storing recall data and search results
  recall_data <- reactiveValues()
  search_results <- reactiveValues()

  # Function to update search results when submit button is pressed
  observeEvent(input$submit_button, {
    # Call the recall_location() function and store results in recall_data
    recall_data$recall_df <- recall_location(api_key = api_key,
                                             limit = input$limit,
                                             city = input$city,
                                             #country = input$country,
                                             #distribution_pattern = input$distribution_pattern,
                                             recalling_firm = input$recalling_firm,
                                             #search_mode = input$search_mode,
                                             state = input$state,
                                             status = input$status)

    # Filter the recall data based on user inputs and store in search_results
    search_results$search_df <- recall_data$recall_df %>%
      filter(recalling_firm %in% input$recalling_firm) %>%
      filter(city %in% input$city) %>%
      filter(state %in% input$state) %>%
      #filter(country %in% input$country) %>%
      #filter(distribution_pattern %in% input$distribution_pattern) %>%
      filter(status %in% input$status)
  })

  # Function to clear search results when clear button is pressed
  observeEvent(input$clear_button, {
    search_results$search_df <- NULL
  })

  # Render the table of search results
  output$recall_table <- renderDataTable({
    if (!is.null(search_results$search_df)) {
      search_results$search_df
    } else {
      recall_data$recall_df
    }
  })

  # output$recall_table <- renderTable({
  #
  #   # Get the input values
  #   status <- input$status
  #
  #   # Call the recall_location() function
  #   recall_data <- recall_location(api_key = api_key, status = status)
  #
  #   # Process the data and return the table
  #   recall_data %>%
  #     select(recall_number, recalling_firm, recall_initiation_date, status) %>%
  #     arrange(desc(recall_initiation_date))
  #
  # })

}

shiny::shinyApp(ui,server)
