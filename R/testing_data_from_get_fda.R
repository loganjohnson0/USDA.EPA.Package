# Author: Kelly Nascimento Thompson
# Date: April 14th, 2023

# This is not a package function yet, but rather a script to see what I can achieve with the data.
# Format columns to appropriate format
# Created a data frame based on my API key
# not sure if it's gonna work for everybody

library(tidyverse)
library(lubridate)

# Data frame with API key requested by me
df <- foodRecall::get_fda(api_key = "boOnnTwLyH8uBFVOVxTpoLH6qcKE4dvyWggMIRwt")

# changing empty values to NA
df <- df %>% mutate_all(~replace(., . == "", NA))

# converting event ID to numeric
df$event_id <- as.numeric(df$event_id)

#convert date columns to a lubridate variable
df$report_date <- ymd(df$report_date)
df$recall_initiation_date <- ymd(df$recall_initiation_date)
df$center_classification_date <- ymd(df$center_classification_date)

# arranging the rows from "report_date" column in chronological order
df <- arrange(df,desc(report_date))

# add year of "report_date" as a column named "report_year", so later we can visualize
# classification types (Class I, Class II, Class III) of recall by year and state, for instance
# add day of the week as a column
df <- df %>% mutate(report_year = year(report_date))

# use ggplot to create the barchart
# draw a barchart of the number of food recalls by year, color by classification type
df %>% ggplot(aes(x = report_year,
                            fill = classification))+
  geom_bar() +
  labs(title = "Food Recalls by Year by Classification Type") +
  ylab("Number of Food Recalls") +
  xlab("")

#create a "full_address" column to start the geocoding process
df1 <- df
df1$full_address <- paste(df1$address_1, df1$city, df1$state, df1$postal_code)

# geocode FDA food recall addresses to plot them on a map
library(dplyr, warn.conflicts = FALSE)
library(tidygeocoder)
library(ggplot2)

#Citing tidygeocoder
citation('tidygeocoder')

# geocode the addresses
# create data frame containing addresses with latitude and longitude
lat_longs <- df1 %>%
  geocode(full_address, method = 'osm', lat = latitude , long = longitude)

ggplot(lat_longs, aes(longitude, latitude), color = "grey99") +
  borders("state") + geom_point() +
  theme_void()

# 288 addresses did not output latitude and longitude, need to find out how to fix that.
