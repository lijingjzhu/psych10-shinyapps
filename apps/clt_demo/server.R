#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    library(tidyverse)
    
    bin_num <- input$n
    var_spread <- input$var
    dist_mean <- input$mean
    
    df <- tibble(val = rnorm(bin_num, mean = dist_mean, 
                             sd = sqrt(var_spread)))
    df %>% 
      ggplot() +
      geom_histogram(mapping = aes(x = val), binwidth = 1) +
      scale_x_continuous(breaks = seq(-100, 100, by = 5)) +
      theme_bw() +
      labs(x = "Generated Values from a Normal Distribution", 
           y = "Frequency") +
      coord_cartesian(x = c(-50, 50), y = c(0, 1000))
    
  })
  
})
