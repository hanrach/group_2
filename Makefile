
.PHONY all clean

# need to fix file names
all : docs/final-report-draft.html docs/finalreportdraft.pdf

# load data
Youtube_data.csv : scripts/load_data 
	Rscript scripts/load_data.R --data_url="https://raw.githubusercontent.com/STAT547-UBC-2019-20/group_2_youtube/master/data/CAvideos.csv""

# clean data
data/YouTube_processed.csv : scripts/process_data.R data/Youtube_data.csv
	Rscript scripts/process_data.R --data_path="data/Youtube_data.csv" --save_path="data/YouTube_processed.csv"

# eda
images/views_likes.png images/corr_plot.png images/num_vids_category.png images/top10_mean_views_likes.png : scripts/eda.R data/Youtube_processed.csv
	Rscript scripts/eda.R --image_path="data/Youtube_processed.csv"

# analysis
rds/lm.rds rds/lmSum.rds rds/lmSum2.rds images/status_commentcountreg.png : scripts/analysis.R data/Youtube_data.csv
	Rscript scripts/analysis.R --data_path="data/Youtube_data.csv"
		
# final report
# need to fix file names/this is general
docs/final-report-draft.html docs/finalreportdraft.pdf : images/views_likes.png images/corr_plot.png images/num_vids_category.png images/top10_mean_views_likes.png docs/final report draft.Rmd data/YouTube_processed.csv sripts/knit.R 
	Rscript scripts/knit.R --finalreport="docs/final report draft.Rmd"

# to delete output files and run analysis from scratch
clean :
	rm -f data/*
	rm -f images/*
	rm -f docs/*.md
	rm -f docs/*.html
		
