# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: acouture <acouture@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/15 15:32:49 by acouture          #+#    #+#              #
#    Updated: 2024/01/15 18:30:36 by acouture         ###   ########.fr        #
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

run: nginx maria
	@printf "${GREEN}Starting nginx${NC}"
	@if [ "$$(docker ps -a -q)" ]; then docker rm -f $$(docker ps -a -q); fi
	@nginx_id=$$(docker run -d nginx); \
	printf "Nginx Container ID: $$nginx_id"; \
	printf "${GREEN}Starting mariadb${NC}"
	@mariadb_id=$$(docker run -d -e MARIADB_ROOT_PASSWORD="rootroot" -e SQL_USER="mysql" -e SQL_PASSWORD="password" -e SQL_DATABASE=inception mariadb); \
	printf "Mariadb Container ID: $$mariadb_id"; \
	printf MariaDB is started; \
	sleep 10; \

stop:
	@printf "${RED}Stopping nginx${NC}"
	@docker stop $$(docker ps -a -q); \
	printf "${RED}Removing nginx${NC}"
	@docker rm $$(docker ps -a -q); \
	printf "${RED}Removing nginx image${NC}"
	@docker rmi $$(docker images -q); \


