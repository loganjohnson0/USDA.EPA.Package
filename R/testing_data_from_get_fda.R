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
