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



