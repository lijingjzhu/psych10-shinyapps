# https://github.com/rocker-org/shiny
run:
	docker run --rm -p 3838:3838 -p 8787:8787 \
		-v /Users/poldrack/code/psych10-shinyapps/apps/:/srv/shiny-server/ \
		-v /Users/poldrack/code/psych10-shinyapps/logs/:/var/log/shiny-server/ \
		rocker/shiny
