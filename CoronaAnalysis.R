library(tidyverse)
library(mapproj)
library(maps)

mygitpath <- 'https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/master/CoronaCases.csv'
corona <- read_csv(mygitpath)
corona

counties<- corona %>% group_by(County) %>% summarise(Count = n())
for (i in 1:nrow(counties)){
  counties[i,1]<- tolower(counties[i,1])
}

florida_data <- map_data("county") %>% filter(region == "florida")
florida_counties<- florida_data %>% group_by(subregion) %>% summarise(Count = n())

counties<- counties %>% filter(County != "unknown")
counties[counties$County == "dade",][1]<- "miami-dade"
counties[counties$County == "st. johns",][1]<- "st johns"
counties[counties$County == "st. lucie",][1]<- "st lucie"

map_data<- florida_data %>% left_join(counties, by = c("subregion" = "County"))
map_data$Count[is.na(map_data$Count)]<- 0

ggplot(map_data, aes(x = long, y = lat, group = group, fill = Count)) + 
  geom_polygon(color = "black", size = 0.5) + scale_fill_gradient(low = "lightsalmon", high = "midnightblue") + 
  labs(title = "Florida COVID-19 Cases by County", subtitle = "Source: www.floridadisaster.org", fill = "Cases", x = "Longitude", y = "Latitude") + 
  theme_minimal()
