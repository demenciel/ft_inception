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


nginx:
	@docker build srcs/requirements/nginx/ -t nginx

maria:
	@docker build srcs/requirements/mariadb/ -t mariadb

wordpress:
	@docker build srcs/requirements/wordpress/ -t wordpress

run:
	@cd ./srcs && docker-compose up -d

restart:
	@docker-compose down && docker-compose up -d

stop:
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


