

"This script runs a linear regression on /data/YouTube_processed.csv

Usage: analysis.R --data_path=<data_path>" -> doc

library(docopt)
library(broom)
library(tidyverse)
library(ggplot2)

opt <- docopt(doc)

main <- function(data_path) { 
	tryCatch(
    {
      message("Reading in data...")
      CAN <- read.csv(data_path)
    },
    error = {function(cnd) print(glue("error object is {cnd}"))},
    finally = {message("Data has been read successfully!")}
	)
	
	# read processed data
	CAN <- read.csv(data_path)

	# create linear model
	fit.lm <- lm(views ~ likes + dislikes, data = CAN)
	saveRDS(fit.lm, file = "rds/lm.rds")
	# summary of model
	summary <- tidy(fit.lm)
	saveRDS(summary, file = "rds/tidy_lm.rds") 
	# one row model summaries and goodness of fit measures
	summary2 <- glance(fit.lm)
	saveRDS(summary2, file = "rds/glance_lm.rds")
	
	# create poisson regression model (suitable for count data)
	fit.glm <- glm(views ~ likes + dislikes, family = "poisson", data = CAN)
	saveRDS(fit.glm, file = "rds/glm.rds")
  saveRDS(tidy(fit.glm), file = "rds/tidy_pois.rds") 
	saveRDS(glance(fit.glm), file = "rds/glance_pois.rds")
	
	

p1 <- CAN %>% as_tibble()	%>%
	select(views, likes, dislikes) %>%
	gather(status, count, likes:dislikes) %>%
	ggplot(., aes(count, views), group = status) + 
	geom_point(aes(color = status)) +
	geom_smooth(aes(color = status), method = "lm") +
	labs(x = "Status count", y = "Number of views") +
	theme_bw() + 
	scale_x_continuous(labels = scales::comma_format()) +
  scale_y_continuous(labels = scales::comma_format())
ggsave(plot=p1, filename='images/lm_status_views.png')

p1 <- CAN %>% as_tibble()	%>%
  select(views, likes, dislikes) %>%
  gather(status, count, likes:dislikes) %>%
  ggplot(., aes(count, views), group = status) + 
  geom_point(aes(color = status)) +
  geom_smooth(aes(color = status), method = "glm",method.args=(family="poisson")) +
  labs(x = "Status count", y = "Number of views") +
  theme_bw() + 
  scale_x_continuous(labels = scales::comma_format()) +
  scale_y_continuous(labels = scales::comma_format())
ggsave(plot=p1, filename='images/pois_status_views.png')


print("Data analysis done!")
}

main(opt$data_path)



