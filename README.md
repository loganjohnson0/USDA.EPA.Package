# foodRecall Package

To use this package, it is necessary that you register for an API key through the [openFDA website](https://open.fda.gov/apis/authentication/). This is a free API key that only requires your email address. You should receive it immediately upon request. Upon any issues with the API key itself, please contact the openFDA office. Be sure to not share your API key with anyone!

```{r}
library(devtools)

# Will change the repository name once we finalize package name (foodRecall)
devtools::install.github("loganjohnson0/USDA.EPA.Package")

library(foodRecall)
```

To use the `foodRecall` package, you simply need to enter your API key into the `get_fda` function. You will also need to define the number of requests that you would like to request. The limit is 1000 so if you enter a number larger than 1000, an error will occur. (Working on adding in that limitation in the package itself).

```{r}
df <- foodRecall::get_fda(api_key = "YOUR API KEY", limit = "NUMBER OF RECALL EVENTS")
```

We also are working on visualizing these data on a location basis. We are working on adding in additional capabilities, such as the scale of the product recall and other interactive capabilities. It is best to not change the column headers from those in the generated `get_fda` function.

```{r}
foodRecall::map_recall(data = df)
```

These are the only two functions that we recommend using at this time! The `get_usda_fsis` and `get_cdc` functions currently work (for Logan at least); however, these are dependent on Selenium. It is NOT recommended that you use these functions currently. We are likely going to connect to the CDC API in the `get_cdc` function. 

We are exploring other avenues for incorporating USDA-FSIS recall data (as we haven't found an API for those data yet). We have found a link with [XML data](https://www2c.cdc.gov/podcasts/createrss.asp?c=146) through the CDC that has current data as well as history through approximately 2021. These data do not contain as specific of data as the current version (April 15, 2023) of `get_usda_fsis` can or likely will achieve.

Check back for additional updates that we plan to add in soon!

