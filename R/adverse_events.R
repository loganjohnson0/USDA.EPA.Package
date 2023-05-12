
create_search_param <- function(input, param_name) {
  if (!is.null(input)) {
    input <- strsplit(input, ", ")[[1]]
    input <- gsub(" ", "+", input)
    param_search <- NULL

    if (length(input) == 1) {
      param_search <- paste0(param_name, ":(%22", input, "%22)")
    } else {
      param_search <- paste0("%22", input, "%22", collapse = "+OR+")
      param_search <- paste0(param_name, ":(", param_search, ")")
    }
  } else {
    param_search <- NULL
  }
  return(param_search)
}
date_search_param <- function(input, param_name) {
  if (!is.null(input)) {
    if(!is.character(input)) {
      stop("Please enter the date as a character vector. Example: '01-01-2023' or 'January 1, 2023'")
    } else {
      input <- strsplit(input, " to ")[[1]]
      input_search <- NULL
      if (length(input) == 1) {
        input <- lubridate::parse_date_time(input, orders = c("ymd", "mdy", "dmy", "Y", "my"), quiet = TRUE)
        # warning(sprintf("Defaulting to a range of %s to %s.", input, lubridate::today()))
        today <- lubridate::today()
        input <- gsub("-", "", input)
        today <- gsub("-", "", today)
        input <- paste0(input, "+TO+", today)
        input_search <- paste0(param_name,":([", input, "])")
      }
      if (length(input) > 2) {
        stop("Please enter only two date options.")
      } else if (length(input) == 2) {
        input <- lubridate::parse_date_time(input, orders = c("ymd", "mdy", "dmy", "Y", "my"), quiet = TRUE)
        input <- gsub("-", "", input)
        input <- paste0(input, collapse = "+TO+")
        input_search <- paste0(param_name,":([", input, "])")
      }
    }
  } else {
    input_search <- NULL
  }
  return(input_search)
}
#' This function scrapes the FDA website for food product recall data
#'
#' @param api_key Your free api key from FDA website
#' @param limit The number of rows to return for that query
#' @param consumer.gender A way the FDA classifies a date
#' @param consumer.age Description of product
#' @param consumer.age_unit Date for which recall was initiated
#' @param date_created The company recalling the product
#' @param date_started The date the FDA issued the enforcement report for the product recall
#' @param outcomes This gives the user flexibility to search for exact matches of inputs or any combination of inputs
#' @param products.name_brand The status of the recall
#' @param products.industry_name The date the recall was terminated
#' @param products.industry_code The date the recall was terminated
#' @param reactions The date the recall was terminated
#' @param report_number The date the recall was terminated
#' @param search_mode The way to search for the data
#'
#' @importFrom dplyr arrange
#' @importFrom dplyr desc
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_all
#' @importFrom httr content
#' @importFrom httr GET
#' @importFrom httr status_code
#' @importFrom jsonlite fromJSON
#' @importFrom lubridate parse_date_time
#' @importFrom lubridate ymd
#' @importFrom lubridate today
#' @importFrom tibble tibble
#' @importFrom tidyr unnest
#' @export
adverse_events <- function(api_key,
                           consumer.gender = NULL,
                           consumer.age = NULL,
                           consumer.age_unit = NULL,
                           date_created = NULL,
                           date_started = NULL,
                           limit = NULL,
                           outcomes = NULL,
                           products.name_brand = NULL,
                           products.industry_name = NULL,
                           products.industry_code = NULL,
                           reactions = NULL,
                           report_number = NULL,
                           search_mode = NULL) {

  product_role <- NULL

  date_created_search <- date_search_param(date_created, "date_created")
  date_started_search <- date_search_param(date_started, "date_started")

  products.name_brand_search <- create_search_param(products.name_brand, "products.name_brand")
  products.industry_name_search <- create_search_param(products.industry_name, "products.industry_name")
  products.industry_code_search <- create_search_param(products.industry_code, "products.industry_code")

  reactions_search <- create_search_param(reactions, "reactions")
  outcomes_search <- create_search_param(outcomes, "outcomes")
  consumer.gender_search <- create_search_param(consumer.gender, "consumer.gender")

  if (!is.null(limit)) {
    if (limit > 1000){
      warning("The openFDA API is limited to 1000 results per API call. Defaulting to 1000 results. Try a more specific search to return a dataset that contains all of the desired results.")
      limit <- paste0("&limit=", 1000)
    } else {
      limit <- paste0("&limit=", limit)
    }
  } else {
    limit <- paste0("&limit=", 1000)
  }

  if (!is.null(search_mode)) {
    search_mode <- toupper(search_mode)
    while (search_mode != "AND" && search_mode != "OR") {
      search_mode <- readline("Invalid input. Enter either 'AND' or 'OR':")
    }
    search_mode <- paste0("+", search_mode, "+")
  } else {
    search_mode <- "+AND+"
  }

  base_url <- paste0("https://api.fda.gov/food/event.json?api_key=", api_key, "&search=")

  search_parameters <- list(date_created_search,
                            date_started_search,
                            products.name_brand_search,
                            products.industry_name_search,
                            products.industry_code_search,
                            reactions_search,
                            outcomes_search,
                            consumer.gender_search)

  search_parameters <- search_parameters[!sapply(search_parameters, is.null)]

  search_string <- paste0(search_parameters, collapse = search_mode)

  url <- paste0(base_url, search_string, limit)

  fda_data <- httr::GET(url = url)

  data <- jsonlite::fromJSON(httr::content(fda_data, "text"))

  if ("error" %in% names(data)) {
    if (data$error$message == "No matches found!") {
      print("No matches were found for the given input.")
    }
  } else if (fda_data$status_code !=200) {
    stop("The API call failed. Make sure the inputs were entered correctly. Retry the request again.")
  }

  if (data$meta$results$total >1000) {
    warning("The total number of results is greater than the number of returned results; therefore, the returned results may be an incomplete representation of the data. Try a more specific search criteria to return a more complete dataset containing all the desired results.")
  }

  new_stuff <- tibble::tibble(report_number = data$results$report_number,
                              outcomes = sapply(data$results$outcomes, paste0, collapse = ", "),
                              date_started = data$results$date_started,
                              date_created = data$results$date_created,
                              consumer_age = data$results$consumer$age,
                              consumer_age_unit = data$results$consumer$age_unit,
                              consumer_gender = data$results$consumer$gender,
                              reactions = sapply(data$results$reactions, paste0, collapse = ", "),
                              product_role = data$results$products)

  new_stuff <- new_stuff %>%
    tidyr::unnest(cols = product_role)

  new_stuff <- new_stuff %>%
    dplyr::mutate_all(~replace(., . == "", NA)) %>%
    dplyr::mutate(
      date_started = as.character(lubridate::ymd(date_started)),
      date_created = as.character(lubridate::ymd(date_created))) %>%
    dplyr::arrange(dplyr::desc(date_started))

  return(new_stuff)
}
