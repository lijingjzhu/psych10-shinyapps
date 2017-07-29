# set up openresty server to grab code and update upon every push
FROM rocker/shiny

RUN apt-get update && apt-get install -y libxml2-dev libssl-dev && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN echo "install.packages('tidyverse',lib='/usr/lib/R/library')" > install_tidyverse.R
RUN Rscript install_tidyverse.R

