# author: Rachel Han and Marion Nyberg
# date: Mar 13, 2020

.PHONY: all clean


# load data
Youtube_data.csv : scripts/load_data.R
	Rscript scripts/load_data.R --data_url="https://raw.githubusercontent.com/STAT547-UBC-2019-20/group_2_youtube/master/data/CAvideos.csv"

# clean data
data/YouTube_processed.csv : scripts/process_data.R data/Youtube_data.csv
	Rscript scripts/process_data.R --data_path="data/Youtube_data.csv" --save_path="data/YouTube_processed.csv"

# eda
images/views_likes.png images/corr_plot.png images/num_vids_category.png images/top10_mean_views_likes.png : scripts/eda.R 
	Rscript scripts/eda.R --image_path="images/"

# analysis
rds/lm.rds rds/glm.rds images/lm_status_views.png images/pois_status_views.png : scripts/analysis.R data/Youtube_processed.csv
	Rscript scripts/analysis.R --data_path="data/Youtube_processed.csv"
		
# final report
docs/finalreport.html docs/finalreport.pdf : images/ rds/ docs/finalreport.Rmd data/YouTube_processed.csv scripts/knit.R 
	Rscript scripts/knit.R --final_report="docs/finalreport.Rmd"


all : docs/finalreport.html docs/finalreport.pdf
# to delete output files and run analysis from scratch
clean :
	rm -f data/*
	rm -f images/*
	rm -f docs/*.md
	rm -f docs/*.html
		
