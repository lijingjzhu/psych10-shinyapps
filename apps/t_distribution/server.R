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
    
    deg <- input$freedom
    df <- tibble(val = rt(1000, df = deg))
    df %>% 
      ggplot() +
      geom_histogram(mapping = aes(x = val)) +
      coord_cartesian(x = c(-4, 4)) +
      theme_bw() +
      labs(x = "X", y = "Frequency")
    
  })
  
})
