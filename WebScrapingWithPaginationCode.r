
#Chronicling America API Script inclucing pagination loop to save all txt files into new directory, not just first 20 results

#Load libraries
library(jsonlite)
library(httr)
library(tidyverse)
library(conflicted)

install.packages("internetarchive", repos = c("https://ropensci.r-universe.dev", "https://cloud.r-project.org"))
library(internetarchive)

#Define query URL: search from the first year SC newspapers are available to the last year before the Civil War for the term "nullification"
base_url <- "https://chroniclingamerica.loc.gov/search/pages/results/?state=South+Carolina&dateFilterType=yearRange&date1=1836&date2=1860&sort=date&andtext=commerce&format=json&page="

# Create a new directory for the output files if it doesn't exist
output_dir_pagination <- "SC_Commerce_1836to1860_OCR_Files_Pagination"
if (!dir.exists(output_dir_pagination)) {
  dir.create(output_dir_pagination)
}

# Initialize variables
page <- 1
total_results <- 0
total_files_saved <- 0

repeat {
  # Construct the query URL for the current page
  locgov_url_search <- paste0(base_url, page)
  
  # Run the query using the API
  api_query_pagination <- GET(locgov_url_search)
  
  # Check if query was successful
  if (status_code(api_query_pagination) == 200) {
    
    # Tell R to read the results as JSON
    search_result_pagination <- fromJSON(content(api_query_pagination, as = "text", encoding = "UTF-8"))
    
    # Print the total number of search results (only on the first page)
    if (page == 1) {
      total_results_pagination <- search_result_pagination$totalItems
      print(paste("Total number of results:", total_results_pagination))
    }
    
    # Convert results to a dataframe
    if (length(search_result_pagination$items) > 0) {
      sc_commerce_df_pagination <- as.data.frame(search_result_pagination$items)
      
      # Write each record in the ocr_eng column to a separate text file in the new directory
      for (i in 1:nrow(sc_commerce_df_pagination)) {
        county <- sc_commerce_df_pagination$county[i]
        file_name_pagination <- paste0(output_dir_pagination, "/", county, "_", "record_", total_files_saved + i, ".txt")
        writeLines(sc_commerce_df_pagination$ocr_eng[i], file_name_pagination)
      }
      
      # Update the total number of files saved
      total_files_saved <- total_files_saved + nrow(sc_commerce_df_pagination)
      
    } else {
      break
    }
    
  } else {
    print("Request failed. Try again!")
    break
  }
  
  # Move to the next page
  page <- page + 1
  
  # Break the loop if all results have been processed
  if (total_files_saved >= total_results) {
    break
  }
}

# Confirm txt file creation by counting the number of text files in the directory
num_files <- length(list.files(output_dir_pagination, pattern = "\\.txt$"))
print(paste("Number of text files saved:", num_files))