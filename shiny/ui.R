# Course Project of Developing Data Products course
# ui.R for Shiny Application - Car's Explorer

library(shiny)
shinyUI(pageWithSidebar(
        
        # Application title
        headerPanel("Car's Explorer"),
        
        # SidebarPanel with:
        # 1) selectBox to select the variable to plot mpg ~ var 
        # 2) radioButtons to select automatic or manual transmission
        # 3) numericInput to input the car's weight
       
        sidebarPanel(
          h4("Explore car's mpg"),
          selectInput("variable", label = "vs. your choice of:",
                      c("transmission (am)" = "am",
                        "weight (wt)" = "wt")),
          p("Note: see output at explore tab"),
          br(),
          
          h4("Predict car's mpg"),
          radioButtons("transmission", label = "Select transmission:",
                       choices = list("automatic" = 0, "manual" = 1), selected = NULL),
          numericInput("weight", label = "Input weight (1.4 < lb/1000 < 5.6), e.g. 2.3 or 2.35", 2.3, min = 0, max = 6, step = 0.01),
          p("Note: see output at predict tab")
        ),
        # mainPanel with 3 tabs: 
        # Tab 1) explorotory plot of  mpg ~ var
        # Tab 2) Result of a prediction algorithm + a plot
        # Tab 3) supporting documentation
        mainPanel(
          tabsetPanel(type = "tabs", 
                            tabPanel("Explore", 
                                     h4(textOutput("caption")), 
                                     plotOutput("mpgPlot", width = "600", height = "400")), 
                            tabPanel("Predict", 
                                     h4('Predicted mpg for your input of transmission and weight (see also blue arrow on the plot below)'),
                                     verbatimTextOutput("prediction"),
                                     plotOutput("fitPlot", width = "600", height = "400")), 
                            tabPanel("Documentation", verbatimTextOutput("documentation"))
                      )
        )
))
