library(shiny)
library(readr)
library(tidyverse)
library(plotly)
library(leaflet)
library(shinydashboard)
library(ggplot2)
library(readr)
library(maps)
library(mapproj)


coronaFL <- read_csv('https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/Jamie/CoronaCases.csv')

floridaMap <- map_data("county") %>% filter(region == "florida")

coronaCases <- coronaFL %>% count(County) %>%  mutate(County = tolower(County)) 

#setdiff(coronaCases$County, floridaMap$subregion)

coronaCases <- coronaCases %>% mutate(County = fct_recode(County, `miami-dade` = "dade", `st johns` = "st. johns", `st lucie` = "st. lucie")) %>% filter(County != "unknown")
                                      
covidMap <- left_join(floridaMap, coronaCases, by =c(subregion= "County"))
shinyServer(function(input, output, session) {
  
  df <- reactiveFileReader(
    intervalMillis = 10000, 
    session = session,
    filePath = 'https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/Jamie/CoronaCases.csv',
    readFunc = read_csv)
  output$mydata <-renderTable({df() %>% group_by(County) %>%  summarize(Cases = n()) %>%  arrange(desc(Cases)) %>%  slice(c(1:5))
    })
  
  output$FLmap <- renderPlot({
    map <- ggplot(covidMap, aes(x = long, y = lat, group = group, fill = n)) + 
      geom_polygon(color = "black", size = 0.5) + theme_minimal() + scale_fill_viridis_c() + labs(fill = "Number of Cases") +
      coord_map(projection = "albers", lat0 = 25, lat1 = 31)
    map
})
  
  
  
})

