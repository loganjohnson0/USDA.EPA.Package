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
      selectInput(
        inputId = "Classify",
        label = "Select part of FDA",
        ## please modify the selected option after updating the classification
        choices = c("All",
                    '',
                    'Related'),
        selected = "All"
      ),
      dateRangeInput(inputId =  'date',
                     label = 'Years',
                     start = "2012-01-01",
                     end = "2012-01-02",
                     min = "2012-01-01",
                     format = "yyyy-mm-dd")
    ),

    mainPanel(
      leafletOutput(outputId = "map"),
      dataTableOutput((outputId = ""))
    )
  )
)



