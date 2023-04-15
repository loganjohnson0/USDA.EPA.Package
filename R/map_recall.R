#' Function for getting lat and long data from addresses
#'
#' @param data The dataframe used as input with addresses to map latitude and longitudinally
#'
#' @importFrom dplyr mutate
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 borders
#' @importFrom ggplot2 theme_void
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
    tidygeocoder::geocode(full_address, method = 'osm', lat = "latitude" , long = "longitude") # Work on fixing issues with some addresses not finding lat & long

  plot <- ggplot2::ggplot(data, ggplot2::aes(longitude, latitude), color = "grey99") +
    ggplot2::borders("state") +
    ggplot2::geom_point() +
    ggplot2::theme_void()

  print(plot)

}


# # Author: Kelly Nascimento Thompson
# # Date: April 14th, 2023
#
# # This is not a package function yet, but rather a script to see what I can achieve with the data.
# # Format columns to appropriate format
# # Created a data frame based on my API key
# # not sure if it's gonna work for everybody
#
#
# # add year of "report_date" as a column named "report_year", so later we can visualize
# # classification types (Class I, Class II, Class III) of recall by year and state, for instance
# # add day of the week as a column
# df <- df %>% mutate(report_year = year(report_date))
#
# # use ggplot to create the barchart
# # draw a barchart of the number of food recalls by year, color by classification type
# df %>% ggplot(aes(x = report_year,
#                             fill = classification))+
#   geom_bar() +
#   labs(title = "Food Recalls by Year by Classification Type") +
#   ylab("Number of Food Recalls") +
#   xlab("")
#
# #create a "full_address" column to start the geocoding process
# df1 <- df
# df1$full_address <- paste(df1$address_1, df1$city, df1$state, df1$postal_code)
#
# # geocode FDA food recall addresses to plot them on a map
# library(dplyr, warn.conflicts = FALSE)
# library(tidygeocoder)
# library(ggplot2)
#
# #Citing tidygeocoder
# citation('tidygeocoder')
#
# # geocode the addresses
# # create data frame containing addresses with latitude and longitude
# lat_longs <- df1 %>%
#   geocode(full_address, method = 'osm', lat = latitude , long = longitude)
#
# ggplot(lat_longs, aes(longitude, latitude), color = "grey99") +
#   borders("state") + geom_point() +
#   theme_void()
#
# # 288 addresses did not output latitude and longitude, need to find out how to fix that.
