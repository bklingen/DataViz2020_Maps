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
library(lubridate)
library(dplyr)


coronaFL <- read.csv('https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/master/coronacases_APR1.csv')
coronaFL <- coronaFL %>% filter(state == "Florida")

floridaMap <- map_data("county") %>% filter(region == "florida")

USA <- map_data("county")
coronaCases <- coronaFL %>% count(county) %>%  mutate(county = tolower(county)) 

#setdiff(coronaCases$county, floridaMap$subregion)

coronaCases <- coronaCases %>% mutate(county = fct_recode(county, `st johns` = "st. johns", `st lucie` = "st. lucie", `de soto` = "desoto")) %>% filter(county != "unknown")

covidMap <- left_join(floridaMap, coronaCases, by =c(subregion= "county"))

shinyServer(function(input, output, session) {


  df <- reactiveFileReader(
    intervalMillis = 10000, 
    session = session,
    filePath = 'https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/master/coronacases_APR1.csv',
    readFunc = read.csv)
  
  dfC <- reactive({
    df <- select(df(), -c(date)) %>%  filter(state == input$state) %>% group_by(county) %>%  arrange(desc(cases)) %>% slice(1) %>%  ungroup
    df
    
  })
  
  dfD <- reactive({
    df <- select(df(), -c(date)) %>%  filter(state == input$state) %>% group_by(county) %>%  arrange(desc(deaths)) %>% slice(1) %>%  ungroup
    df
    
  })
  
  
  output$text <- renderText({
    #tdate <- format(Sys.Date(), format="%m/%d/%Y")
    tdate <- "4/1/2020"
    #date <- df()[1,]
    #paste("Start Date:", format(input$date[1], format="%m/%d/%Y"),date)
    paste("Counts current as of:",tdate)
  })

  dfR <- reactive({dfC() %>% select(county, cases) %>%  arrange(desc(cases))})
  dfR2 <- reactive({dfD() %>% select(county, deaths) %>%  arrange(desc(deaths))})  
  observeEvent(input$counts, {
    output$mydata <-renderTable({
      if (input$counts == "Cases") {df = dfR()}
      if (input$counts == "Deaths") {df = dfR2()}
    return(df)
    })
  })
  
  output$FLmap <- renderPlot({
    
    map <- ggplot(covidMap, aes(x = long, y = lat, group = group, fill = n)) +
      geom_polygon(color = "black", size = 0.5) + theme_minimal() + scale_fill_viridis_c() + labs(fill = "Number of Cases") +
      coord_map(projection = "albers", lat0 = 25, lat1 = 31)
    map
})

  output$map <- renderPlot({
    corona <- read.csv('https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/master/coronacases_APR1.csv')
    reg <- tolower(input$state)
    stateMap <- USA %>%  filter(region == reg)
    
    if(input$counts == "Cases"){
      coronaCases <- select(corona, -c(date)) %>%  filter(state == input$state) %>%  mutate(county = tolower(county)) %>%  group_by(county) %>% filter(county != "unknown") %>% arrange(desc(cases)) %>% slice(1)
      covidMap <- left_join(stateMap, coronaCases, by =c(subregion= "county"))
      map <- ggplot(covidMap, aes(x = long, y = lat, group = group, fill = cases)) +
          geom_polygon(color = "black", size = 0.5) + theme_minimal() + scale_fill_viridis_c() + labs(fill = "Number of Cases") +
          coord_map(projection = "albers", lat0 = 25, lat1 = 31)
      
         
    }
    if(input$counts == "Deaths"){
      coronaCases <- select(corona, -c(date)) %>%  filter(state == input$state) %>%  mutate(county = tolower(county)) %>%  group_by(county) %>% filter(county != "unknown") %>% arrange(desc(deaths)) %>% slice(1)
      covidMap <- left_join(stateMap, coronaCases, by =c(subregion= "county"))
      map <- ggplot(covidMap, aes(x = long, y = lat, group = group, fill = deaths)) +
        geom_polygon(color = "black", size = 0.5) + theme_minimal() + scale_fill_viridis_c() + labs(fill = "Number of Cases") +
        coord_map(projection = "albers", lat0 = 25, lat1 = 31)
     
    }
    
    map
    
  })  
  
  output$mydata2 <- renderPlotly({
    corona <- read.csv('https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/master/coronacases_APR1.csv')
  
    coronaCases <- select(corona, -c(date)) %>%  filter(state == input$state) %>%  group_by(county) %>% filter(county != "unknown") %>% arrange(desc(cases)) %>% slice(1)
    coronaCases <- select(corona, -c(date)) %>%  filter(state == input$state) %>%  group_by(county) %>% filter(county != "unknown") %>% arrange(desc(deaths)) %>% slice(1)
    #plot <- ggplot(coronaCases, aes(x=cases, y=deaths)) + geom_point() + geom_smooth(method = lm)
    #plot
    

    plot <- plot_ly(data = coronaCases, x = ~cases, y = ~deaths, text = ~county) %>%
      layout(title = input$state)
    plot

    
  })
  
})

