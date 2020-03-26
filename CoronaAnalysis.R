mygitpath <- 'https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/master/CoronaCases.csv'
library(tidyverse)
library(maps)

#loading in Corona data
corona <- read_csv(mygitpath)
corona

#loading in 
counties <- map_data("county")
counties <- filter(counties, region=="florida")

#These commands just verify the data so that the counties match up
#coronacount <- corona %>% count(County)
#countycount <- counties %>% count(subregion)
#compare <- countycount %>% full_join(coronacount, by=c("subregion"="County"))

#Additional data wrangling to get counties matched up properly
coronacount$County <- tolower(coronacount$County)
coronacount[11,1] <- "miami-dade" 
coronacount[39,1] <- "st johns"
coronacount[40,1] <- "st lucie"

#Joining the data into one dataset for plotting
corona2 <- counties %>% left_join(coronacount, by=c("subregion"="County"))

#Plotting the data
ggplot(corona2, aes(x = long, y = lat, group = group, fill = n)) + 
  geom_polygon(color = "black", size = 0.5) + theme_minimal() +
  scale_fill_viridis_c() +
  labs(title="Coronavirus Cases in Florida, by County", fill="Number of Cases")
