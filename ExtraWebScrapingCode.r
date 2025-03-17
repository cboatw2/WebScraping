#Extra web scraping code:
if(status_code(request) == 200) {

    json_data <- fromJSON(content(request, as = "text"))

    print(json_data$itemsPerPage)

    ocr <- json_data$items
    print(ocr[[15]]$ocr_eng)

}  else {
    print ("Request failed. Try again!")
}
