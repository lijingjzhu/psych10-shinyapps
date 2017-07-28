# set up openresty server to grab code and update upon every push
FROM rocker/shiny

RUN apt-get update && apt-get install -y libssl-dev && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN echo "install.packages('tidyverse')" > install_tidyverse.R
RUN Rscript install_tidyverse.R

