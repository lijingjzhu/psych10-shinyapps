#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    input_slope <- input$slope %>% as.numeric()
    
    ggplot() +
      geom_abline(slope = input_slope, intercept = 0) +
    
      coord_cartesian(x = c(0, 10), y = c(0, 50)) +
      labs(x = "X", y = "Y")
    
  })
  
})
