NAME 	= Inception

DOCKER = docker
RUN = $(DOCKER) run
COMPOSE = $(DOCKER) compose

# ╔══════════════════════════════════════════════════════════════════════════╗ #  
#                               SOURCES                                        #
# ╚══════════════════════════════════════════════════════════════════════════╝ # 

MANDATORY_PATH = -f ./srcs/mandatory.yml
BONUS_PATH = -f ./srcs/bonus.yml
ELK_PATH = -f ./srcs/elk.yml
ENV_SAMPLE= ./srcs/.env.sample

# ╔══════════════════════════════════════════════════════════════════════════╗ #  
#                               COLORS                                         #
# ╚══════════════════════════════════════════════════════════════════════════╝ #  

RED=\033[0;31m
CYAN=\033[0;36m
GREEN=\033[0;32m
YELLOW=\033[0;33m
WHITE=\033[0;97m
BLUE=\033[0;34m
NC=\033[0m # No color

# ╔══════════════════════════════════════════════════════════════════════════╗ #  
#                               RULES                                          #
# ╚══════════════════════════════════════════════════════════════════════════╝ # 

up: 
	@$(COMPOSE) $(MANDATORY_PATH) $@ --build -d

bonus: 
	@$(COMPOSE) ${MANDATORY_PATH} $(BONUS_PATH) up --build -d

setup:
	mkdir -p /home/deordone/data/wordpress
	mkdir -p /home/deordone/data/mariadb
	cp ${ENV_SAMPLE} srcs/.env
	mkdir secrets

it:
	@$(DOCKER) exec -it $(ID) sh

clean: images
	@echo
	@$(COMPOSE) $(MANDATORY_PATH) down
	@$(COMPOSE) $(BONUS_PATH) down
	@$(COMPOSE) $(ELK_PATH) down
	@printf "$(RED)Removing images above$(NC)\n"
	@$(DOCKER) container prune -f && $(DOCKER) image prune -a -f
	@printf "$(GREEN) $@ COMPLETE! $(NC)\n"

fclean: clean images
	@echo
	@echo "Starting full clean"
	@$(DOCKER) system prune -a
	@echo
	@printf "$(GREEN)COMPLETE! $(NC)\n"

logs:
	@$(DOCKER) $@ $(ID)

ps:
	@$(DOCKER) $@ -a

images:
	@$(DOCKER) $@

re: fclean up

.PHONY: up bonus setup it clean down logs ps images re
