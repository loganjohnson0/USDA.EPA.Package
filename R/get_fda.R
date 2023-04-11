#' This function scrapes the FDA website for food product recall data
#'
#' @param x Need to update the input functionality of the function
#'
#' @importFrom dplyr bind_rows
#' @importFrom dplyr %>%
#' @importFrom netstat free_port
#' @importFrom readr write_csv
#' @importFrom RSelenium remoteDriver
#' @importFrom rvest html_nodes
#' @importFrom rvest html_table
#' @importFrom xml2 read_html
get_fda <- function(x) {

  rD <- RSelenium::rsDriver(browser = "chrome",
                            chromever = "112.0.5615.49",
                            verbose = FALSE,
                            port = netstat::free_port(random = TRUE),
                            iedrver = NULL)

  remDr <- rD[["client"]]

  remDr$navigate("https://www.fda.gov/safety/recalls-market-withdrawals-safety-alerts")

  remDr$screenshot(display = TRUE)

  doc <- xml2::read_html(remDr$getPageSource()[[1]])

  first_table_fda <- doc %>%
    rvest::html_nodes("#datatable") %>%
    rvest::html_table()

  combined <- first_table_fda[[1]]

  last_page <- doc %>%
    rvest::html_node("#datatable_ellipsis+ .paginate_button a") %>%
    rvest::html_text() %>%
    as.numeric()

  for (i in 1:2) { # This doesn't work with the "last page element"
    if (i > 1) {
      element <- remDr$findElement(using = 'css selector', "#datatable_next a")
      element$clickElement()
      Sys.sleep(1)
      remDr$screenshot(display = TRUE)
      doc <- xml2::read_html(remDr$getPageSource()[[1]])

      fda_table <- doc %>%
        rvest::html_nodes("#datatable") %>%
        rvest::html_table()
      fda_table <- fda_table[[1]]
      combined <- dplyr::bind_rows(combined, fda_table)
    }
  }
  # readr::write_csv(combined, file = "2023_04_11_FDA_Data.csv")
  return(combined)
  remDr$close()
}
