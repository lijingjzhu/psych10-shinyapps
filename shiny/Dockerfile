# set up openresty server to grab code and update upon every push
FROM rocker/shiny

RUN apt-get update && apt-get install -y libssl-dev && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget https://cran.r-project.org/src/contrib/tidyverse_1.1.1.tar.gz
RUN R CMD INSTALL tidyverse_1.1.1.tar.gz
