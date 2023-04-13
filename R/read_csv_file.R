#' Read CSV files
#'
#' @param file_path The path to the CSV file
#' @return A data frame with the contents of the CSV file
#' @export
read_csv_file <- function(file_path) {
  data <- read.csv(file_path)
  return(data)
}

