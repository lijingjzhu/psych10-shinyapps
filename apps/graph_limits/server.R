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
library(datasets)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    limit_y_low <- input$limit_y_low
    limit_y_high <- input$limit_y_high
    bins <- input$n_breaks %>% as.numeric()
    limit_x_low <- input$limit_x_low
    limit_x_high <- input$limit_x_high
    
    faithful %>% 
      ggplot() +
      geom_histogram(mapping = aes(x = eruptions), binwidth = bins) +
      coord_cartesian(xlim = c(limit_x_low, limit_x_high),
                      ylim = c(limit_y_low, limit_y_high)) +
      theme_bw() +
      labs(x = "Duration of Eruption (min)", y = "Number of Eruptions")
  })
  
})
