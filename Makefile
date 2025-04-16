NAME 	= Inception

DOCKER = docker
RUN = $(DOCKER) run
COMPOSE = $(DOCKER) compose

# ╔══════════════════════════════════════════════════════════════════════════╗ #  
#                               SOURCES                                        #
# ╚══════════════════════════════════════════════════════════════════════════╝ # 

COMPOSE_PATH = -f ./srcs/docker-compose.yml

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
	@$(COMPOSE) $(COMPOSE_PATH) $@ --build --watch

it:
	@$(DOCKER) exec -it $(ID) sh	

clean:
	@$(COMPOSE) $(COMPOSE_PATH) down

fclean: clean images
	@echo
	@printf "$(RED)Removing images above$(NC)\n"
	@$(DOCKER) image prune -a
	@echo
	@printf "$(GREEN)COMPLETE! $(NC)\n"

logs:
	@$(COMPOSE) $(COMPOSE_PATH) $@

ps:
	@$(COMPOSE) $(COMPOSE_PATH) $@

images:
	@$(DOCKER) $@

.PHONY: all clean debug ps images
