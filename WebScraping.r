

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

} else {
  print("Request failed. Try again!")
}

# Look at first record of results
#first_result <- search_result$results[[1]]
#print(first_result)