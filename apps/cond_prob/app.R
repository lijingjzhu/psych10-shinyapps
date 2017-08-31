library(shiny)
library(tidyverse)

ui <- fluidPage(
   
   titlePanel("Decoding Conditional Probability"),
   
   sidebarLayout(
      sidebarPanel(
         p("Conditional probability is essentially an updated calculation of an 
           event happening given that we have extra information about. When 
           calculating the probability of Event A, we use the entire 
           probability space of Event A. However, when we are given 
           extra information (for example, we know that Event B also happened),
           then the conditional probability of Event A takes on the denominator of 
           the probability of B."),
         p("The intuition of conditional probability can be further explained 
           using Bayes Theorem, which states that the conditional probability 
           of Event A given Event B is equal to the dividend of the probability 
           of Event A and Event B
           over the probability for Event B. P(A|B) = P(A, B)/P(B). "),
         p("In the visualization, you can choose the event you want to find 
           the probability for given that another event happened. Change 
           these parameters around to see how that changes the probability 
           space and the probability of the main event."),
         selectInput(inputId = "main_prob",
                     label = "Event of Probability:",
                    choices = c("A" = "A",
                               "B" = "B",
                               "C" = "C",
                               "D" = "D")),
         selectInput(inputId = "given_prob",
                     label = "Given Event:",
                     choices = c("A" = "A",
                                 "B" = "B",
                                 "C" = "C",
                                 "D" = "D")),
         checkboxInput(inputId = "show_lines",
                       label = "Show Given Probability Space", 
                       value = FALSE),
         h4("Questions"),
         p("1. What is the conditional probability of Event A given Event A?"),
         p("2. When is the conditional probability of an event equal to 
           its normal probability?"),
         p("3. How do you find the joint probability of Event A and B given 
           that you know the marginal probability and conditional probability?")
      ),
      
      mainPanel(
         plotOutput("distPlot"),
         plotOutput("mergePlot")
      )
   )
)

server <- function(input, output) {
   
  output$mergePlot <- renderPlot({
    grp_colors <- c("A" = "#8ED752", "B" = "#F95643", 
                     "C" = "#53AFFE", "D" = "#C3D221")
    
    rect_length <- c(7, 4, 5, 2)
    df <- tibble(rect_num = c("A", "B", "C", "D"),
                 xmin = c(0, 6, 2, 3),
                 xmax = xmin + rect_length,
                 ymin = seq(1, 7, by = 2),
                 ymax = seq(2, 8, by = 2))
    
    main_prob <- input$main_prob
    given_prob <- input$given_prob
    
    if (input$show_lines) {
      if (main_prob %in% given_prob) {
        xlow <- df %>% 
          filter(rect_num %in% c(given_prob, main_prob)) %>% 
          .$xmin
        
        xhigh <- df %>% 
          filter(rect_num %in% c(given_prob, main_prob)) %>% 
          .$xmax
        
        ylow <- df %>% 
          filter(rect_num %in% c(given_prob, main_prob)) %>% 
          .$ymin
        
        yhigh <- df %>% 
          filter(rect_num %in% c(given_prob, main_prob)) %>% 
          .$ymax
        
        new_rect <- tibble(rect_num = main_prob,
                           xmin = xlow, xmax = xhigh,
                           ymin = ylow + 2,
                           ymax = ymin + 1)
        df %>% 
          filter(rect_num %in% c(given_prob, main_prob)) %>% 
          ggplot() +
          geom_rect(mapping = aes(xmin = xmin, xmax = xmax,
                                  ymin = ymin, ymax = ymax,
                                  fill = rect_num),
                    alpha = 0.6) +
          geom_rect(data = new_rect, mapping = aes(xmin = xmin,
                                                   xmax = xmax,
                                                   ymin = ymin,
                                                   ymax = ymax,
                                                   fill = rect_num),
                    alpha = 0.6) +
          labs(fill = "Event Type") +
          theme_bw() +
          scale_x_continuous(breaks = seq(0, 10, by = 2)) +
          scale_y_continuous(breaks = 1:10) +
          scale_fill_manual(values = grp_colors) +
          geom_vline(mapping = aes(xintercept = xmin),
                     size = 1, color = "red") +
          geom_vline(mapping = aes(xintercept = xmax),
                     size = 1, color = "red")
        
      } else {
        xlow <- df %>% 
          filter(rect_num %in% main_prob) %>% 
          .$xmin
        
        xhigh <- df %>% 
          filter(rect_num %in% main_prob) %>% 
          .$xmax
        
        ylow <- df %>% 
          filter(rect_num %in% given_prob) %>% 
          .$ymin
        
        yhigh <- df %>% 
          filter(rect_num %in% given_prob) %>% 
          .$ymax
        
        new_rect <- tibble(rect_num = main_prob,
                           xmin = xlow, xmax = xhigh,
                           ymin = ylow + 2,
                           ymax = ymin + 1)
        
        df %>% 
          filter(rect_num %in% given_prob) %>% 
          ggplot() +
          geom_rect(mapping = aes(xmin = xmin, xmax = xmax,
                                  ymin = ymin, ymax = ymax,
                                  fill = rect_num),
                    alpha = 0.6) +
          geom_rect(data = new_rect, mapping = aes(xmin = xmin,
                                                   xmax = xmax,
                                                   ymin = ymin,
                                                   ymax = ymax,
                                                   fill = rect_num),
                    alpha = 0.6) +
          labs(fill = "Event Type") +
          theme_bw() +
          scale_x_continuous(breaks = seq(0, 10, by = 2)) +
          scale_y_continuous(breaks = 1:10) +
          scale_fill_manual(values = grp_colors) +
          geom_vline(mapping = aes(xintercept = xmin),
                     size = 1, color = "red") +
          geom_vline(mapping = aes(xintercept = xmax),
                     size = 1, color = "red")
      }
      
    } else {
      
    if (main_prob %in% given_prob) {
      xlow <- df %>% 
        filter(rect_num %in% c(given_prob, main_prob)) %>% 
        .$xmin
      
      xhigh <- df %>% 
        filter(rect_num %in% c(given_prob, main_prob)) %>% 
        .$xmax
      
      ylow <- df %>% 
        filter(rect_num %in% c(given_prob, main_prob)) %>% 
        .$ymin
      
      yhigh <- df %>% 
        filter(rect_num %in% c(given_prob, main_prob)) %>% 
        .$ymax
      
      new_rect <- tibble(rect_num = main_prob,
                         xmin = xlow, xmax = xhigh,
                         ymin = ylow + 2,
                         ymax = ymin + 1)
      df %>% 
        filter(rect_num %in% c(given_prob, main_prob)) %>% 
        ggplot() +
        geom_rect(mapping = aes(xmin = xmin, xmax = xmax,
                                ymin = ymin, ymax = ymax,
                                fill = rect_num),
                  alpha = 0.6) +
        geom_rect(data = new_rect, mapping = aes(xmin = xmin,
                                                 xmax = xmax,
                                                 ymin = ymin,
                                                 ymax = ymax,
                                                 fill = rect_num),
                  alpha = 0.6) +
        labs(fill = "Event Type") +
        theme_bw() +
        scale_x_continuous(breaks = seq(0, 10, by = 2)) +
        scale_y_continuous(breaks = 1:10) +
        scale_fill_manual(values = grp_colors)
      
    } else {
      xlow <- df %>% 
        filter(rect_num %in% main_prob) %>% 
        .$xmin
      
      xhigh <- df %>% 
        filter(rect_num %in% main_prob) %>% 
        .$xmax
      
      ylow <- df %>% 
        filter(rect_num %in% given_prob) %>% 
        .$ymin
      
      yhigh <- df %>% 
        filter(rect_num %in% given_prob) %>% 
        .$ymax
      
      new_rect <- tibble(rect_num = main_prob,
                         xmin = xlow, xmax = xhigh,
                         ymin = ylow + 2,
                         ymax = ymin + 1)
      
      df %>% 
        filter(rect_num %in% given_prob) %>% 
        ggplot() +
        geom_rect(mapping = aes(xmin = xmin, xmax = xmax,
                                ymin = ymin, ymax = ymax,
                                fill = rect_num),
                  alpha = 0.6) +
        geom_rect(data = new_rect, mapping = aes(xmin = xmin,
                                                 xmax = xmax,
                                                 ymin = ymin,
                                                 ymax = ymax,
                                                 fill = rect_num),
                  alpha = 0.6) +
        labs(fill = "Event Type") +
        theme_bw() +
        scale_x_continuous(breaks = seq(0, 10, by = 2)) +
        scale_y_continuous(breaks = 1:10) +
        scale_fill_manual(values = grp_colors)
    }
    }
  })
  
   output$distPlot <- renderPlot({

      rect_length <- c(7, 4, 5, 2)
      
      grp_colors <- c("A" = "#8ED752", "B" = "#F95643", 
                      "C" = "#53AFFE", "D" = "#C3D221")
      
      df <- tibble(rect_num = c("A", "B", "C", "D"),
             xmin = c(0, 6, 2, 3),
             xmax = xmin + rect_length,
             ymin = seq(1, 7, by = 2),
             ymax = seq(2, 8, by = 2))
      
      df %>% 
        ggplot() +
        geom_rect(mapping = aes(xmin = xmin, xmax = xmax,
                                ymin = ymin, ymax = ymax,
                                fill = rect_num),
                  alpha = 0.6) +
        labs(fill = "Event Type") +
        theme_bw() +
        scale_x_continuous(breaks = seq(0, 10, by = 2)) +
        scale_y_continuous(breaks = 1:10) +
        scale_fill_manual(values = grp_colors)
   })
}

shinyApp(ui = ui, server = server)
