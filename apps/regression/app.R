#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(psych)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Regression Towards the Mean"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        p("Regression towards the mean is the phenomenon that if we have a
          multiple measurements on a single observational unit, an extreme
          measurement on the first reading will suggest that the second 
          reading will tend to be closer to the average. 
          To illustrate regression towards the mean, we will use Francis 
          Galton's data sets on the relationship between parent pea stalk
          height and child pea stalk height."),
        
         selectInput(inputId = "quant",
                     label = "Quantile of Parent Data to Sample",
                     choices = c("Lower 10%" = 0.10,
                                 "Lower 30%" = 0.30,
                                 "Upper 10%" = 0.90,
                                 "Upper 30%" = 0.70)),
         checkboxInput(inputId = "parentsampmean",
                       label = "Show Sample Mean of Parent Height",
                       value = FALSE),
         checkboxInput(inputId = "childsampmean",
                       label = "Show Sample Mean of Child Height",
                       value = FALSE),
        h4("Questions"),
        p("1. Can you observe the phenomenon regression towards the mean if 
          the two variables are perfectly correlated?"),
        p("2. Can you observe the phenomenon if the two variables were not
          correlated at all?"),
        p("3. Given the height of the parent pea is 70 inches, can you 
          tell what height the child pea is?")
        ),
      
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("parentPlot"),
         plotOutput("childPlot")
      )
   )
)

server <- function(input, output) {
  
   output$parentPlot <- renderPlot({
     upper_bound <- quantile(galton$parent, input$quant %>% as.numeric())
     dheight <- approxfun(density(galton$parent))
     
     if (input$quant > 0.5) {
       set.seed(34)
       pinpoints <- galton %>% 
         as_tibble() %>% 
         filter(parent > upper_bound) %>% 
         sample_n(5, replace = FALSE) %>% 
         mutate(xnew = parent,
                ynew = dheight(parent))
     } 
     
     if (input$quant < 0.5) {
       set.seed(34)
       pinpoints <- galton %>% 
         as_tibble() %>% 
         filter(parent < upper_bound) %>% 
         sample_n(5, replace = FALSE) %>% 
         mutate(xnew = parent,
                ynew = dheight(parent))
     }
     
     curr_plot <- galton %>% 
       as_tibble() %>% 
       ggplot() +
       geom_density(mapping = aes(x = parent)) +
       geom_jitter(data = pinpoints, 
                  mapping = aes(x = xnew, y = ynew), 
                  color = "red", size = 3) +
       geom_vline(mapping = aes(xintercept = mean(galton$parent)),
                  size = 1) +
       theme_bw() +
       labs(x = "Height of Parent (in)", y = "Density", 
            size = NULL)
     
     if (input$parentsampmean == TRUE) {
       curr_plot +
         geom_vline(mapping = aes(xintercept = mean(pinpoints$xnew)), 
                    color = "blue", size = 1) 
     } else {
       curr_plot
     }
   })
   
   output$childPlot <- renderPlot({
     upper_bound <- quantile(galton$parent, input$quant %>% as.numeric())
     dheight <- approxfun(density(galton$child))
     
     if (input$quant > 0.5) {
       set.seed(34)
       pinpoints <- galton %>% 
         as_tibble() %>% 
         filter(parent > upper_bound) %>% 
         sample_n(5, replace = FALSE) %>% 
         mutate(xnew = child,
                ynew = dheight(child))
     }
     if (input$quant < 0.5) {
       set.seed(34)
       pinpoints <- galton %>% 
         as_tibble() %>% 
         filter(parent < upper_bound) %>% 
         sample_n(5, replace = FALSE) %>% 
         mutate(xnew = child,
                ynew = dheight(child))
     }
     
     child_plot <- galton %>% 
       as_tibble() %>% 
       ggplot() +
       geom_density(mapping = aes(x = child)) +
       geom_jitter(data = pinpoints, 
                  mapping = aes(x = xnew, y = ynew), 
                  color = "red",
                  size = 3) +
       geom_vline(mapping = aes(xintercept = mean(galton$child)), 
                  size = 1) +
       theme_bw() +
       labs(x = "Height of Child (in)", y = "Density", 
            size = NULL)
     
     if (input$childsampmean == TRUE) {
       child_plot +
         geom_vline(mapping = aes(xintercept = mean(pinpoints$xnew)), 
                    color = "blue", size = 1)
     } else {
       child_plot
     }
   }) 
}

shinyApp(ui = ui, server = server)

