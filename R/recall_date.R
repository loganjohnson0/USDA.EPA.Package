#' This function scrapes the FDA website for food product recall data
#'
#' @param api_key Your free api key from FDA website
#' @param limit The number of rows to return for that query
#' @param center_classification_date A way the FDA classifies a date
#' @param product_description Description of product
#' @param recall_initiation_date Date for which recall was initiated
#' @param recalling_firm The company recalling the product
#' @param report_date The date the FDA issued the enforcement report for the product recall
#' @param status The status of the recall
#' @param termination_date The date the recall was terminated
#'
#' @importFrom dplyr arrange
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_all
#' @importFrom httr content
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#' @importFrom lubridate ymd
#' @importFrom tibble tibble
#' @export
recall_date <- function(api_key,
                        center_classification_date = NULL,
                        limit,
                        product_description = NULL,
                        recall_initiation_date = NULL,
                        recalling_firm = NULL,
                        report_date = NULL,
                        status = NULL,
                        termination_date = NULL) {

  center_classification_date <- NULL
  desc <- NULL

  url <- paste0("https://api.fda.gov/food/enforcement.json?api_key=", api_key, "&search=")

  if (!is.null(city)) {
    if (length(city) > 1) {

    } else
      search <- paste0(search, "city:", city)
  }

  limit <- paste0("&limit=", limit)

  fda_data <- httr::GET(url = paste0(url, search, limit))

  data <- jsonlite::fromJSON(httr::content(fda_data, "text"))

  new_stuff <- tibble::tibble(recall_number = data$results$recall_number,
                              recalling_firm = data$results$recalling_firm,
                              recall_initiation_date = data$results$recall_initiation_date,
                              center_classification_date = data$results$center_classification_date,
                              report_date = data$results$report_date,
                              termination_date = data$results$termination_date,
                              voluntary_mandated = data$results$voluntary_mandated,
                              classification = data$results$classification,
                              initial_firm_notification = data$results$initial_firm_notification,
                              status = data$results$status,
                              country = data$results$country,
                              state = data$results$state,
                              city = data$results$city,
                              address_1 = data$results$address_1,
                              address_2 = data$results$address_2,
                              postal_code = data$results$postal_code,
                              reason_for_recall = data$results$reason_for_recall,
                              product_description = data$results$product_description,
                              product_quantity = data$results$product_quantity,
                              code_info = data$results$code_info,
                              distribution_pattern = data$results$distribution_pattern,
                              event_id = data$results$event_id)


  new_stuff <- new_stuff %>%
    dplyr::mutate_all(~replace(., . == "", NA)) %>%
    dplyr::mutate(
      recall_initiation_date = lubridate::ymd(recall_initiation_date),
      report_date = lubridate::ymd(report_date),
      center_classification_date = lubridate::ymd(center_classification_date),
      termination_date = lubridate::ymd(termination_date)) %>%
    dplyr::arrange(desc(report_date))

  return(new_stuff)
}
