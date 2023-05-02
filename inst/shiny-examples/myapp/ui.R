library(leaflet)
library(shiny)
library(DT)
library(tidyverse)

#' @importFrom leaflet leafletProxy, clearMarkers, addMarkers

# ui object
ui <- fluidPage(
  titlePanel(p("Presslog Calls in Ames Iowa", style = "color:#3474A7")),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "crimeClassify",
        label = "Select a class of crime",
        ## please modify the selected option after updating the classification
        choices = c("All",
                    'Alcohol Related',
                    'Violence Related',
                    'Non-Violence Related',
                    'Vehicle Related',
                    'Fraud Related',
                    'License Related',
                    'Drug Related',
                    'Miscellaneous'),
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
      dataTableOutput((outputId = "pd_table"))
    )
  )
)



