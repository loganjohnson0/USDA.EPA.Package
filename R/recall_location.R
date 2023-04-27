#' This function scrapes the FDA website for food product recall data
#'
#' @param api_key Your free api key from FDA website
#' @param limit The number of rows to return for that query
#' @param city City where food was produced
#' @param country The country where the food was produced
#' @param distribution_pattern Locations where food was distributed to
#' @param recalling_firm The company recalling the product
#' @param state The U.S. state in which the recalling firm is located
#' @param status The status of the recall
#'
#' @importFrom dplyr arrange
#' @importFrom dplyr mutate
#' @importFrom dplyr  %>%
#' @importFrom dplyr mutate_all
#' @importFrom httr content
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#' @importFrom lubridate ymd
#' @importFrom tibble tibble
#' @export
recall_location <- function(api_key,
                            limit,
                            city = NULL,
                            country = NULL,
                            distribution_pattern = NULL,
                            recalling_firm = NULL,
                            state = NULL,
                            status = NULL) {

  base_url <- paste0("https://api.fda.gov/food/enforcement.json?api_key=", api_key, "&search=")

  if (!is.null(city)) {
    city <- strsplit(city, ", ")[[1]]
    city <- gsub(" ", "+", city)
    city_search <- NULL

    if (length(city) == 1) {
      city_search <- paste0("city:(%22",city, "%22)")
    } else {
      city_search <- paste0("%22", city, "%22", collapse = "+OR+")
      city_search <- paste0("city:(", city_search, ")")
    }
  }
  if (is.null(city)) {
    city_search <- NULL
  }

  if (!is.null(country)) {
    country <- strsplit(country, ", ")[[1]]
    country <- gsub(" ", "+", country)
    country_search <- NULL

    if (length(country) == 1) {
      country_search <- paste0("country:(%22",country, "%22)")
    } else {
      country_search <- paste0("%22", country, "%22", collapse = "+OR+")
      country_search <- paste0("country:(", country_search, ")")
    }
  }
  if (is.null(country)) {
    country_search <- NULL
  }

  limit <- paste0("&limit=", limit)

  url <- paste0(base_url, city_search, "+AND+", country_search, limit)

  fda_data <- httr::GET(url = url)

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
    dplyr::arrange(desc(report_date)) %>%
    dplyr::arrange((city))


  return(new_stuff)
}
