mygitpath <- 'https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/master/CoronaCases.csv'
library(tidyverse)
corona <- read_csv(mygitpath)


cases_per_county <- corona %>% 
  select(County) %>%
  group_by(County) %>%
  count()

install.packages("mapproj")
library(evaluate)
library(maps)
countydata <- map_data("county")
countydata1 <- countydata %>% filter(region == "florida")



cases_per_county$County <- tolower(cases_per_county$County)
cases_per_county$County <- gsub("dade", "miami-dade", cases_per_county$County)
cases_per_county$County <- gsub("st. johns", "st johns", cases_per_county$County)
cases_per_county$County <- gsub("st. lucie", "st lucie", cases_per_county$County)


# Which countries are in wb1 but not in worlddata:
setdiff(unique(cases_per_county$County), unique(countydata1$subregion))

# Merging the two datasets
coronamap <- left_join(countydata1, cases_per_county, by = c(subregion = "County"))



p <- ggplot(coronamap, aes(x = long, y = lat, group = group, fill = n)) + 
  geom_polygon(color = "black", size = 0.1) + theme_minimal() + 
  coord_map(projection = "albers", lat0 = 25, lat1 = 31) + scale_fill_viridis_c()

library(plotly)
ggplotly(p)
#test