mygitpath <- 'https://raw.githubusercontent.com/NaimChowdhury/Data_Viz/master/2020-06-15_HW8/PopulationEstimates.csv'
library(tidyverse)
# install.packages('maps')
library(maps)

# loading dataset through hyperlink
population <- read_csv(mygitpath)

# the package already has a set of counties
counties <- map_data("county")
# some of the place names were not UTF8 encoded, so I had to change it.
population$Area_Name = str_replace_all(population$Area_Name,"[^[:graph:]]", " ") 

# change all of the names of the places to lower case
population <- population %>% 
  mutate(county = tolower(Area_Name)) %>% 
  mutate(state = tolower(State))


