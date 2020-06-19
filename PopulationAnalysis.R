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
  mutate(state = tolower(State)) %>% 
  select(state, county, CENSUS_2010_POP, 
         POP_ESTIMATE_2019,
         N_POP_CHG_2019,
         Births_2019,
         Deaths_2019,
         NATURAL_INC_2019,
         INTERNATIONAL_MIG_2019,
         DOMESTIC_MIG_2019,
         NET_MIG_2019,
         RESIDUAL_2019,
         GQ_ESTIMATES_2019,
         R_birth_2019) %>%
  drop_na() %>% 
  mutate(logarithmic = log(POP_ESTIMATE_2019))

#removing the order column, which messes with the join
counties <- counties %>% select(-order)

population$county <- gsub("([A-Za-z]+).*", "\\1", population$county)

# joining datasets
join <- left_join(population, counties, by = c("county"="subregion"))

join <- join %>% group_by(county)

plot <- ggplot(join, aes(x = long, y = lat, group = group))+
  geom_polygon(aes(fill = logarithmic), color = "black", size = 0.1)+
  theme_void()+
  scale_fill_gradient()

plot
