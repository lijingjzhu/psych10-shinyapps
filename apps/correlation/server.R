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
library(MASS)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    target_cor <- input$correlation
    out <- mvrnorm(100, mu = c(0,0), 
                   Sigma = matrix(c(1, target_cor, target_cor, 1),
                                  ncol = 2), 
                   empirical = TRUE)
    
    df <- tibble(x = out[,1], 
                 y = out[,2])
    df %>% 
      ggplot() +
      geom_point(mapping = aes(x = x, y = y)) +
      theme_bw() +
      coord_cartesian(xlim = c(-2, 2), ylim = c(-2, 2)) +
      labs(x = "X", y = "Y")
    
  })
  
})
