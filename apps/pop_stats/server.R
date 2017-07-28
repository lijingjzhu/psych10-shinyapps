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
  data <- c(rep(0, 100), rep(1, 3), 
            rep(2, 15), rep(3, 70), rep(4, 6),
            rep(5, 56), rep(6, 120), rep(7, 150), rep(8, 50))
  
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
      theme_bw() +
      coord_cartesian(xlim = c(0, 8), ylim = c(0, 250)) +
      labs(x = "Data", y = "Count", title = "Population Distribution")
  })
  
  output$sampPlot <- renderPlot({
    num <- input$sampsize
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
      theme_bw() +
      coord_cartesian(xlim = c(0, 8), ylim = c(0, 250)) +
      labs(x = "Data", y = "Count", title = "Sampling Distribution")
  })
  
})
