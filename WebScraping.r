

#Chronicling America API webscraping script

#Load libraries
library(jsonlite)
library(httr)
library(tidyverse)
library(conflicted)

install.packages("internetarchive", repos = c("https://ropensci.r-universe.dev", "https://cloud.r-project.org"))
library(internetarchive)

# Define your query URL: search from the first year SC newspapers are available to the last year before the Civil War for the term "nullification"

locgov_url_search <- ("https://chroniclingamerica.loc.gov/search/pages/results/?state=South+Carolina&dateFilterType=yearRange&date1=1836&date2=1860&sort=date&andtext=commerce&format=json")

# Run the query using the API
api_query <- GET(locgov_url_search)

# Check if query was successful
if (status_code(api_query) == 200) {

  # Tell R to read the results as JSON
  search_result <- fromJSON(content(api_query, as = "text", encoding = "UTF-8"))
  print(search_result)

  #Print the total number of search results
  total_results <- search_result$totalItems
  print(paste("Total number of results:", total_results))

  # Look at first record of results
  first_result <- search_result$results[[1]]
  print(first_result)

  #Convert results to a dataframe
  if (total_results > 0) {
    sc_commerce_df <- as.data.frame (search_result$items)
    print(sc_commerce_df)

    #Display sc_commerce_df in another window as a table
    View(sc_commerce_df)

     #Create a seperate text file for each record in the ocr_eng column
    for (i in 1:nrow(sc_commerce_df)) {
      county <- sc_commerce_df$county[i]
      file_name <- paste0(county, "_", "record_", i, ".txt")
      writeLines(sc_commerce_df$ocr_eng[i], file_name)
    }

  } else {
    print ("No results. Unable to print dataframe.")
  }

} else {
  print("Request failed. Try again!")
}
