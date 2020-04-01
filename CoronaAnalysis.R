mygitpath <- 'https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/master/CoronaCases.csv'
library(tidyverse)
library(ggplot2)
library(maps)

#Loading data
corona <- read_csv(mygitpath)
corona

# Getting the counties map df
counties_map <- map_data("county")
counties_map <- filter(counties, region=='florida')

# Counting cases per county from corona df
county_cases <- corona %>%
  select(County) %>%
  group_by(County) %>%
  count()

# Data manipulation to match corona counties to map counties
county_cases$County<- tolower(county_cases$County)
corona$County <- tolower(corona$County)

# Counties in county_cases but not in counties_map
setdiff(unique(county_cases$County), unique(counties_map$subregion))

# "dade", "st. johns", and "st. lucie" are spelled different in the corona df
# change names
county_cases$County <- gsub("dade", "miami-dade", county_cases$County)
county_cases$County <- gsub("st. johns", "st johns", county_cases$County)
county_cases$County <- gsub("st. lucie", "st lucie", county_cases$County)

# Merge the two data sets
corona_map <- left_join(counties_map, county_cases, by= c(subregion = "County"))

# Plot
ggplot(corona_map, aes(x=long, y=lat, group=group, fill=n)) +
  geom_polygon(color="black", size=0.5) + theme_minimal() +
  scale_fill_viridis_c() + labs(title= "Corona cases in Florida by County", fill= "Number of cases") +
  coord_map(projection = "albers", lat0 = 25, lat1 = 31)

