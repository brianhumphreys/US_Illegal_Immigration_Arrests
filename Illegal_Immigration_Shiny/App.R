#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#Note: must run file Illegal_Immigration.R first for this script to work
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(
    title = "Illegal Immigration Arrests"),
  
  
  #sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("dashboard")),
      menuItem("Breakdown by Border", tabName = "borders", icon = icon("th")),
      menuItem("Breakdown by Sector", tabName = "sectors", icon = icon("th"))
    )
  ),
  
  #body content
  dashboardBody(
    tags$head(tags$style(HTML('
                              .content-wrapper, .main-body {
                              font-weight: normal;
                              font-size: 18px;
                              } '))),
    
    tabItems(
      
      #first tab content
      tabItem(tabName = "overview",
              
              fluidRow(
                box(plotlyOutput("totals", height = 825), width = 8, height = 850),
                box(dataTableOutput("table"), width = 4))
      ),
      
      #second tab content
      tabItem(tabName = "borders",
              fluidRow(
                box(plotlyOutput("border", height = 825), width = 8, height = 850),
                box(selectInput("bor", 
                                label = "Choose from borders", 
                                choices = list("Coast", "North", "Southwest"), 
                                selected = "Coast"), width = 3),
                box(h3("Analysis of each area of arrest:"),
                    p(
                      tags$ul(
                        tags$li("For arrests made along the coastlines of our country, 
                                there is a larger presence of non-Mexican arrests made. 
                                Both time series suggest a similar pattern in arrests made 
                                over the years that strongly correlate differing mostly in 
                                quantity."),
                        tags$li("Arrests made along the Northern border also indicate a larger presence 
                                of non-Mexican arrests. Both suggesting a decreasing trend in arrests made."),
                        tags$li("Arrests made along the Southwestern border indicate that the amount of 
                                arrests made is very similar between Mexican and non-Mexican immigrants."))),
                    width = 3))
              
      ),
      
      
      
      #third tab content
      tabItem(tabName = "sectors",
              fluidRow(
                box(plotlyOutput("mapplot", height = 625), width = 8, height = 650),
                
                box(sliderInput("year",
                                "Year:",
                                min = 2000,
                                max = 2016,
                                value = 2016), width = 4),
                fluidRow(
                  box(plotlyOutput("barplot", height = 475), width = 4, height = 500))
              ),
              box(
              h3("Plotly How-to"), 
              p("Both of these graphs are fully interactive. You can select the year you 
                 want to look at by moving the slider bar in the top right, zoom in on the graphs, 
                 and even select which demographics you want to display by clicking on the legends."),
              h3("Analysis"), 
              p("From the years 2000-2010, the arrest numbers for Mexicans and All Immigrants were 
                very similar. Tucson, Arizona was responsible for the overwhelming majority of the arrests 
                until there was a change of arrests made in 2013. In 2011-2012, there was a drop in 
                the number of arrests in Tucson as well as an increase in the number of arrests in 
                Rio Grande Valley, Texas (the sector with the second highest arrest totals).  
                Additionally there was an increase in the separation between the arrest numbers for 
                Mexicans and All Immigrants, where there were decreasing Mexican arrests and increasing 
                non-Mexican arrests.  From 2013 on, these trends continued and the majority of arrests
                began occuring in Rio Grande Valley, with significantly more arrests for the All Immigrants 
                demographic.  By 2016, the vast majority of arrests occured in Rio Grande Valley, 
                and only a small percentage of the arrestees were Mexicans."),
              width = 1000,
              collapsible = TRUE)
      )
    )
    )
    )




server <- function(input, output) { 
  output$totals <- renderPlotly({
    ggplotly(tot)
  })
  output$table <- renderDataTable(
    percentages, {
      options = list(
        pageLength = 15, # Only outputs first 10 values to be more aesthetically pleasing
        scrollX = TRUE) 
    })
  output$border <- renderPlotly({
    choices <- switch(input$bor,
                      "Coast" = border("Coast", "Illegal Immigration Arrests Along the Coast"),
                      "North" = border("North", "Illegal Immigration Arrests at Northern Border") ,
                      "Southwest" = border("Southwest", "Illegal Immigration Arrests at Southwest Border"))
  })
  
  output$barplot <- renderPlotly({
    yearPlot(input$year)
  })
  output$mapplot <- renderPlotly({
    mapPlot(input$year)
  })
  
  
}

shinyApp(ui, server)



