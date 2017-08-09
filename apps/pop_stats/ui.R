#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Population vs. Sampling Distributions"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       p("A population distribution is the distribution that results when
         you sample everyone in your target population. This means that
         if we are interested in a center measure (mean, median), then the
        center of our population distribution will be the true parameter of 
        interest. A sampling distribution is the distribution that results
         when we only look at a sample of our population. Note that our 
         estimates of the population center might be biased or different
         than our true population centers. Change the size of the sample to see
         how the mean, median, and mode might change."),
       
       sliderInput("sampsize",
                   "Size of Sample:",
                   min = 1,
                   max = 50,
                   value = 1),
       h4("Questions"),
       p("1. What is the minimum sample size you need to get approximately
         the correct estimates of the mean, median, and mode?"),
       
       p("2. The entire population contains the speeds of 50 cars. Given your 
        answer from part 1, can we estimate the mean with a 
        sample size of 15?"),
       
       p("3. Which is the most robust central measure given this data?")
    ),
    
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       plotOutput("sampPlot")
    )
  )
))
