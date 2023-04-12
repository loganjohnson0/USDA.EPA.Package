#' This function scrapes the FDA website for food product recall data
#'
#' @param x Need to update the input functionality of the function
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#' @importFrom tibble tibble
get_fda <- function(api_key,
                    address_1 = NULL,
                    address_2 = NULL,
                    center_classification_date = NULL,
                    city = NULL,
                    classification = NULL,
                    code_info = NULL,
                    country = NULL,
                    distribution_pattern = NULL,
                    event_id = NULL,
                    initial_firm_notifcation = NULL,
                    more_code_info = NULL,
                    product_code = NULL,
                    product_description = NULL,
                    product_quantity = NULL,
                    product_type = NULL,
                    reason_for_recall = NULL,
                    recall_inititaion_date = NULL,
                    recall_number = NULL,
                    recalling_firm = NULL,
                    report_date = NULL,
                    state = NULL,
                    status = Onoing,
                    termination_date = NULL,
                    voluntary_mandated = NULL) {

  if (!is.null(api_key)) {
    api_key <- paste0(api_key, "&")
  }


  core_url <- "https://api.fda.gov/food/enforcement.json?"
  search <- "search="
  key <- "api_key="
  api_key <- api_key
  status <- "status:Ongoing"
  limit <- "&limit=1000"

  fda_data <- httr::GET(url = paste0(core_url, key, api_key, search, status, limit))

  data <- jsonlite::fromJSON(content(fda_data, "text"))

  new_stuff <- tibble::tibble(recall_number = data$results$recall_number,
                  recalling_firm = data$results$recalling_firm,
                  recall_inititaion_date = data$results$recall_inititaion_date,
                  center_classification_date = data$results$center_classification_date,
                  report_date = data$results$report_date,
                  voluntary_mandated = data$results$voluntary_mandated,
                  classification = data$results$classification,
                  initial_firm_notifcation = data$results$initial_firm_notification,
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
                  more_code_info = data$results$more_code_info,
                  distribution_pattern = data$results$distribution_pattern,
                  event_id = data$results$event_id,
                  product_type = data$results$product_type)
  return(new_stuff)

}

