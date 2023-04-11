
# docker run --rm -it -p 4444:4444 -p 5900:5900 -p 7900:7900 --shm-size 2g seleniarm/standalone-chromium:latest

#' This function scrapes the FDA website for food product recall data
#'
#' @importFrom dplyr bind_rows
#' @importFrom readr write_csv
#' @importFrom RSelenium remoteDriver
#' @importFrom rvest html_nodes
#' @importFrom rvest html_table
#' @importFrom xml2 read_html
get_fda <- function(x) {

  remDr <- RSelenium::remoteDriver(remoteServerAddr = "localhost",
                                   port = 4444,
                                   browserName = "chrome")
  remDr$open()

  remDr$navigate("https://www.fda.gov/safety/recalls-market-withdrawals-safety-alerts")

  remDr$screenshot(display = TRUE)

  doc <- xml2::read_html(remDr$getPageSource()[[1]])

  first_table_fda <- doc %>%
    rvest::html_nodes("#datatable") %>%
    rvest::html_table()

  first_table_fda <- first_table_fda[[1]]

  # last_page <- doc %>%
  #   rvest::html_node("#datatable_ellipsis+ .paginate_button a") %>%
  #   rvest::html_text() %>%
  #   as.numeric()

  combined <- NULL

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
      combined <- dplyr::bind_rows(first_table_fda, fda_table)
    }
  }
  readr::write_csv(combined, file = "FDA_Data.csv")
  return(combined)
  remDr$close()
}

get_fda(x)
