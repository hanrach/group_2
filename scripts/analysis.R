

"This script runs a linear regression on /data/YouTube.csv

Usage: analysis.R --data_path=<data_path>" -> doc

library(docopt)
library(broom)
library(tidyverse)
library(ggplot2)

opt <- docopt(doc)

main <- function(data_path) { 
	
	# read processed data
	CAN <- read.csv(data_path)
	
	# create linear model
	linear_regression <- lm(comment_count ~ likes + dislikes, data = CAN)
	saveRDS(linear_regression, file = "rds/lm.rds")

	# summary of model
	summary <- tidy(linear_regression)
	saveRDS(summary, file = "rds/lmSum.rds") 
	
	# one row model summaries and goodness of fit measures
	summary2 <- glance(linear_regression)
	saveRDS(summary2, file = "rds/lmSum2.rds") 

p1 <- CAN %>% as_tibble()	%>%
	select(comment_count, likes, dislikes) %>%
	gather(status, count, likes:dislikes) %>%
	ggplot(., aes(comment_count, count), group = status) + 
	geom_point(aes(color = status)) +
	geom_smooth(aes(color = status), method = "lm") +
	labs(x = "Comment count", y = "Status count") +
	theme_bw() + 
	scale_x_continuous(labels = scales::comma_format()) +
  scale_y_continuous(labels = scales::comma_format())
ggsave(plot=p1, filename='images/status_commentcountreg.png')
	
}

main(opt$data_path)



