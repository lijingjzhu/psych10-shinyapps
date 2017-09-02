library(shiny)
library(tidyverse)

ui <- fluidPage(
   
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
)


server <- function(input, output) {
   
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
}

# Run the application 
shinyApp(ui = ui, server = server)

