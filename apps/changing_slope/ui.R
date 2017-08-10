#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Linear Regression and Residual Sum of Squares"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      p("The goal of linear regression is to find a line of best fit. 
      The line of best fit explains the variation in the data points the best. 
        A common way too optimize for the best linear fit is to minimize the
        residual sum of squares (RSS). The RSS is one of the many measures
        of the amount of variance that is not captured or explained by
        our linear model."),
      sliderInput("slope",
                   "Slope of line:",
                   min = -10,
                   max = 10,
                   value = 0, 
                   step = 0.01),
       sliderInput("intercept",
                   "Y-Intercept",
                   min = -20,
                   max = 20,
                   value = 6, 
                   step = 0.01),
       p(""),
      sliderInput("cor",
                  "Correlation of Points",
                  min = -1,
                  max = 1,
                  value = 0.5, 
                  step = 0.1),
       checkboxInput("answer", "Reveal Line of Best Fit", FALSE),
       checkboxInput("resid", "Show Residual Lines", FALSE),
       h4("Questions"),
       p("1. True or False: Different best fit lines on different data have
         the same sum of residuals. "),
       p("2. What are some assumptions of a linear model?"),
       p("3. What are pros and cons of a linear model?")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       dataTableOutput("rss_table"),
       textOutput("best_fit")
      )
  )
))
