library(shiny)
library(plotly)
library(lubridate)
library(dplyr)
library(shinydashboard)

coronaFL <- read_csv('https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/Jamie/CoronaCases.csv')
Newest <- 

dashboardPage(
  dashboardHeader(title = "Florida's Corona Virus Situation"),
  dashboardSidebar(collapsed = TRUE),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(width=6, 
          status="info", 
          title="Total Number of Reported Cases by County",
          footer = Newest,
          solidHeader = TRUE,
          plotOutput("FLmap")
      ),
      box(width=6, 
          status="warning", 
          title = "Top 5 Counties",
          solidHeader = TRUE, 
          collapsible = TRUE, 
          footer="Read Remotely from File",
          tableOutput("mydata")
      )
    )
  )
)

