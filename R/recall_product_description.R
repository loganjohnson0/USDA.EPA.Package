# Author: Kelly Nayara Nascimento Thompson
# Date: 05-08-2023
# Test code to create a function that selects recalls based on product description

recall_product_description <- function(df, col_name, pattern) {
  filtered_data <- df[grep(pattern, df[[col_name]]), col_name]
  return(filtered_data)
}

df <- foodRecall::recall_location(api_key = api_key, limit = 1000, city = "Detroit, Minneapolis", state = "Michigan, Minnesota")

# Select any products with "Chocolate"
df1<- recall_product_description(df, "product_description", "Chocolate")

# Adjustments needed:
# the df1 data frame only outputs the "product description" column. I think it would be more informative
# to output all the 22 columns like the one found in df (foodRecall::recall_location), where the cities of Detroit and Minneapolis were
# selected.
# If we could select multiple product descriptions.. Example: "Chocolate, Milk".
