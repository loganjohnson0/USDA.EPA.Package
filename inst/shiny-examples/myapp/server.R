#' @importFrom lubridate date, mdy_hm


server <- function(input, output) {

  output$result <- renderPrint({
    sum_numbers(input$num1, input$num2)
  })

}
