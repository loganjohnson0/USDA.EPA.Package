#' This function scrapes the CDC website for a List of Multistate Foodborne Outbreak Notices
#'
#' @param x Need to update the input functionality of the function
#'
#' @importFrom dplyr bind_rows
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom dplyr %>%
#' @importFrom netstat free_port
#' @importFrom readr write_csv
#' @importFrom RSelenium remoteDriver
#' @importFrom rvest html_nodes
#' @importFrom rvest html_text2
#' @importFrom wdman selenium
#' @importFrom xml2 read_html
#' @export
get_cdc <- function(x) {

  rD <- RSelenium::rsDriver(browser = "chrome",
                            chromever = "112.0.5615.49",
                            verbose = FALSE,
                            port = netstat::free_port(random = TRUE),
                            iedrver = NULL)

  remDr <- rD[["client"]]

  remDr$navigate("https://www.cdc.gov/foodsafety/outbreaks/lists/outbreaks-list.html")

  remDr$screenshot(display = TRUE)

  doc <- xml2::read_html(remDr$getPageSource()[[1]])

  first_cdc_table <- doc %>%
    rvest::html_nodes("#DataTables_Table_0") %>%
    rvest::html_table()

  combined <- first_cdc_table[[1]]

  last_page <- doc %>%
    rvest::html_node("#DataTables_Table_0_ellipsis+ .page-item .page-link") %>%
    rvest::html_text() %>%
    as.numeric()

  for (i in 1:last_page) {
    if (i > 1) {
      element <- remDr$findElement(using = 'css selector', "#DataTables_Table_0_next .page-link")
      element$clickElement()
      Sys.sleep(1)
      remDr$screenshot(display = TRUE)
      doc <- xml2::read_html(remDr$getPageSource()[[1]])

      cdc_table <- doc %>%
        rvest::html_nodes("#DataTables_Table_0") %>%
        rvest::html_table()
      cdc_table <- cdc_table[[1]]
      combined <- dplyr::bind_rows(combined, cdc_table)
    }
  }
  # readr::write_csv(combined, file = "2023_04_11_CDC_Data.csv")
  return(combined)
  remDr$close()
}
