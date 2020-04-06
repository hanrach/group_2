#install.packages('docopt')

"This script processes the data from /data/YouTube.csv.

Usage: process_data.R --data_path=<data_path> --save_path=<save_path>
" -> doc 
library(docopt)
library(tidyverse)

opt <- docopt(doc) 


main <- function(data_path,save_path) {
  
  tryCatch(
    {
      message("Reading in data...")
      CAN <- read.csv(data_path)
    },
    error = {function(cnd) print(glue("error object is {cnd}"))},
    finally = {message("Data has been read successfully!")}
    
  )
  
  rem_cols = c("description", "tags", "video_error_or_removed", "comments_disabled", "ratings_disabled", "thumbnail_link")
  # Make the data a tibble and omit NA rows and remove columns
  CAN_tibble <- CAN %>% 
    as_tibble %>% 
    na.omit %>% 
    select(-one_of(rem_cols))

  # Data type setting:
  # title, description, tags -> strings
  CAN_clean <- CAN_tibble %>% mutate(title = as.character(title),
                        channel_title = as.character(channel_title),
                        # change dates
                        trending_date = as.character(trending_date) %>% 
                          as.Date("%y.%d.%m"),
                        publish_time = as.character(publish_time) %>%
                          str_replace("T", " ") %>%
                          str_remove("Z") %>% 
                          as.POSIXct(format = "%Y/%m/%d %H:%M:%S")
                        )
  
  print("Data processing done!")
  tryCatch(
    {
      message("Saving processed data..")
      write.csv(CAN_clean,save_path)
    },
    error = {function(cnd) print(glue("error object is {cnd}"))},
    finally = {message("Processed data has been saved successfully!")}
    
  )
  
  #TODO: Save the cleaned data as YouTube_processed.csv
}

main(opt$data_path,opt$save_path)