"This script is the main file that creates a Dash app.

Usage: app.R
"

# Libraries

library(dash)
library(dashCoreComponents)
library(dashTable)
library(dashHtmlComponents)
library(ggplot2)
library(plotly)
library(purrr)
library(tidyverse)

app <- Dash$new()

# load data
CAN <- read.csv("data/youtube_processed.csv")

#make range sliders
max_status_count = max(max(CAN$likes),max(CAN$dislikes))
min_status_count = 0
#views_slider <- dccRangeSlider(
#	id = 'views-slider',
#	min = 0,
#	max = max_status_count,
#	step = 100,
	# marks = setNames(as.list(paste(seq(0, max_status_count, 1000000))),
	#                  paste(seq(0, max_status_count, 1000000))),
#	marks = list(
#	  "0" = "0",
#	  "1000000" = list(label = "1,000,000"), 
#	  "2000000" = list(label = "2,000,000"),
#	  "3000000" = list(label = "3,000,000"),
#	  "4000000" = list(label = "4,000,000"),
#	  "5000000" = list(label = "5,000,000")
#	),
#	value = list(min_status_count, max_status_count)
#)

comments_slider <- dccSlider(
	id = 'comments-slider',
	min = 0,
	max = max_status_count,
	step = 100,
	marks = list(
	  "0" = "0",
	  "1000000" = list(label = "1,000,000"), 
	  "2000000" = list(label = "2,000,000"),
	  "3000000" = list(label = "3,000,000"),
	  "4000000" = list(label = "4,000,000"),
	  "5000000" = list(label = "5,000,000")
	),
	value = max_status_count
)


histogram_plot <- function(category = 24) {
  p <- CAN %>% filter(category_id==category) %>%
    mutate(year_month = format(as.Date(trending_date), "%Y-%m") ) %>%
    arrange(trending_date) %>%
    ggplot(aes(x=as.Date(trending_date),y=views)) + geom_bar(stat = "identity") +
    labs(x = "Date", y = "Number of views") +
    ggtitle(paste0("View counts over time in entertainment for category", paste(category))) +
    scale_y_continuous(labels = scales::comma_format()) +
    scale_x_date(date_breaks = "months")
  
  ggplotly(p)
}
# make graphs
bar_plot <- function(){
  category_vids <- CAN %>% group_by(category_id) %>% 
    tally() %>% 
    arrange(desc(n))
  
  p<-category_vids %>% ggplot(aes(y=n,
                                  x = fct_reorder(as.factor(category_id),
                                                  n,
                                                  max, .incr=TRUE),
                                  customdata=category_id)) +
    geom_bar(stat="identity") + 
    coord_flip() + 
    ylab("count") + 
    xlab("category") + 
    theme_bw() +
    theme(legend.position = "none") +
    ggtitle("Number of videos by Category")
  
  ggplotly(p) %>% layout(clickmode = 'event+select')
}

#views_scatter <- function(category_select = 24, likes_interval = list(0, max_status_count)){
  
  #data <- CAN %>% filter(category_id == category_select) %>% 
    #filter(likes <= likes_interval[[2]][1] & dislikes <= likes_interval[[2]][1]) %>%
    #filter(likes >= likes_interval[[1]][1] & dislikes >= likes_interval[[1]][1])
  
  #p <- ggplot(data, aes(y=views)) +
    #geom_point(aes(x=likes, color = "likes"),alpha =0.2,position="jitter") + 
    #geom_point(aes(x = dislikes, color = "dislikes"), alpha =0.2,position="jitter") + 
    #scale_x_continuous(labels = scales::comma_format()) +
    #scale_y_continuous(labels = scales::comma_format()) +
    #labs(x = "Count of likes/dislikes", y = "Views") +
    #ggtitle(paste0("Trends between likes/dislikes and views for category ", toString(category_select))) +
    #theme_bw()
    
    #ggplotly(p)
#}

comments_scatter <- function(category_select = 24, likes_max = max_status_count, yaxis = "views") { ### original comments_scatter <- function(category_select = 24, likes_max = max_status_count) {
  y_label <- yaxisKey$label[yaxisKey$value == yaxis]
	data <- CAN %>% filter(category_id == category_select) %>% 
    filter(likes <= likes_max)
  p <- ggplot(data, aes(y=!!sym(yaxis))) + ### original   p <- ggplot(data, aes(y=comment_count)) 
    geom_point(aes(x=likes, color = "likes"),alpha =0.2,position="jitter") + 
    geom_point(aes(x = dislikes, color = "dislikes"), alpha =0.2,position="jitter") + 
    scale_x_continuous(labels = scales::comma_format()) +
    scale_y_continuous(labels = scales::comma_format()) +
  	xlab("Count of likes/dislikes") +
  	ylab(y_label)+
    #labs(x = "Count of likes/dislikes", y = "Comments") 
    ggtitle(paste0("Trends between likes/dislikes and ", y_label, " for category ", toString(category_select)))+ ###### original gtitle(paste0("Trends between likes/dislikes and comments for category ", toString(category_select)))
    theme_bw()
  
  ggplotly(p, tooltip = c("text"))
}


###### Storing the labels/values as a tibble means we can use this both 
# to create the dropdown and convert colnames -> labels when plotting
yaxisKey <- tibble(label = c("View number", "Comment count"),
									 value = c("views", "comment_count"))
#Create the dropdown
yaxisDropdown <- dccDropdown(
	id = "y-axis",
	options = map(
		1:nrow(yaxisKey), function(i){
			list(label=yaxisKey$label[i], value=yaxisKey$value[i])
		}),
	value = "views"
)
#######

barplot <- dccGraph(
  id = 'barplot',
  figure = bar_plot()
)

histogram <- dccGraph(
  id = 'histogram',
  figure = histogram_plot()
)

#views_scatterplot <- dccGraph(
  #id = 'views_scatterplot',
  #figure = views_scatter()
#)

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
    histogram,
    #views_scatterplot,
    #views_slider,
    comments_scatterplot,
    comments_slider,
    yaxisDropdown
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
# app$callback(
# 	output = list(id = 'views_scatterplot', property = 'figure'),
# 	params = list(input(id = 'views-slider', property = 'value')),
# 	function(likes_max) {
# 		views_scatter(24, likes_max)
# 	})

# to update comments scatter plot based on rangeslider
# app$callback(
# 	output = list(id = 'comments_scatterplot', property = 'figure'),
# 	params = list(input(id = 'comments-slider', property = 'value')),
# 	function(likes_max) {
# 		comments_scatter(24, likes_max)
# 	})

#to update views scatter plot by clicking on barplot and slider
#app$callback(output = list(id = 'views_scatterplot', property = 'figure'),
#             params = list(input(id = 'barplot', property='clickData'),
#                           #input(id='views-slider', property='value')
#             ),
#             function(clickData, interval) {
#               category = clickData$points[[1]]$customdata
#               if (is.null(category)) {
#                 category <- 24
#               }
#               #views_scatter(category, interval)
#             })

app$callback(output = list(id = 'histogram', property = 'figure'),
             params = list(input(id = 'barplot', property='clickData')
             ),
             function(clickData) {
               category = clickData$points[[1]]$customdata
               if (is.null(category)) {
                 category <- 24
               }
               histogram_plot(category)
             })

#to update comments scatter plot by clicking on barplot and slider
app$callback(output = list(id = 'comments_scatterplot', property = 'figure'),
						 params = list(input(id = 'barplot', property='clickData'),
						               input(id='comments-slider', property='value'),
						 							input(id='y-axis', property = 'value')
						               ),
						 function(clickData, likes_max, yaxis) {
						 	category = clickData$points[[1]]$customdata
						 	if (is.null(category)) {
						 	  category <- 24
						 	}
						 	comments_scatter(category, likes_max, yaxis)
						 })

app$run_server(host='0.0.0.0',debug=TRUE)
