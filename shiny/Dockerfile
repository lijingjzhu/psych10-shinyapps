# set up openresty server to grab code and update upon every push
FROM rocker/shiny

RUN apt-get update && apt-get install -y openssl && apt-get clean && rm -rf /var/lib/apt/lists/*
