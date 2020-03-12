

"This script runs a linear regression on /data/YouTube.csv

Usage: analysis.R --data_path=<data_path> --save_path=<save_path>" -> doc

library(docopt)
library(broom)
library(tidyverse)
library(ggplot2)

opt <- docopt(doc)

main <- function(data_path,save_path) { 
	
	# read processed data
	CAN <- read.csv(data_path)
	
	# create linear model
	linear_regression <- lm(comment_count ~ likes + dislikes, data = CAN)
	
	# summary of model
	summary <- glance(linear_regression)
	
	#save model summary
	saveRDS(summary, file = "linearreg.rds", path=save_path) #specify output

}


main(opt$linear_regression)



