NAME 	= Inception

DOCKER = docker
RUN = $(DOCKER) run
COMPOSE = $(DOCKER) compose

# ╔══════════════════════════════════════════════════════════════════════════╗ #  
#                               SOURCES                                        #
# ╚══════════════════════════════════════════════════════════════════════════╝ # 

COMPOSE_PATH = -f ./srcs/docker-compose-bonus.yml
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

all: up
	
up:
	@$(COMPOSE) $(COMPOSE_PATH) $@ --build -d

setup:
	cp ${ENV_SAMPLE} srcs/.env
	mkdir secrets

it:
	@$(DOCKER) exec -it $(ID) sh

clean:
	@$(COMPOSE) $(COMPOSE_PATH) down

fclean: clean images
	@echo
	@printf "$(RED)Removing images above$(NC)\n"
	@$(DOCKER) container prune -f && $(DOCKER) image prune -a -f
	@echo
	@printf "$(GREEN)COMPLETE! $(NC)\n"

logs:
	@$(COMPOSE) $(COMPOSE_PATH) $@

ps:
	@$(COMPOSE) $(COMPOSE_PATH) $@ -a

images:
	@$(DOCKER) $@

.PHONY: all up setup it clean fclean logs ps images
