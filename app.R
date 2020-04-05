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
library(flexdashboard)

app <- Dash$new()

#set plot dimensions
options(repr.plot.width = 10, repr.plot.height = 10)

# load data
CAN <- read.csv("data/youtube_processed.csv")


#make range sliders
max_status_count = max(max(CAN$likes),max(CAN$dislikes))
min_status_count = 0

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
    labs(x = "Date", y = "View number") +
    ggtitle(paste0("View Counts Over Time in Entertainment for Category ", paste(category))) +
    scale_y_continuous(labels = scales::comma_format()) +
    scale_x_date(date_breaks = "months")+
  	theme_bw()
  
  ggplotly(p, tooltip = c("text"))
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
    ylab("Count") + 
    xlab("Category") + 
    theme_bw() +
    theme(legend.position = "none") +
    ggtitle("Number of Videos by Category")
  
  ggplotly(p, tooltip = c("text")) %>% layout(clickmode = 'event+select')
}


comments_scatter <- function(category_select = 24, likes_max = max_status_count, yaxis = "views") { 
  y_label <- yaxisKey$label[yaxisKey$value == yaxis]
	data <- CAN %>% filter(category_id == category_select) %>% 
    filter(likes <= likes_max)
  p <- ggplot(data, aes(y=!!sym(yaxis))) + ### original   p <- ggplot(data, aes(y=comment_count)) 
    geom_point(aes(x=likes, color = "likes"),alpha =0.2,position="jitter") + 
    geom_point(aes(x = dislikes, color = "dislikes"), alpha =0.2,position="jitter") + 
  	scale_x_log10(labels = scales::comma_format())+
    #scale_x_continuous(labels = scales::comma_format()) +
    scale_y_continuous(labels = scales::comma_format()) +
  	xlab("Count of likes/dislikes") +
  	ylab(y_label)+
    ggtitle(paste0("Trends Between Likes/Dislikes and ", y_label, " for Category ", toString(category_select)))+ 
    theme_bw()

  ggplotly(p)
}


# Storing the labels/values as a tibble means we can use this both to create the dropdown and convert colnames -> labels when plotting
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

barplot <- dccGraph(
  id = 'barplot',
  figure = bar_plot()
)

histogram <- dccGraph(
  id = 'histogram',
  figure = histogram_plot()
)

comments_scatterplot <- dccGraph(
  id = 'comments_scatterplot',
  figure = comments_scatter()
)

# layout set up
#this is the title bar
div_header <- htmlDiv(
  list(
    htmlH1("Canadian YouTube Statistics"),
    htmlH3('Exploring the relationship between YouTube video categories, view number, comment count, and likes and dislike numbers
')
  ), style = list('columnCount'=1, 
                  'background-color'= 'lightgrey', 
                  'color'='white',
  								'text-align'='center')
)



#this is the sidebar
div_side <- htmlDiv(
	list(
		htmlP('Use this dashboard to explore how different YouTube video categories are trending over time in Canada and how this is reflected in their view numbers and comment counts. Source: https://www.kaggle.com/datasnaek/youtube-new'),
		htmlLabel('Select scatter plot to display view number or comment count:'),
		htmlBr(),
		yaxisDropdown,
		htmlBr(),
		htmlLabel('Change range of like/dislike values on the scatter plot:'),
		htmlBr(),
		comments_slider,
		htmlBr(),
		htmlLabel('Click on the category on the bar plot see the corresponding histogram and scatter plot.'),
		htmlBr()
	),
	style = list('background-color'='lightgrey', 
							 'columnCount'=1, 
							 'white-space'='pre-line',
							 'width' = '55%')
)


#barplot div
div_barplot <- htmlDiv(
	list(
		barplot
	),
	style = list('display' = 'flex',
							 'height' = '40%')
)

#this is the main element
div_main <- htmlDiv(
  list(
    histogram,
    htmlBr(),
    comments_scatterplot
  ),
  style = list('display' = 'flex',
  						 'flex-direction'= 'column',
  						 'width' = '50%')
)


#final layout
app$layout(
	div_header,
	htmlDiv(
		list(
			div_side
		),
		style = list('display' = 'flex',
			'justify-content' = 'left')
	),
	htmlDiv(
		list(
	  	div_barplot,
	  	div_main
	  		),
		style = list('display' = 'flex',
								 'flex-direction' = 'row',
								 'align-items' = 'baseline')
	  )
)

	
# add callbacks
#to update views historgram plot from clicking on barplot
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


app$run_server(debug=TRUE)



# command to add dash app in Rstudio viewer:
# rstudioapi::viewer("http://127.0.0.1:8050")
