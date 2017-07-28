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
  titlePanel("What is the slope of a line?"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("slope",
                   "Slope of line:",
                   min = 0,
                   max = 80,
                   value = 30, 
                   step = 0.1),
       h4("Questions"),
       p("1. What is the slope of a horizontal line?"),
       p("2. What is the slope of a vertical line?"),
       p("3. What happens when you increase the slope of a line? Decrease it?")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
      )
  )
))
