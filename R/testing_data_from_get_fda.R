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
