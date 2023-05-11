
library(foodRecall)
library(leaflet)


# ui object
ui <- fluidPage(
  tabsetPanel(
    tabPanel("Table",
             sidebarLayout(
               sidebarPanel(
                 textInput("api_key", "Enter your API key from FDA:"),
                 textInput("city", "City"),
                 textInput("country", "Country"),
                 textInput("recalling_firm", "Recalling Firm"),
                 #textInput("initiation", "Recall Initiation Date"),
                 textInput("state", "State"),
                 #textInput("product", "Product discription"),
                 selectInput("status", "Select Recall Status:",
                             choices = c("", "OnGoing", "Terminated", "Completed", "Pending"),
                             selected = ""),
                 br(),
                 actionButton("submit_button", "Submit"),
                 br(),
                 actionButton("clear_button", "Clear")),
               mainPanel(
                 tableOutput(outputId = "recall_table")
               ),
             ),
            ),
    tabPanel("Map",
             mainPanel(
               leafletOutput("map", height = "600")  #fill whole screen with map
             )
            ),
    tabPanel("Date",
             sidebarLayout(
               sidebarPanel(
                 textInput("api_key2", "Enter your API key from FDA:"),
                 #textInput("city", "City"),
                 #textInput("country", "Country"),
                 textInput("recalling_firm2", "Recalling Firm"),
                 #textInput("initiation", "Recall Initiation Date"),
                 dateInput("initiation", "Select Recall Initiation Date", value = Sys.Date()),
                 #textInput("state", "State"),
                 textInput("product", "Product discription"),
                 selectInput("status2", "Select Recall Status:",
                             choices = c("", "OnGoing", "Terminated", "Completed", "Pending"),
                             selected = ""),
                 br(),
                 actionButton("submit_button2", "Submit"),
                 br(),
                 actionButton("clear_button2", "Clear")),
             mainPanel(
               tableOutput(outputId = "date")
             ),
          ),
      ),
    tabPanel("Map2",
             mainPanel(
               leafletOutput("map2", height = "600")  #fill whole screen with map
             )
    ),
  ),
  #titlePanel(p("FoodRecall", style = "color:#3474A7")),
  fillPage = TRUE # fill the whole screen with the app
)

server <- function(input, output) {

  # Create reactive values for storing recall data and search results
  recall_data <- reactiveValues()
  search_results <- reactiveValues()

  # Function to update search results when submit button is pressed
  observeEvent(input$submit_button, {
    # Call the recall_location() function and store results in recall_data
    recall_data$recall_df <- foodRecall::recall_location(api_key = input$api_key,
                                                         city = input$city,
                                                         country = input$country,
                                                         recalling_firm = input$recalling_firm,
                                                         state = input$state,
                                                         status = input$status)
    })

  observeEvent(input$submit_button2, {
   recall_data$recall_dt <- foodRecall::recall_date(api_key = input$api_key2,
                                                    product_description = input$product,
                                                    recalling_firm = input$recalling_firm,
                                                    recall_initiation_date = format(input$initiation, "%m-%d-%Y")
   )
  })

  # Function to clear search results when clear button is pressed
  observeEvent(input$clear_button, {
    recall_data$recall_df <- NULL
    })

  observeEvent(input$clear_button2, {
    recall_data$recall_dt <- NULL
  })

  # Render the table of search results
  output$recall_table <- renderTable({
    recall_data$recall_df
    })
  output$date <- renderTable({
    recall_data$recall_dt
  })
  output$map <- renderLeaflet({(map_recall(data = recall_data$recall_df))
    })
  output$map2 <- renderLeaflet({(map_recall(data = recall_data$recall_dt))
  })

}

shiny::shinyApp(ui,server)
