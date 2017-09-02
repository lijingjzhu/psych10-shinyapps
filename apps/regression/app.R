library(shiny)
library(tidyverse)
library(psych)

ui <- fluidPage(
   
   # Application title
   titlePanel("Regression Towards the Mean"),
   
   # Sidebar with text and the customizable inputs
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
      
      # Show central tendency plots
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
     
     # Logic regarding the threshold input
     # If it is an upper quantile, we need to use a different filter operation
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
     
     # Base plot
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
     
     # Adding in the mean depending on user input
     if (input$parentsampmean == TRUE) {
       curr_plot +
         geom_vline(mapping = aes(xintercept = mean(pinpoints$xnew)), 
                    color = "blue", size = 1) 
     } else {
       curr_plot
     }
   })
   
   # Plotting the child plot to show the movement towards the mean
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

