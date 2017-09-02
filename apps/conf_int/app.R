library(shiny)
library(tidyverse)
library(stringr)

ui <- fluidPage(
   
   titlePanel("Confidence Intervals"),
   
   sidebarLayout(
      sidebarPanel(
        p("A Confidence Interval (CI) is a range estimate of our target
          population parameter computed from our sample data. 
          The Confidence Level determines the width of the interval. It
          represents the likelihood of a CI to contain the true population
          parameter. For example, if we construct 100 95% Confidence
          Intervals, then approximately 95% of those ranges will contain
          the true population parameter."),
        p(""),
        p("In this visualization, we will use the sat.act data set.
          The sat.act data set contains 700 observations of
          self-reported ACT scores. In this visualization, we 
          examine more closely the mean of the ACT score 
          distribution."),
        p(""),
        p("Change the Confidence Levels and the Number of Trials
          to see how many Confidence Intervals actually contain
          the true population mean."),
        
         selectInput("sig",
                     "Confidence Level:",
                     choices = c("95% CI" = 0.95,
                                 "90% CI" = 0.90,
                                 "80% CI" = 0.80,
                                 "70% CI" = 0.70,
                                 "60% CI" = 0.60)),
         selectInput("trials",
                     "Number of Trials",
                     choices = c("10 Trials" = 10,
                                 "15 Trials" = 15,
                                 "20 Trials" = 20,
                                 "25 Trials" = 25)),
        
        p("Click \"Display\" to see 
           CI range estimates of the ACT mean score."),
        
        actionButton("refresh", "Display Confidence Intervals"),
        
        h4("Questions"),
        p("1. How does the confidence level influence the width of 
          the confidence interval?"),
        p("2. True or False: Given a 80% CI, there is an 80% 
          probability that the true population parameter will be 
          in that interval."),
        p("3. The national ACT composite scores have a mean of 20. 
          Given our CI in this visualization, what are some next steps in our 
          investigation? What are some other research questions to ask?")
      ),
      
      mainPanel(
         plotOutput("origPlot"),
         plotOutput("distPlot")
      )
   )
)

server <- function(input, output) {
   
   output$origPlot <- renderPlot({
     # Getting the mean of the scores
     fit <- lm(data = sat.act, ACT ~ 1)
     sat.act %>% 
       ggplot() +
       geom_histogram(mapping = aes(x = ACT), binwidth = 2) +
       geom_vline(mapping = aes(xintercept = mean(sat.act$ACT)),
                  color = "blue", size = 1) +
       scale_x_continuous(breaks = seq(0, 40, by = 5)) +
       theme_bw() +
       labs(x = "Self-Reported ACT Score", y = "Frequency",
            title = "Population Distribution with Mean of 28.5")
   })

# Confidence interval display
observeEvent(input$refresh, {   
    output$distPlot <- renderPlot({
    n <- input$trials %>% as.numeric()
    sig <- input$sig %>% as.numeric()
    
    points <- tibble(trial = 1:n,
                     true_mean = mean(sat.act$ACT))
    
    df <- tibble(trial = rep(1:n, each = 200),
           samp = sample(sat.act$ACT, size = n * 200, 
                         replace = TRUE)) %>% 
          group_by(trial) %>% 
          do(samp_mean = lm(data = ., samp ~ 1) %>% coef(),
             lower = confint(lm(data = ., samp ~ 1),
                             level = sig)[[1]],
             upper = confint(lm(data = ., samp ~ 1),
                             level = sig)[[2]]) %>% 
      ungroup() %>% 
      mutate(samp_mean = samp_mean %>% unlist() %>% as.numeric(),
             lower = lower %>% unlist() %>% as.numeric(),
             upper = upper %>% unlist() %>% as.numeric(),
             in_range = ifelse(mean(sat.act$ACT) < lower, "False",
                               "True"),
             in_range = ifelse(mean(sat.act$ACT) > upper, "False",
                               "True"),
             in_range = factor(in_range, 
                               levels = c("True", "False")))
    
    df %>% 
      ggplot() +
      geom_segment(mapping = aes(x = lower, xend = upper,
                                 y = factor(trial), 
                                 yend = factor(trial),
                                 color = in_range), size = 1) +
      geom_point(mapping = aes(x = lower, y = factor(trial),
                               color = in_range), size = 2) +
      geom_point(mapping = aes(x = upper, y = factor(trial),
                               color = in_range), size = 2) +
      geom_vline(data = points, 
                 mapping = aes(xintercept = true_mean),
                 color = "blue", size = 1, alpha = 0.7) +
      theme_bw() +
      scale_x_continuous(breaks = seq(20, 35)) +
      scale_y_discrete(breaks = NULL) +
      scale_color_manual(breaks = c("True", "False"),
                         values = c("gray2", "firebrick2"),
                         labels = c("True", "False"),
                         drop = FALSE) +
      coord_cartesian(x = c(26.5, 30.5)) +
      labs(x = "Self-Reported ACT Scores", y = "Trial Number",
           title = str_c(sig*100, "% Confidence Intervals for
                         ACT Scores"), 
           color = "Confidence Interval \nCaptures Population Mean")
   })
})
}

# Run the application 
shinyApp(ui = ui, server = server)

