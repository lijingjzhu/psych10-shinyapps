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
shinyServer(function(input, output){
  data <- cars$speed
  
  output$distPlot <- renderPlot({
    mean_line <- mean(data)
    median_line <- median(data)
    mode_line <- names(sort(-table(data)))[1] %>% as.numeric()
    
    lines <- tribble(~Center, ~number,
            'Mean', mean_line,
            'Median', median_line,
            'Mode', mode_line)
    data %>% 
      as_tibble() %>% 
      ggplot() +
      geom_histogram(mapping = aes(x = value), binwidth = 1) +
      geom_vline(data = lines, mapping = aes(xintercept = number, 
                                             color = Center),
                 size = 1.5) +
      scale_x_continuous(breaks = seq(4, 25, by = 2)) +
      theme_bw() +
      coord_cartesian(xlim = c(4, 25), ylim = c(0, 5.5)) +
      labs(x = "Car Speed (mph)", y = "Count", 
           title = "Population Distribution")
  })
  
  output$sampPlot <- renderPlot({
    num <- input$sampsize
    set.seed(28)
    samp <- sample(x = data, size = num)
    mean_line <- mean(samp)
    median_line <- median(samp)
    mode_line <- names(sort(-table(samp)))[1] %>% as.numeric()
    
    lines <- tribble(~Center, ~number,
                     'Mean', mean_line,
                     'Median', median_line,
                     'Mode', mode_line)
    samp %>% 
      as_tibble() %>% 
      ggplot() +
      geom_histogram(mapping = aes(x = value), binwidth = 1) +
      geom_vline(data = lines, mapping = aes(xintercept = number, 
                                             color = Center),
                 size = 1.5) +
      scale_x_continuous(breaks = seq(4, 25, by = 2)) +
      theme_bw() +
      coord_cartesian(xlim = c(4, 25), ylim = c(0, 5.5)) +
      labs(x = "Car Speed (mph)", y = "Count", title = "Sampling Distribution")
  })
  
})
