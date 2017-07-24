# https://github.com/rocker-org/shiny
run:
	docker run --rm -p 3838:3838 \
		-v /Users/poldrack/code/psych10-shinyapps/apps/:/srv/shiny-server/ \
		-v /Users/poldrack/code/psych10-shinyapps/logs/:/var/log/shiny-server/ \
		rocker/shiny
run-prod:
	docker run --rm -d -p 80:3838 \
		-v /Users/poldrack/code/psych10-shinyapps/apps/:/srv/shiny-server/ \
		-v /Users/poldrack/code/psych10-shinyapps/logs/:/var/log/shiny-server/ \
		rocker/shiny
