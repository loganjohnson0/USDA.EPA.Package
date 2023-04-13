#' #' This function plots the FDA website data for food product recall.
#' #'
#' #' @param x Need to update the input functionality of the function
#' #'
#' #' @importFrom dplyr %>%
#' #' @importFrom readr read_csv
#' #' @importFrom tidyverse ggplot2
#' #' @importFrom lubridate ymd_hms
#' #' @export
#'
#' plot_fda_data <- function(x) {
#'   # Read in CSV data
#'   fda_csv <- list.files(paste(getwd(),
#'                               "/_FDA_/"),
#'                         pattern="*.csv", full.names=TRUE)
#'
#'   data <- read.csv(fda_csv)
#'
#'   #convert time to a lubridate variable
#'   data <- fda_csv$Date <- ymd_hms(fda_csv$Date, tz = "US/Central")
#'
#'   # Create scatter plot
#'   ggplot(data, aes(x = x_variable, y = y_variable)) +
#'     geom_point()
#' }

#' Plot CSV data
#'
#' This function loads a CSV file from the package's data directory and creates a plot.
#'
#' @param filename The name of the CSV file to load.
#' @return A ggplot2 plot object.
#' @examples
#' plot_csv_data("data_file.csv")
plot_csv_data <- function(filename) {
  csv_files <- list.files(pattern = "^2023_.*\\.csv$")
  data_file <- system.file(csv_files, filename, package = "foodRecall")
  data <- read.csv(data_file)
  ggplot(data, aes(x = x_var, y = y_var)) + geom_point()
}
