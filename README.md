# Group 2
[Project repo](https://github.com/STAT547-UBC-2019-20/group_2.git)


Rachel Han & Marion Nyberg 

## Dataset
Our dataset is [Daily trending videos on YouTube](https://www.kaggle.com/datasnaek/youtube-new).

Milestone 1: [Dataset, EDA and research question](https://hanrach.github.io/group_2/blob/master/docs/milestone1_547.html)

Milestone 2: See usage below.

Milestone 3: See the usage below to create the final report. Note that the repository comes with clean directories (without data and images).

## Usage

### Option 1

1. Clone this repo: `git clone https://github.com/STAT547-UBC-2019-20/group_2_youtube`

2. Install the following packages:
- tidyverse
- ggplot2
- here
- glue
- broom
- corrplot
- docopt

3. Run the following scripts in order as specified in the base `group_2_youtube` directory on the terminal:

```
# Download data from the web
Rscript scripts/load_data.R --data_url="https://raw.githubusercontent.com/hanrach/youtube_dataset/master/CAvideos.csv"

# Clean data
Rscript scripts/process_data.R --data_path="data/youtube_data.csv" --save_path="data/youtube_processed.csv"

# Create images from exploratory data anlysis
Rscript scripts/eda.R --image_path="images/"

# Peform regression on data and save the model
Rscript scripts/analysis.R --data_path="data/youtube_processed.csv"

# Create a final report in html and pdf format.
Rscript scripts/knit.R --final_report="docs/finalreport.Rmd"
```

### Option 2

- Make sure you have GNU Make on your machine.
- Make sure you are in the base directory `group_2_youtube`.
- You can choose to run the following `make` commands in order:

```
# load data
make data/youtube_data.csv 

# clean data
make data/youtube_processed.csv 

# eda
make images/views_likes.png images/corr_plot.png images/num_vids_category.png images/top10_mean_views_likes.png 

# analysis
make rds/lm.rds rds/glm.rds images/lm_status_views.png images/pois_status_views.png 
		
# knit final report
make docs/finalreport.html docs/finalreport.pdf 
```
- Or you can simply run `make all` to execute the above commands all at once.

- You can run `make clean` to delete all the files in the subdirectories except the scipts.

