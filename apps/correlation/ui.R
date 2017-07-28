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
  titlePanel("Correlation of Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      p("Adjust the correlation of the X and Y variables to see how the points change."),
      p("What do points with a correlation of 1 look like? How about a correlation of -1?"),
       sliderInput("correlation",
                   "Correlation of Points",
                   min = -1,
                   max = 1,
                   value = 0.5,
                   step = 0.05)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
