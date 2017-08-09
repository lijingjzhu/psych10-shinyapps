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
library(stringr)
library(MASS)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  set.seed(78)
  v <- reactiveValues(data = mvrnorm(n = 15,
                                     mu = c(6, 6),
                                     Sigma = matrix(c(1, 0.5, 0.5, 1),
                                                    ncol = 2)) %>% 
                        as_tibble() %>% 
                        rename(x = V1, y = V2))

observeEvent(input$cor, {
  
  v <- reactiveValues(data = mvrnorm(n = 15,
                                     mu = c(6, 6),
                                     Sigma = matrix(c(1, input$cor, 
                                                      input$cor, 1),
                                                    ncol = 2)) %>% 
                        as_tibble() %>% 
                        rename(x = V1, y = V2))
  
  observeEvent(input$resid, {
    
  output$distPlot <- renderPlot({
    fit <- lm(data = v$data, y ~ x)
    
    input_slope <- input$slope %>% as.numeric()
    input_intercept <- input$intercept %>% as.numeric()
    slope_real <- coef(fit)[2]
    int_real <- coef(fit)[1]
    
    if (input$answer == TRUE) {
      
      plot_img <- v$data %>% 
        ggplot() +
        geom_point(mapping = aes(x = x, y = y)) +
        geom_abline(slope = input_slope, intercept = input_intercept,
                    size = 1, color = "blue") +
        geom_abline(slope = slope_real, intercept = int_real,
                    size = 1, color = "black") +
        theme_bw() +
        labs(x = "X", y = "Y") +
        coord_cartesian(xlim = c(4, 7), ylim = c(4, 8))
      
      if (input$resid == TRUE) {
        v$data %>% 
          group_by(x) %>% 
          mutate(fitted_values = input$intercept + x * input$slope,
                 top_y = max(y, fitted_values),
                 bottom_y = min(y, fitted_values)) %>%  
          ungroup() %>% 
          ggplot() +
          geom_point(mapping = aes(x = x, y = y)) +
          geom_abline(slope = input_slope, intercept = input_intercept,
                      size = 1, color = "blue") +
          geom_abline(slope = slope_real, intercept = int_real,
                      size = 1, color = "black") +
          geom_segment(mapping = aes(x = x, y = top_y, xend = x, 
                                     yend = bottom_y), 
                                     colour = "red") +
          theme_bw() +
          labs(x = "X", y = "Y", colour = NULL) +
          coord_cartesian(xlim = c(4, 7), ylim = c(4, 8))
        
      } else {
        plot_img
      }
    } else {
      plot_img <- v$data %>% 
        ggplot() +
        geom_point(mapping = aes(x = x, y = y)) +
        geom_abline(slope = input_slope, intercept = input_intercept,
                    size = 1, color = "blue") +
        theme_bw() +
        labs(x = "X", y = "Y") +
        coord_cartesian(xlim = c(4, 7), ylim = c(4, 8))
      
      if (input$resid == TRUE) {
        v$data %>% 
          group_by(x) %>% 
          mutate(fitted_values = input$intercept + x * input$slope,
                 top_y = max(y, fitted_values),
                 bottom_y = min(y, fitted_values)) %>%  
          ungroup() %>% 
          ggplot() +
          geom_point(mapping = aes(x = x, y = y)) +
          geom_abline(slope = input_slope, intercept = input_intercept,
                      size = 1, color = "blue") +
          geom_segment(mapping = aes(x = x, y = top_y, xend = x, 
                                     yend = bottom_y), 
                                     colour = "red") +
          theme_bw() +
          labs(x = "X", y = "Y", colour = NULL) +
          coord_cartesian(xlim = c(4, 7), ylim = c(4, 8))
        
      } else {
        plot_img
      }
    }
  })
  })  
  })

  output$rss_table <- renderDataTable(
    df <- v$data %>% 
      mutate(fitted_values = input$intercept + x * input$slope,
             residuals = y - fitted_values,
             residuals_squared = residuals^2) %>% 
      summarise(`Sum of Residuals` = sum(residuals) %>% round(1),
                `RSS` = sum(residuals_squared) %>% round(1))
    )
  
  output$best_fit <- renderText({
    fit <- lm(data = v$data, y ~ x)
    
    if (input$answer == TRUE) {
      str_c("The line of best fit has an intercept of ", 
            coef(fit)[1] %>% round(2),
            " and a slope of ", coef(fit)[2] %>% round(2), ".")
    } else {
      str_c("To find the line of best fit, try visualizing what trend
            the points make on the graph. Do the points increase in y as 
            you increase x? If so, try a positive slope.")
    }
  })
})
