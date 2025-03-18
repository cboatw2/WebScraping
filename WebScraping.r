
#Load Libraries:
#library(jsonlite)
#library(httr)
#library(tidyverse)

#res <- 
#Run GET()
#Status: 200 #successful request (400 is failed)

#content(data, as = “test”)
#fromJSON(content)

#ocr<- json_data$items
#print (ocr$ocr_eng[15])


#install.packages('internetarchive', repos = c('https://ropensci.r-universe.dev', 'https://cloud.r-project.org'))
#library(internetarchive)

#install.packages("tidyverse")

#install.packages("conflicted")

#Chronicling America API webscraping script

#Load libraries
library(jsonlite)
library(httr)
library(tidyverse)
library(conflicted)

#Resolve conflicts created by using tidyverse with other packages
conflicted::conflict_prefer("filter", "dplyr")
conflicted::conflict_prefer("lag", "dplyr")
conflicted::conflict_prefer("flatten", "purrr")
conflicted::conflict_prefer("simplify", "purrr")

#First attempt at URL:
#request <- GET(" https://chroniclingamerica.loc.gov/search/titles/results/?terms=nullification")

#Changed URL using results from Google search: how to search for a specific term in South Carolina newspapers using Chronicling America's API:

request <- GET("http://www.loc.gov/collections/chronicling-america/?location_state=southcarolina&qs=Nullification&end_data=1945-12-31&fo=json")

#Checks to see if search was successful. Prints raw content of search in order to debug from lexical error I was receiving previously.
#if (status_code(request) == 200) {
  # Print raw content for debugging
#  raw_content <- content(request, as = "text")
#  print(raw_content)

  # Parse the content as JSON
#  json_data <- fromJSON(raw_content)
  
  # Print out the number of items per page
#  print(json_data$itemsPerPage)
  
  # Extract specific data
#  ocr <- json_data$items
#  print(ocr[[15]]$ocr_eng) # Adjust the index and field as needed
#} else {
#  print("Request failed. Try again!")
#}


install.packages ("internetarchive", repos = c("https://ropensci.r-universe.dev", "https://cloud.r-project.org"))
library(internetarchive)


# Define your query URL
#locgov_url_search <- ("http://www.loc.gov/collections/chronicling-america/?location_state=southcarolina&qs=Nullification&end_data=1945-12-31&fo=json")
locgov_url_search <- ("https://chroniclingamerica.loc.gov/search/pages/results/?state=SouthCarolina&dateFilterType=yearRange&date1=1796&date2=1912&sort=date&andtext=nullification&format=json")

# Run the query using the API
api_query <- GET(locgov_url_search)

#Check if query was successful
if (status_code(api_query) == 200) {

# Tell R to read the results as JSON
search_result <- fromJSON(content(api_query, as = "text", encoding = "UTF-8"))
 print(search_result)
} else {
  print("Request failed. Try again!")
}

#Look at first record of results
first_result <- search_result["results"][0]
print(first_result)

