#' This function scrapes the USDA-FSIS website for food product recall data
#' docker run --rm -it -p 4444:4444 -p 5900:5900 -p 7900:7900 --shm-size 2g seleniarm/standalone-chromium:latest
#' @importFrom dplyr bind_rows
#' @importFrom dplyr group_by
#' @importFrom dplyr mutate
#' @importFrom readr write_csv
#' @importFrom RSelenium remoteDriver
#' @importFrom rvest html_nodes
#' @importFrom rvest html_text2
#' @importFrom wdman selenium
#' @importFrom xml2 read_html
get_usda_fsis <- function(x) {

  # I commented this out to help the devtools::check() process easier

  remDr <- RSelenium::remoteDriver(remoteServerAddr = "localhost",
                                    port = 4444,
                                    browserName = "chrome")
  remDr$open()

  # Working on this. There might be an easier way than I did.

  # selenium_object <- selenium(retcommand = T,
  #                             check = F)
  #
  # remDr <- RSelenium::rsDriver(browser = "chrome",
  #                              chromever = "106.0.5249.21",
  #                              verbose = FALSE,
  #                              port = 4445L)
  #
  # remDr[['cliet']]
  results_list <- list()
  results <- data.frame()

  page_number <- 0:2 # Need to add more functionality and input capabilities here

  for (i in page_number) {
  usda_web_page <- sprintf("https://www.fsis.usda.gov/recalls?page=%s", i)

  remDr$navigate(usda_web_page)

  Sys.sleep(1)

  remDr$screenshot(display = TRUE)

  doc <- xml2::read_html(remDr$getPageSource()[[1]])

  node <- doc %>%
    rvest::html_nodes("#main-content .view__row")

  for (j in 1:length(node)) {
    usda_states_affected <- node[[j]] %>%
      rvest::html_nodes(".recall-teaser__states ") %>%
      rvest::html_text2()

    usda_establishment <- node[[j]] %>%
      rvest::html_nodes(".recall-teaser__establishment a") %>%
      rvest::html_text2()

    usda_case_number <- node[[j]] %>%
      rvest::html_nodes(".recall-teaser__tags .tag--active") %>%
      rvest::html_text2()

    usda_recall_reason <- node[[j]] %>%
      rvest::html_nodes(".tag--reason") %>%
      rvest::html_text2()

    usda_date <- node[[j]] %>%
      rvest::html_nodes(".recall-teaser__date") %>%
      rvest::html_text2()

    if (length(usda_states_affected) == 0) {
      usda_states_affected <- NA
    }
    if (length(usda_establishment) == 0) {
      usda_establishment <- NA
    }
    if (length(usda_case_number) == 0) {
      usda_case_number <- NA
    }
    if (length(usda_recall_reason) == 0) {
      usda_recall_reason <- NA
    }
    if (length(usda_date) == 0) {
      usda_date <- NA
    }

    temp <- data.frame(case_number = usda_case_number,
                       recall_reason = usda_recall_reason,
                       establishment = usda_establishment,
                       states = usda_states_affected,
                       date = usda_date)

    results <- dplyr::bind_rows(results, temp)
  }
  results_list[[i+1]] <- results
  }

  final_results <- dplyr::bind_rows(results_list) %>%
    dplyr::group_by(case_number) %>%
    dplyr::mutate(recall_reason = paste(recall_reason, collapse=", ")) %>%
    distinct()

  readr::write_csv(final_results, file = "USDA-FSIS.csv")
  return(final_results)
  remDr$close()
}

get_usda_fsis(x)
