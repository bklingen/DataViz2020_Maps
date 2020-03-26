library(maps)
library(tidyverse)


mygitpath <- 'https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/master/CoronaCases.csv'

corona <- read_csv(mygitpath)
 
# readin dataset with counties 
all.counties <- map_data("county")


# filter dataset to only include florida counties 
florida <- all.counties %>% 
  filter(region=="florida")

attach(corona)
attach(florida)

'%!in%' <- Negate('%in%')

# find mistakes 
# # part of my method was just looking at the unique counties and 
# # seeing that dade and unknown were the problems 
# # so i changed all the counties in the corona virus data set, 
# # grouped them by counties and then filtered out the unknown values 
# # and finally used tally() to count cases per county 

corona <- corona %>%
  mutate(County=tolower(County)) %>%
  group_by(County) %>%
  filter(County != 'unknown') %>% 
  tally() 

# using subseting I changed dade to miami-dade

corona$County[11] = 'miami-dade'

# now merge the two dataset 
florida <- left_join(florida, corona, by = c("subregion"="County"))
florida$n[is.na(florida$n)] <- 0

# create the base plot of the state with counties 
# # this code comes from the R Handout on our Canvas Page
base.plot <- ggplot(florida, aes(x=long, y=lat, group=group)) + 
  geom_polygon(aes(fill=n),color="purple", size=0.1) + 
  theme_void() + 
  labs(fill="Count of Cases", caption="Covid 19 Cases Across Florida Counties, Source: Florida Deptartment of Health from 3/22/2020") + 
  scale_fill_gradient(low = "aliceblue",
                      high = "brown4")


base.plot

# saves image in working directory 
ggsave("florida_covid.png", base.plot)


