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

run: check_docker
	@cd ./srcs && docker-compose up -d

restart: check_docker
	@cd ./srcs && docker-compose down && docker-compose up -d

stop: check_docker
	printf "${RED}Stopping all containers${NC}\n"
	@docker stop $$(docker ps -a -q); \

rm-containers: stop
	printf "${RED}Removing containers${NC}\n"
	@docker rm $$(docker ps -a -q); \

rm-images: stop
	printf "${RED}Removing images${NC}\n"
	@docker rmi $$(docker images -q); \

rm-volumes: stop
	printf "${RED}Removing volumes${NC}\n"
	@docker volume rm $$(docker volume ls -q); \

rm-all: rm-containers rm-images rm-volumes


