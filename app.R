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

heading = htmlH1('Canadian YouTube Statistics')
heading_subtitle = htmlH3('Exploring the relationship between YouTube video categories, view number, comment count, and likes and dislike numbers
')





app$layout(
	htmlDiv(
		list(
			heading,
			heading_subtitle
	#ADD MORE COMPONENTS HERE	
		)
	)
)

app$run_server(debug=TRUE)