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
  titlePanel("Central Limit Theorem"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      p("The Central Limit Theorem states that given a sufficiently large \n
        sample size from a population with a finite level of variance, \n
        the mean of all samples from the same population will be \n
        approximately equal to the mean of the population."),
       sliderInput("n",
                   "Sample Size",
                   min = 10,
                   max = 2500,
                   step = 5,
                   value = 500,
                   dragRange = FALSE),
       sliderInput("var",
                   "Variance",
                   min = 1,
                   max = 200,
                   step = 50,
                   value = 5,
                   dragRange = FALSE),
       sliderInput("mean",
                   "Distribution Mean",
                   min = -30,
                   max = 30,
                   step = 10,
                   value = 10,
                   dragRange = FALSE)
    ),

    mainPanel(
       plotOutput("distPlot"),
       h4("Questions"),
       p("1. What happens when you increase the variance?"),
       p("2. What happens when you change the mean?"),
       p("3. What happens when you increase the sample size?")
    )
  )
))
