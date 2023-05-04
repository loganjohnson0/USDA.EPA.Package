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

  input_count <- sum(!is.null(city),
                     !is.null(country),
                     !is.null(distribution_pattern),
                     !is.null(recalling_firm),
                     !is.null(state),
                     !is.null(status))

  if (input_count > 1) {
    search_mode <- readline(
"Choose the search mode:

'AND' for exact matches
'OR' for any combinations")

    while (search_mode != "AND" && search_mode != "OR") {
      search_mode <- readline("Invalid input. Enter either 'AND' or 'OR': ")
    }
    search_mode <- paste0("+", search_mode, "+")
  }

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

  if (!is.null(distribution_pattern)) {
    distribution_pattern <- strsplit(distribution_pattern, ", ")[[1]]
    distribution_pattern <- gsub(" ", "+", distribution_pattern)
    distribution_pattern_search <- NULL

    if (length(distribution_pattern) == 1) {
      distribution_pattern_search <- paste0("distribution_pattern:(%22",distribution_pattern, "%22)")
    } else {
      distribution_pattern_search <- paste0("%22", distribution_pattern, "%22", collapse = "+OR+")
      distribution_pattern_search <- paste0("distribution_pattern:(", distribution_pattern_search, ")")
    }
  }
  if (is.null(distribution_pattern)) {
    distribution_pattern_search <- NULL
  }

  if (!is.null(recalling_firm)) {
    recalling_firm <- strsplit(recalling_firm, ", ")[[1]]
    recalling_firm <- gsub(" ", "+", recalling_firm)
    recalling_firm_search <- NULL

    if (length(recalling_firm) == 1) {
      recalling_firm_search <- paste0("recalling_firm:(%22",recalling_firm, "%22)")
    } else {
      recalling_firm_search <- paste0("%22", recalling_firm, "%22", collapse = "+OR+")
      recalling_firm_search <- paste0("recalling_firm:(", recalling_firm_search, ")")
    }
  }
  if (is.null(recalling_firm)) {
    recalling_firm_search <- NULL
  }

  if (!is.null(state)) {

    state_vector <- unlist(strsplit(state, ", "))

    state_vector_abbrev <- sapply(state_vector, function(x) {
      x_lower <- tolower(x)
      state_name_lower <- tolower(state.name)
      if (x_lower %in% state_name_lower) {
        index <- match(x_lower, state_name_lower)
        return(state.abb[index])
      }
    })

    state <- state_vector_abbrev
    state <- gsub(" ", "+", state)
    state_search <- NULL

    if (length(state) == 1) {
      state_search <- paste0("state:(%22",state, "%22)")
    } else {
      state_search <- paste0("%22", state, "%22", collapse = "+OR+")
      state_search <- paste0("state:(", state_search, ")")
    }
  }
  if (is.null(state)) {
    state_search <- NULL
  }

  if (!is.null(status)) {
    status <- strsplit(status, ", ")[[1]]
    status <- gsub(" ", "+", status)
    status_search <- NULL

    if (length(status) == 1) {
      status_search <- paste0("status:(%22",status, "%22)")
    } else {
      status_search <- paste0("%22", status, "%22", collapse = "+OR+")
      status_search <- paste0("status:(", state_search, ")")
    }
  }
  if (is.null(status)) {
    status_search <- NULL
  }


  limit <- paste0("&limit=", limit)

  search_parameters <- list(city_search, country_search, distribution_pattern_search, recalling_firm_search, state_search, status_search)

  search_parameters <- search_parameters[!sapply(search_parameters, is.null)]

  search_string <- paste0(search_parameters, collapse = search_mode)

  url <- paste0(base_url, search_string, limit)

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
