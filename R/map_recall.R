#' Function for getting lat and long data from addresses
#'
#' @param data The dataframe used as input with addresses to map latitude and longitudinally
#'
#' @importFrom dplyr mutate
#' @importFrom leaflet leaflet
#' @importFrom leaflet addProviderTiles
#' @importFrom leaflet addMarkers
#' @importFrom tidygeocoder geocode
#' @export
map_recall <- function(data) {

  address_1 <- NULL
  city <- NULL
  state <- NULL
  postal_code <- NULL
  full_address <- NULL
  longitude <- NULL
  latitude <- NULL

  data <- data %>%
    dplyr::mutate(full_address = paste(address_1, city, state, postal_code))

  data <- data %>%
    tidygeocoder::geocode(full_address, method = 'arcgis', lat = latitude, long = longitude)

  plot <- leaflet::leaflet() %>%
    leaflet::addProviderTiles("Stamen.Toner") %>%
    leaflet::addMarkers(
      data = data,
      lat = ~ latitude,
      lng = ~ longitude,
      label =  ~ as.character(recalling_firm),
      labelOptions = leaflet::labelOptions(noHide = F, direction = 'auto'))

  plot

}
