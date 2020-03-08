# Group 2
[Project repo](https://github.com/STAT547-UBC-2019-20/group_2.git)


Rachel Han & Marion Nyberg 

## Dataset
Our dataset is [Daily trending videos on YouTube](https://www.kaggle.com/datasnaek/youtube-new).

Milestone 1: [Dataset, EDA and research question](https://hanrach.github.io/group_2/milestone1_547.html)

Milestone 2: [Final report draft](https://hanrach.github.io/group_2/docs/final-report-draft.html)

## Usage

1. Clone this repo: `git clone https://github.com/STAT547-UBC-2019-20/group_2_youtube`

2. Install the following packages:
- tidyverse
- ggplot
- docopt

3. Run the following scripts in order as specified in the base `group_2_youtube` directory on the terminal:

`Rscript scripts/load_data.r --data_url="https://raw.githubusercontent.com/STAT547-UBC-2019-20/group_2_youtube/master/data/CAvideos.csv"`

`Rscript scripts/process_data.r --data_path="data/YouTube_data.csv" --save_path="data/YouTube_processed.csv"`

`Rscript scripts/eda.r --image_path="images/"`

