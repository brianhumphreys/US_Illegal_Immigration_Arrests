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
library(plotly)

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
                box(title = "Project Goal", width = 12,
                    "Illegal immigration has always been a controversial issue. This is especially true now with 
                    our country's current politcal situation. Like everyone else, I have my own opinions on the topic, 
                    but I will do my best to remain unbiased in my analysis and report only facts rather than opinions. 
                    My goal is to explore trends in US illegal immigration arrests from 2000-2016 as 
                    objectively as possible."
                ),

                fluidRow(
                  box(plotlyOutput("totals", width = 900, height = 620), width = 7),
                  box(dataTableOutput("table"), width = 5)
                ),
                box(title = "Notes About the Data Set", width = 12,
                    collapsible = TRUE,
                    p("The dataset I used for this project can be found on the Kaggle website.
                    
                    Here is a link to the original dataset: https://www.kaggle.com/cbp/illegal-immigrants
                    
                    The original dataset was extremely messy so it required some cleaning before any analysis could be done. 
                    I have uploaded the 'clean' dataset as a csv file as well. It contains information on two demographics: 
                    Mexican Illegal Immigrants and All Illegal Immigrants.
                    
                    It is important to note that the numbers listed are only the illegal immigrants that were ARRESTED. 
                    This means that there were almost certainly more illegal immigrants each year that managed to enter 
                    the country unnoticed. As such I cannot claim that my analysis is an accurate representation of trends 
                    in illegal immigration overall; it only extends to illegal immigrants that were arrested.")
                )
                )),
      
      #second tab content
      tabItem(tabName = "borders",
              selectInput("var", 
                          label = "Choose from borders", 
                          choices = list("Coast", "Northern", "Southwest"), 
                          selected = "Coast"),
              box(
                plotlyOutput("ggpanel", width = 1000, height = 626), width = 8),
              box(title = "Notes About each visual",
                p("Some more indepth Analysis of Each area of Arrest",
                  tags$ul(
                    tags$li("Analysis w.r.t. Coast. I'll add more filler 
                            sentences just so that it can be in paragraph
                            format so that I can see how it will look like. 
                            Once we add some actual analysis about each section."),
                    tags$li("Analysis w.r.t. Northern Border. I'll add more filler 
                            sentences just so that it can be in paragraph
                            format so that I can see how it will look like. 
                            Once we add some actual analysis about each section."),
                    tags$li("Analysis w.r.t. Southwestern Border. I'll add more filler 
                            sentences just so that it can be in paragraph
                            format so that I can see how it will look like. 
                            Once we add some actual analysis about each section."))), 
                width = 3
              )
              ),
      
      #third tab content
      tabItem(tabName = "sectors",
              fluidRow(
                box(plotlyOutput("mapplot", width = 1000, height = 700), 
                    width = 8, 
                    collapsible = TRUE),
                box(p("Somebody once told me the world is gonna roll me
                      I ain't the sharpest tool in the shed
                      She was looking kind of dumb with her finger and her thumb
                      In the shape of an 'L' on her forehead"),
                      br(),
                      p("Well the years start coming and they don't stop coming
                      Fed to the rules and I hit the ground running
                      Didn't make sense not to live for fun
                      Your brain gets smart but your head gets dumb
                      So much to do, so much to see
                      So what's wrong with taking the back streets?
                      You'll never know if you don't go
                      You'll never shine if you don't glow"), width = 4)),
              
              box(sliderInput("year",
                              "Year:",
                              min = 2000,
                              max = 2016,
                              value = 2016), width = 4),
              fluidRow(
                box(plotlyOutput("barplot", width = 1000, height = 650), width = 8),
                box(p("What the fuck did you just fucking say about me, 
                      you little bitch? I’ll have you know I graduated top of 
                      my class in the Navy Seals, and I’ve been involved in numerous
                      secret raids on Al-Quaeda, and I have over 300 confirmed kills. 
                      I am trained in gorilla warfare and I’m the top sniper in the entire 
                      US armed forces. You are nothing to me but just another target. 
                      I will wipe you the fuck out with precision the likes of which has 
                      never been seen before on this Earth, mark my fucking words. 
                      You think you can get away with saying that shit to me over the Internet?
                      Think again, fucker. As we speak I am contacting my secret network of 
                      spies across the USA and your IP is being traced right now so you better
                      prepare for the storm, maggot. The storm that wipes out the pathetic 
                      little thing you call your life. You’re fucking dead, kid. I can be 
                      anywhere, anytime, and I can kill you in over seven hundred ways, 
                      and that’s just with my bare hands. Not only am I extensively trained in 
                      unarmed combat, but I have access to the entire arsenal of the 
                      United States Marine Corps and I will use it to its full extent to 
                      wipe your miserable ass off the face of the continent, you little shit. 
                      If only you could have known what unholy retribution your little “clever”
                      comment was about to bring down upon you, maybe you would have held your
                      fucking tongue. But you couldn’t, you didn’t, and now you’re paying the 
                      price, you goddamn idiot. I will shit fury all over you and you will 
                      drown in it. You’re fucking dead, kiddo."), width = 4)
              ))
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
    pageLength = 10, # Only outputs first 10 values to be more aesthetically pleasing
    scrollX = TRUE) 
  })
  output$coast <- renderPlotly({
    ggplotly(coast)
  })
  output$north <- renderPlotly({
    ggplotly(north) 
  })
  output$southwest <- renderPlotly({
    ggplotly(southwest)
  })
  output$barplot <- renderPlotly({
    yearPlot(input$year)
  })
  output$mapplot <- renderPlotly({
    mapPlot(input$year) 
  })
  output$ggpanel <- renderPlotly({
    choices <- switch(input$var,
                      "Coast" = ggplotly(coast),
                      "Northern" = ggplotly(north,  kwargs=list(layout=list(hovermode="closest"))) ,
                      "Southwest" = ggplotly(southwest)  
    )
  })
  
}

shinyApp(ui, server)