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
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      p("Hello"),
      
      selectInput(inputId = "n_breaks",
                  label = "Binwidth of Histogram Bars:",
                  choices = c(0.1, 0.2, 0.3, 0.5, 0.8, 1),
                  selected = 1),
      
       sliderInput("limit_x_low",
                   "Lower X Limit",
                   min = -5,
                   max = 3,
                   value = -2),
       
       sliderInput("limit_x_high",
                   "Upper X Limit",
                   min = 1,
                   max = 10,
                   value = 9),
       
      sliderInput("limit_y_low",
                  "Lower Y Limit:",
                  min = -5,
                  max = 10,
                  value = -3),
      
      sliderInput("limit_y_high",
                  "Upper Y Limit:",
                  min = 1,
                  max = 120,
                  value = 50)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
