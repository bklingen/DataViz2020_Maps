library(shiny)
library(plotly)
library(lubridate)
library(dplyr)
library(shinydashboard)

coronaFL <- read.csv('https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/master/coronacases_APR1.csv')
states <- sort(unique(coronaFL$state))
#states <- tolower(states)

dashboardPage(
  dashboardHeader(title = "The United States' Current COVID-19 Situation"),
  dashboardSidebar(
    sidebarMenu(
      radioButtons("counts", "View Counts By:", choices = c("Cases", "Deaths"), selected = "Cases"),
      selectInput("state", "Select State", choices = states, selected = "Florida"),
      
      menuItem("Map and Table", tabName= "tab1"),
      menuItem("Plot", tabName = "tab2")
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "tab1",
        # Boxes need to be put in a row (or column)
        fluidRow(
          box(width=6,
              status="info",
              title="COVID-19 State Heatmap",
              solidHeader = TRUE,
              plotOutput("map")
          ),
          box(width=6, 
            status="warning", 
            title = "Counts By County",
            solidHeader = TRUE, 
            collapsible = TRUE, 
            footer="Read Remotely from File",
            textOutput("text"),
            tableOutput("mydata")
          )
        )
      ),
      tabItem(tabName="tab2",
        fluidRow(
          # box(width=6, 
          #   status="info", 
          #   title="Total Number of Reported Cases by County",
          #   solidHeader = TRUE,
          #   #plotOutput("FLmap")
          # ),
          box(width=6, 
            status="warning", 
            title = "Correlation of Cases and Deaths By State",
            solidHeader = TRUE, 
            collapsible = TRUE, 
            footer="Read Remotely from File",
            plotlyOutput("mydata2")
          )
        )
      )
    )   
  )
)
