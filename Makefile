# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: acouture <acouture@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/15 15:32:49 by acouture          #+#    #+#              #
#    Updated: 2024/01/18 16:50:53 by acouture         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#COLORS
GREEN = \033[0;32m
RED = \033[0;31m
NC = \033[0m

check_docker:
	@if ! docker info > /dev/null 2>&1; then \
        echo "Docker is not running. Please start Docker."; \
        exit 1; \
	fi

nginx: check_docker
	@docker build srcs/requirements/nginx/ -t nginx

maria: check_docker
	@if docker container ls -a | grep mariadb; then \
        docker container rm -f mariadb; \
    fi
	@docker build srcs/requirements/mariadb/ -t mariadb

wordpress: check_docker
	@docker build srcs/requirements/wordpress/ -t wordpress

up: check_docker
	@cd ./srcs && docker-compose up -d 

down: check_docker
	@cd ./srcs && docker-compose down

reup: down up

restart: check_docker
	@cd ./srcs && docker-compose down && docker-compose up -d

shell-%:
	@docker exec -it $* sh

stop: check_docker
	printf "${RED}Stopping all containers${NC}\n"
	@docker stop $$(docker ps -a -q); \

logs: ## Shows logs lively in the container
	@cd srcs && docker-compose logs --follow --tail 100

logs-%: check_docker_status ## Shows logs lively for the selected container
	@cd srcs && while true; do docker-compose logs --tail 100 --follow $*; sleep 1; done

nginx-error-logs:
	@cd srcs && docker-compose exec nginx tail -f /var/log/nginx/error.log

rm-wordpress:
	printf "${RED}Removing wordpress container${NC}\n"
	@docker rm $$(docker ps -a -q --filter "name=wordpress");
	@docker rmi $$(docker images -q --filter "reference=wordpress");

rm-containers: stop
	printf "${RED}Removing containers${NC}\n"
	@docker rm $$(docker ps -a -q); \

rm-images: 
	printf "${RED}Removing images${NC}\n"
	@docker rmi $$(docker images -q); \

rm-volumes: 
	printf "${RED}Removing volumes${NC}\n"
	@docker volume rm $$(docker volume ls -q); \

rm-all: rm-containers rm-images rm-volumes


