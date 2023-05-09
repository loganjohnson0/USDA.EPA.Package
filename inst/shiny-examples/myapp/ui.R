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
      selectInput("status", "Select Recall Status:",
                  choices = c("", "Ongoing", "Terminated", "Completed", "Pending"),
                  selected = "")
    ),
    mainPanel(
      tableOutput("recall_table")
    )
  )
)



