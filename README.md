# Group 2
[Project repo](https://github.com/STAT547-UBC-2019-20/group_2.git)


Rachel Han & Marion Nyberg 

## Dataset
Our dataset is [Daily trending videos on YouTube](https://www.kaggle.com/datasnaek/youtube-new).

Milestone 1: [Dataset, EDA and research question](https://hanrach.github.io/group_2/milestone1_547.html)

Milestone 2: [Final report draft](https://hanrach.github.io/group_2/docs/final-report-draft.html)

Milestone 3: Please see the usage section below to create the final report.

## Usage

### Option 1

1. Clone this repo: `git clone https://github.com/STAT547-UBC-2019-20/group_2_youtube`

2. Install the following packages:
- tidyverse
- ggplot2
- here
- glue
- docopt

3. Run the following scripts in order as specified in the base `group_2_youtube` directory on the terminal:

`Rscript scripts/load_data.r --data_url="https://raw.githubusercontent.com/hanrach/youtube_dataset/master/CAvideos.csv"`

`Rscript scripts/process_data.r --data_path="data/youtube_data.csv" --save_path="data/youtube_processed.csv"`


`Rscript scripts/eda.R --image_path="images/"`

`Rscript scripts/analysis.R --data_path="data/youtube_processed.csv"`

`Rscript scripts/knit.R --final_report="docs/finalreport.Rmd"`

### Option 2

Run 
`make all`.

