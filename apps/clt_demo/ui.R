#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Central Limit Theorem"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      p("The goal of this visualization is to help students understand the 
        Central Limit Theorem. The Central Limit Theorem states that
        when independent random variables are averaged, the distribution of
        sample averages tends to a normal distribution. We this happen
        even if the the original variables are not normally distributed. This
        allows us to make inferences about the center of a distribution
        with only information from the sampling distribution and without 
        information of the true distribution."),
      
       selectInput("distribution", "Population Distribution:",
                   choices = c("Uniform Distribution" = "uniform", 
                               "Normal Distribution" = "normal",
                               "Weibull Distribution" = "weibull",
                               "T-Distribution, 1 DF" = "tdist")),
       sliderInput("n",
                   "Sample Size",
                   min = 10,
                   max = 2500,
                   step = 50,
                   value = 500,
                   dragRange = FALSE),
      checkboxInput("pop_mean", "Population Mean Overlay", FALSE),
      checkboxInput("overlay", "Normal Overlay on Sampling Distribution", 
                    FALSE),
      checkboxInput("samp_mean", "Sampling Mean", FALSE),
      
      h4("Questions"),
      p("1. What happens to the sampling distribution mean as we increase
        the sample size?"),
      p("2. Can you infer anything about the variance of the population
        distribution given the distribution of sampling averages?"),
      p("3. True or False: All sampling distributions converge to a 
        standard normal distribution with a mean of 0 and a standard
        deviation of 1.")
    ),
    
    mainPanel(
      plotOutput("mainPlot"),
       plotOutput("distPlot")
    )
  )
))
