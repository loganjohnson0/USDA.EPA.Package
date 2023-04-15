# foodRecall Package

To use this package, it is necessary that you register for an API key through the [openFDA website](https://open.fda.gov/apis/authentication/). This is a free API key that only requires your email address. You should receive it immediately upon request. Upon any issues with the API key itself, please contact the openFDA office. Be sure to not share your API key with anyone!

```{r}
library(devtools)
devtools::install.github("loganjohnson/USDA.EPA.Package") # Will change the repository name once we finalize package name (foodRecall)
library(foodRecall)
```

To use the foodRecall package, you simply need to enter your API key into the function. You will also need to define the number of requests that you would like to request. The limit is 1000 so if you enter a number larger than 1000, an error will occur.

```{r}
df <- foodRecall::get_fda(api_key = "YOUR API KEY", limit = "NUMBER OF RECALL EVENTS")
```

We also are working on visualizing these data on a location basis. We are working on adding in additional capabilities, such as the scale of the product recall and other interactive capabilities. It is best to not change the column headers from those in the generated 'get_fda' function.

```{r}
foodRecall::map_recall(data = df)
```

Check back for additional updates that we plan to add in soon!

