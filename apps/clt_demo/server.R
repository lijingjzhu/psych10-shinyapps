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
  set.seed(1)
  pop_size <- 5000
  data <- reactive({ tibble(uniform = runif(n = pop_size, min = 0, max = 4),
           weibull = rweibull(n = pop_size, shape = 1),
           normal = rnorm(n = pop_size, 0, 1),
           tdist = rt(n = pop_size, df = 1)) })
  
  output$mainPlot <- renderPlot({
    dist <- input$distribution
   
    
    df <- tibble(val = c(as.matrix(data()[,dist]))) 
    
    curr_plot <- df %>% 
      ggplot(mapping = aes(x = val)) +
      geom_histogram(mapping = aes(y = ..density..), binwidth = 1) +
      theme_bw() +
      labs(x = "", y = "Density", title = "Original Population Distribution") +
      coord_cartesian(xlim = c(mean(df$val) - 3*sd(df$val), 
                               mean(df$val) + 3*sd(df$val))) 
    
    if (input$pop_mean == TRUE) {
        curr_plot +
          geom_vline(mapping = aes(xintercept = mean(df$val)), 
                     color = "red", size = 1)
    } else {
        curr_plot
    }
      
    
  })
  
  output$distPlot <- renderPlot({
    dist <- input$distribution
    sampsize <- input$n
    
    samp_means <- array(0, sampsize)
    
    set.seed(12)
    for (i in 1:sampsize) {
      samp_means[i] <- tibble(val = c(as.matrix(data()[,dist]))) %>% 
        sample_n(size = sampsize, replace = FALSE) %>% 
        .$val %>% 
        mean()
    }
    
    samp_plot <- tibble(val = samp_means) %>% 
      ggplot(mapping = aes(x = val)) +
      geom_histogram(aes(y = ..density..)) +
      theme_bw() +
      labs(x = "Distribution of Sample Means", 
           y = "Density", title = "Sampling Distribution") +
      coord_cartesian(xlim = c(mean(samp_means) - 3*sd(samp_means), 
                               mean(samp_means) + 3*sd(samp_means)))
    
    if (input$samp_mean == TRUE) {
      if (input$overlay == TRUE) {
        samp_plot +
        geom_vline(xintercept = mean(samp_means), color = "red",
                   size = 1) +
          stat_function(fun = dnorm,
                        color = "blue",
                        args = list(mean = mean(samp_means),
                                    sd = sd(samp_means)),
                        size = 1) 
      } else {
        samp_plot +
          geom_vline(xintercept = mean(samp_means), color = "red",
                     size = 1) 
      }
    } else {
      if (input$overlay == TRUE) {
        samp_plot +
          stat_function(fun = dnorm,
                        color = "blue",
                        args = list(mean = mean(samp_means),
                                    sd = sd(samp_means)),
                        size = 1)
      } else {
        samp_plot
      }
    }
    
  })
  
})
