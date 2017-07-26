all: makevol run-apache setup run-shiny
kill-all: kill-apache kill-shiny
setup:
	docker cp setup.sh my-running-app:/var/www/html/app/
	docker cp /Users/poldrack/code/psych10-shinyapps my-running-app:/var/www/html/app/
	docker exec my-running-app /bin/bash /var/www/html/app/setup.sh
prune:
	docker system prune
build-apache:
	docker build -t my-apache2 .
run-apache:
	docker run -dit -p 3800:80 -v DataVolume1:/var/www/html/app  --name my-running-app my-apache2
shell-apache:
	docker exec -i -t my-running-app /bin/bash
kill-apache:
	docker kill my-running-app
	docker rm my-running-app
makevol:
	docker volume create --name DataVolume1
rmvol:
	docker volume rm DataVolume1
run-shiny:
	docker run -dit --rm -p 3838:3838 \
	--name shiny -v DataVolume1:/srv/shiny-server/app \
	rocker/shiny
shell-shiny:
	docker exec -i -t shiny /bin/bash
kill-shiny:
	docker kill shiny
	docker rm shiny

