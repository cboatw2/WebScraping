

#Chronicling America API webscraping script

#Load libraries
library(jsonlite)
library(httr)
library(tidyverse)
library(conflicted)

install.packages("internetarchive", repos = c("https://ropensci.r-universe.dev", "https://cloud.r-project.org"))
library(internetarchive)

# Define your query URL

locgov_url_search <- paste0("https://chroniclingamerica.loc.gov/search/pages/results/?state=SouthCarolina&dateFilterType=yearRange&date1=1796&date2=1920&sort=date&andtext=nullification&format=json&page=2")

# Run the query using the API
api_query <- GET(locgov_url_search)

# Check if query was successful
if (status_code(api_query) == 200) {

  # Tell R to read the results as JSON
  search_result <- fromJSON(content(api_query, as = "text", encoding = "UTF-8"))
  print(search_result)
} else {
  print("Request failed. Try again!")
}

# Look at first record of results
first_result <- search_result$results[[1]]
print(first_result)