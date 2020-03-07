data_url <- read.csv(url('https://raw.githubusercontent.com/STAT547-UBC-2019-20/group_2_youtube/master/data/CAvideos.csv'))

write.csv(data_url, here::here("data","Youtube_data.csv"))

print('Data has been downloaded successfully')