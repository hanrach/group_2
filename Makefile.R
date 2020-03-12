
.PHONY all clean

# need to fix file names
all : docs/final-report-draft.html docs/finalreportdraft.pdf

# load data
# need to fix this one
Youtube_data.csv: scripts/load_data 
	Rscript scripts/load_data.R --data_url=

# clean data
data/YouTube_processed.csv : scripts/process_data.R data/Youtube_data.csv
	Rscript scripts/process_data.R --data_path="data/Youtube_data.csv" --save_path="data/YouTube_processed.csv"

# eda
images/views_likes.png images/corr_plot.png images/num_vids_category.png images/top10_mean_views_likes.png : scripts/eda.R data/Youtube_processed.csv
	Rscript scripts/eda.R --image_path="data/Youtube_processed.csv"

# analysis
# need to add this
		
# final report
# need to fix file names
docs/final-report-draft.html docs/finalreportdraft.pdf : images/views_likes.png images/corr_plot.png images/num_vids_category.png images/top10_mean_views_likes.png docs/final report draft.Rmd data/YouTube_processed.csv sripts/knit.R 
	Rscript src/knit.R --finalreport="docs/final report draft.Rmd"

	
# need to create the knit script
	
clean :
		rm -f data/*
		rm -f images/*
		rm -f docs/*.md
		rm -f docs/*.html
		
