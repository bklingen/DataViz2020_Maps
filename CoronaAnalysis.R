mygitpath <- 'https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/master/CoronaCases.csv'
library(tidyverse)
corona <- read_csv(mygitpath)
corona

library(maps)

counties <- map_data("county")
counties <- filter(counties, region=="florida")

coronacount <- corona %>% count(County)
countycount <- counties %>% count(subregion)

coronacount$County <- tolower(coronacount$County)

#compare <- countycount %>% full_join(coronacount, by=c("subregion"="County"))
coronacount[11,1] <- "miami-dade" 
coronacount[39,1] <- "st johns"
coronacount[40,1] <- "st lucie"

corona2 <- counties %>% left_join(coronacount, by=c("subregion"="County"))

ggplot(corona2, aes(x = long, y = lat, group = group, fill = n)) + 
  geom_polygon(color = "black", size = 0.5) + theme_minimal() +
  scale_fill_viridis_c() +
  labs(title="Coronavirus Cases in Florida, by County", fill="Number of Cases")
