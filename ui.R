library(shiny)
library(plotly)
library(lubridate)
library(dplyr)
library(shinydashboard)

coronaFL <- read_csv('https://raw.githubusercontent.com/bklingen/DataViz2020_Maps/master/CoronaCases.csv')


dashboardPage(
  dashboardHeader(title = "Florida's Corona Virus Situation"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Tab 1", tabName= "tab1",
                radioButtons("counts", "View Counts By:", choices = c("Cases", "Deaths"), selected = "Cases"),
                dateRangeInput("date", "Select Date Range", start = "2020-03-10", min = "2020-03-10")
               ),
      menuItem("Tab 2", tabName = "tab2")
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "tab1",
        # Boxes need to be put in a row (or column)
        fluidRow(
          box(width=6, 
              status="info", 
              title="Total Number of Reported Cases by County",
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
      ),
      tabItem(tabName="tab2",
        fluidRow(
          box(width=6, 
            status="info", 
            title="Total Number of Reported Cases by County",
            solidHeader = TRUE,
            #plotOutput("FLmap")
          ),
          box(width=6, 
            status="warning", 
            title = "Top 5 Counties",
            solidHeader = TRUE, 
            collapsible = TRUE, 
            footer="Read Remotely from File",
            #tableOutput("mydata")
          )
        )
      )
    )   
  )
)
