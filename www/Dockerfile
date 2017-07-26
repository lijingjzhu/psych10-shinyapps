# set up openresty server to grab code and update upon every push
FROM php:7.1-apache

RUN apt-get update && apt-get install -y git vim-nox && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN a2enmod cgi
