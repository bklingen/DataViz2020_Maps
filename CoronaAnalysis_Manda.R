mygitpath <- 'https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/master/CoronaCases.csv'
library(tidyverse)
corona <- read_csv(mygitpath)
corona
library(tidyverse)
library(maps)
library(mapproj)
corona <- read_csv(mygitpath)


#view counties
get.county <- map_data("county") %>% filter(region =="florida") 
corona <- corona %>% filter(County != "Unknown")
unique(get.county$subregion) #unknown regions



# Getting county info
corona$County <- tolower(corona$County)
setdiff(corona$County, unique(get.county$subregion))

#changing county names
get.county.1 <- get.county %>% mutate(subregion = fct_recode(subregion, `st. lucie` = "st lucie",`st. johns` = "st johns", `dade` = "miami-dade"))
setdiff(corona$County, unique(get.county.1$subregion))
corona <- corona %>% group_by(County) %>% mutate(count = n())

#mapping results
coronaMap <- left_join(get.county.1, corona, by = c("subregion" = "County"))
ggplot(coronaMap, aes(x = long, y = lat, group = group)) + 
  geom_polygon(aes(fill = count))
