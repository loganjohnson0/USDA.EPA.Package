
library(foodRecall)


# ui object
ui <- fluidPage(
  titlePanel(p("FoodRecall", style = "color:#3474A7")),
  sidebarLayout(
    sidebarPanel(
      textInput("api_key", "Enter your API key from FDA:"),
      textInput("city", "City"),
      textInput("country", "Country"),
      textInput("recalling_firm", "Recalling Firm"),
      textInput("state", "State"),
      textInput("status", "Status of the Recall"),
      selectInput("status", "Select Recall Status:",
                  choices = c("", "OnGoing", "Terminated", "Completed", "Pending"),
                  selected = ""),
      br(),
      actionButton("submit_button", "Submit"),
      br(),
      actionButton("clear_button", "Clear")

    ),
    mainPanel(
      tableOutput(outputId = "recall_table")
    )
  )
)

server <- function(input, output) {

  # Create reactive values for storing recall data and search results
  recall_data <- reactiveValues()
  search_results <- reactiveValues()

  # Function to update search results when submit button is pressed
  observeEvent(input$submit_button, {
    # Call the recall_location() function and store results in recall_data
    recall_data$recall_df <- foodRecall::recall_location(api_key = api_key,
                                                         city = input$city,
                                                         country = input$country,
                                                         recalling_firm = input$recalling_firm,
                                                         state = input$state,
                                                         status = input$status)
    })

  # Function to clear search results when clear button is pressed
  observeEvent(input$clear_button, {
    recall_data$recall_df <- NULL
    })

  # Render the table of search results
  output$recall_table <- renderTable({
    recall_data$recall_df
    })

}

shiny::shinyApp(ui,server)
