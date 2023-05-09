#' @importFrom lubridate date, mdy_hm


server <- function(input, output) {

  api_key <- "kgeTDxh6dhWwVpfa7fEzfbxFuqbeMpWe6gobqpcM"

  output$recall_table <- renderTable({

    # Get the input values
    status <- input$status

    # Call the recall_location() function
    recall_data <- recall_location(api_key = api_key, status = status)

    # Process the data and return the table
    recall_data %>%
      select(recall_number, recalling_firm, recall_initiation_date, status) %>%
      arrange(desc(recall_initiation_date))

  })

}
