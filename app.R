"This script is the main file that creates a Dash app.

Usage: app.R
"

# Libraries

library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(ggplot2)
library(plotly)
library(purrr)
library(tidyverse)

app <- Dash$new()

# load data
CAN <- read.csv("data/youtube_processed.csv")

#make range sliders
views_slider <- dccRangeSlider(
	id = 'views-slider',
	min = 0,
	max = 5053338,
	step = 1,
	value = list(1, 5053338)
)

comments_slider <- dccRangeSlider(
	id = 'comments-slider',
	min = 0,
	max = 5053338,
	step = 1,
	value = list(1, 5053338)
)


# make graphs
bar_plot <- function(){
  category_vids <- CAN %>% group_by(category_id) %>% 
    tally() %>% 
    arrange(desc(n))
  
  p<-category_vids %>% ggplot(aes(y=n,
                                   x = fct_reorder(as.factor(category_id),
                                                   n,
                                                   max, .incr=TRUE)), customdata = category_id) +
    geom_bar(stat="identity") + 
    coord_flip() + 
    ylab("count") + 
    xlab("category") + 
    theme_bw() +
    theme(legend.position = "none") +
    ggtitle("Number of videos by Category")
  
  ggplotly(p, tooltip = c("text")) %>%
  	layout(clickmode = 'event+select')
}

views_scatter <- function(category = 24){
  data <- CAN %>% filter(category_id == category)
  p <- ggplot(data, aes(y=views)) +
    geom_point(aes(x=likes, color = "likes"),alpha =0.2,position="jitter") + 
    geom_point(aes(x = dislikes, color = "dislikes"), alpha =0.2,position="jitter") + 
    scale_x_continuous(labels = scales::comma_format()) +
    scale_y_continuous(labels = scales::comma_format()) +
    labs(x = "Count of likes/dislikes", y = "Views") +
    ggtitle("Trends between likes/dislikes and views")+
    theme_bw()
    
    ggplotly(p, tooltip = c("text"))
}

comments_scatter <- function(category = 24){
  data <- CAN %>% filter(category_id == category)
  p <- ggplot(data, aes(y=comment_count)) +
    geom_point(aes(x=likes, color = "likes"),alpha =0.2,position="jitter") + 
    geom_point(aes(x = dislikes, color = "dislikes"), alpha =0.2,position="jitter") + 
    scale_x_continuous(labels = scales::comma_format()) +
    scale_y_continuous(labels = scales::comma_format()) +
    labs(x = "Count of likes/dislikes", y = "Comments") +
    ggtitle("Trends between likes/dislikes and comments")+
    theme_bw()
  
  ggplotly(p, tooltip = c("text"))
}

barplot <- dccGraph(
  id = 'barplot',
  figure = bar_plot()
)

views_scatterplot <- dccGraph(
  id = 'views_scatterplot',
  figure = views_scatter()
)

comments_scatterplot <- dccGraph(
  id = 'comments_scatterplot',
  figure = comments_scatter()
)

# layout set up
div_header <- htmlDiv(
  list(
    htmlH1("Canadian YouTube Statistics"),
    htmlH3('Exploring the relationship between YouTube video categories, view number, comment count, and likes and dislike numbers
')
  ), style = list('columnCount'=1, 
                  'background-color'= 'lightgrey', 
                  'color'='white')
)

div_main <- htmlDiv(
  list(
    barplot,
    views_scatterplot,
    views_slider,
    comments_scatterplot,
    comments_slider
  )
)


app$layout(
	div_header,
	htmlDiv(
	  list(
	  	div_main
	  		)
	  	)
	  )
	
# add callbacks
#to update views scatter plot based on rangeslider
app$callback(
	output = list(id = 'views_scatterplot', property = 'figure'),
	params = list(input(id = 'views-slider', property = 'value')),
	function(xaxis_value, views_slider) {
		views_scatter(xaxis_value, views_slider)
	})

#to update comments scatter plot based on rangeslider
app$callback(
	output = list(id = 'comments_scatterplot', property = 'figure'),
	params = list(input(id = 'comments-slider', property = 'value')),
	function(xaxis_value, comments_slider) {
		views_scatter(xaxis_value, comments_slider)
	})

#to update views scatter plot by clicking on barplot
app$callback(output = list(id = 'views_scatterplot', property = 'figure'),
						 params = list(input(id='barplot', property='clickData'),
						 function(clickData) {
						 	category_id = clickData$points[[1]]$customdata
						 	views_scatter(category_id)
						 }))

app$run_server(host='0.0.0.0',debug=TRUE)
