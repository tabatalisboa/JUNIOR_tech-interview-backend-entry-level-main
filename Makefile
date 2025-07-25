# Makefile for Dockerized Rails App

up:
	sudo docker compose up --build

down:
	sudo docker compose down

test:
	sudo docker compose run --rm test

bash:
	sudo docker compose exec web bash

dbsetup:
	sudo docker compose exec web bin/rails db:setup
	sudo docker compose exec web bin/rails db:environment:set RAILS_ENV=test
	sudo docker compose exec web bin/rails db:drop db:create db:schema:load RAILS_ENV=test

seed:
	sudo docker compose exec web bin/rails db:seed

logs:
	sudo docker compose logs -f

restart:
	sudo docker compose down && sudo docker compose up --build
