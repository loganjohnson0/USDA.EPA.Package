library(leaflet)
library(shiny)
library(DT)
library(tidyverse)

#' @importFrom leaflet leafletProxy, clearMarkers, addMarkers

# ui object
ui <- fluidPage(
  titlePanel(p("FoodRecall", style = "color:#3474A7")),
  numericInput("num1", "Enter the first number:", value = 1),
  numericInput("num2", "Enter the second number:", value = 2),
  verbatimTextOutput("result")
)



