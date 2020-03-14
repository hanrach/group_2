

"This script processes the data from /data/YouTube.csv.

Usage: eda.R --image_path=<image_path> 
" -> doc 
library(docopt)
library(tidyverse)
library(ggplot2)
library(here)
library(glue)
library(corrplot)

opt <- docopt(doc)

main <- function(image_path) {
  
  # read processed data
  CAN <- read.csv("data/youtube_processed.csv")
  
  # plot trends between views and likes
  p1 <- ggplot(CAN, aes(views, likes)) +
    geom_point(alpha =0.2,position="jitter", color = "blue") + 
    scale_x_continuous(labels = scales::comma_format()) +
    scale_y_continuous(labels = scales::comma_format()) +
    labs(x = "Views", y = "Likes") +
    ggtitle("Trends between Youtube video views and likes")+
    theme_bw()
  ggsave(plot=p1, filename='views_likes.png', path=image_path)
  
  # Explore video categories
  category_vids <- CAN %>% group_by(category_id) %>% 
    tally() %>% 
    arrange(desc(n))
  
  # Plot a histogram 
  p2<-category_vids %>% ggplot(aes(y=n,
                               x = fct_reorder(as.factor(category_vids$category_id),
                                               category_vids$n,
                                               max, .incr=TRUE))) +
    geom_bar(stat="identity") + 
    coord_flip() + 
    ylab("count") + 
    xlab("category") + 
    theme_bw() +
    theme(legend.position = "none") +
    ggtitle("Number of videos by Category")
  ggsave(plot=p2, filename='num_vids_category.png',path=image_path)
  
  png(file=paste0(image_path,"corr_plot.png"),width=500,height=500)
  p3<- CAN %>% select(views, likes, dislikes,comment_count) %>% 
    cor() %>% 
    round(2) %>% 
    corrplot(
      type="lower", 
      method="color",
      title = "Correlation between numerical features",
      tl.srt=45,
      addCoef.col = "white",
      diag = FALSE)
  dev.off()
  
  category.agg <- aggregate(CAN[,8:11], 
                            by = list(CAN$category_id), 
                            FUN = mean) %>%
    rename(category_id = Group.1)
  
  category.agg$category_id <- as.factor(category.agg$category_id) 
  
  p4<- category.agg %>%
      arrange(desc(views)) %>%
      top_n(10) %>%
      ggplot(aes(likes, views)) +
      geom_point(aes(color = category_id)) +
      labs(x = "Likes", y= "Views") + 
      scale_x_continuous(labels = scales::comma_format()) +
      scale_y_continuous(labels = scales::comma_format()) +
      ggtitle( "Mean video views and likes for the top 10 most viewed video categories") + 
      theme_bw()
  ggsave(plot=p4, filename='top10_mean_views_likes.png',path=image_path)
  
  print("EDA successfully completed and saved images to /images!")
  
}

main(opt$image_path)