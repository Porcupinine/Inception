# build using docker-compose.yml

all: create build

create:
	@cp /home/lpraca-l/Documents/.env ./srcs
	@mkdir -p /home/lpraca-l/data/wp
	@mkdir -p /home/lpraca-l/data/maria
	@mkdir -p /home/lpraca-l/data/nginx

run:
	@docker compose -f ./srcs/docker-compose.yml up --detach

up:
	@docker compose -f ./srcs/docker-compose.yml up

build:
	@docker compose -f srcs/docker-compose.yml build

down:
	@docker compose -f srcs/docker-compose.yml down --remove-orphans 

stop:
	@docker compose -f srcs/docker-compose.yml stop

start:
	@docker compose -f srcs/docker-compose.yml start

clean:
	@rm -rf /home/lpraca/data/wp
	@rm -rf /home/lpraca/data/maria
	@rm -rf /home/lpraca/data/nginx

prune: clean
	@docker system prune -af
