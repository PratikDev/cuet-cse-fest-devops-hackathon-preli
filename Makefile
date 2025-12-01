# Variables
PROJECT_NAME ?= devops-hackathon
ENV_FILE ?= .env
MODE ?= dev

# Determine Compose File based on Mode
ifeq ($(MODE), prod)
    COMPOSE_FILE := docker/compose.production.yaml
else
    COMPOSE_FILE := docker/compose.development.yaml
endif

# Docker Compose Command (Requested by User)
DOCKER_COMPOSE := docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) -p $(PROJECT_NAME)-$(MODE)

# Default Target
.PHONY: help
help:
	@echo "Usage: make [target] [MODE=dev|prod]"
	@echo ""
	@echo "Docker Services:"
	@echo "  up              Start services"
	@echo "  down            Stop services"
	@echo "  build           Build services"
	@echo "  logs            View logs (use SERVICE=name to filter)"
	@echo "  restart         Restart services"
	@echo "  ps              List containers"
	@echo "  shell           Open shell in a container (default: backend, use SERVICE=name)"
	@echo ""
	@echo "Development Aliases:"
	@echo "  dev-up          Start dev environment"
	@echo "  dev-down        Stop dev environment"
	@echo "  dev-build       Build dev environment"
	@echo "  dev-logs        View dev logs"
	@echo ""
	@echo "Production Aliases:"
	@echo "  prod-up         Start prod environment"
	@echo "  prod-down       Stop prod environment"
	@echo "  prod-build      Build prod environment"
	@echo "  prod-logs       View prod logs"
	@echo ""
	@echo "Backend (Local):"
	@echo "  backend-install Install dependencies"
	@echo "  backend-dev     Run local dev server"
	@echo "  backend-build   Build project"
	@echo "  backend-check   Type check"
	@echo ""
	@echo "Database:"
	@echo "  db-reset        Reset database (removes volumes)"
	@echo ""
	@echo "Cleanup:"
	@echo "  clean           Stop and remove containers/networks"
	@echo "  clean-volumes   Remove volumes"
	@echo "  clean-all       Remove everything (containers, networks, volumes, images)"

# Docker Services
.PHONY: up down build logs restart ps shell

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

build:
	$(DOCKER_COMPOSE) build

logs:
	$(DOCKER_COMPOSE) logs -f $(SERVICE)

restart:
	$(DOCKER_COMPOSE) restart $(SERVICE)

ps:
	$(DOCKER_COMPOSE) ps

shell:
	$(DOCKER_COMPOSE) exec $(or $(SERVICE),backend) sh

# Development Aliases
.PHONY: dev-up dev-down dev-build dev-logs dev-shell

dev-up:
	$(MAKE) up MODE=dev

dev-down:
	$(MAKE) down MODE=dev

dev-build:
	$(MAKE) build MODE=dev

dev-logs:
	$(MAKE) logs MODE=dev

dev-shell:
	$(MAKE) shell MODE=dev

# Production Aliases
.PHONY: prod-up prod-down prod-build prod-logs prod-shell

prod-up:
	$(MAKE) up MODE=prod

prod-down:
	$(MAKE) down MODE=prod

prod-build:
	$(MAKE) build MODE=prod

prod-logs:
	$(MAKE) logs MODE=prod

prod-shell:
	$(MAKE) shell MODE=prod

# Backend (Local)
.PHONY: backend-install backend-dev backend-build backend-check

backend-install:
	cd backend && bun install

backend-dev:
	cd backend && bun run dev

backend-build:
	cd backend && bun run build

backend-check:
	cd backend && bun run type-check

# Database
.PHONY: db-reset

db-reset:
	$(DOCKER_COMPOSE) down -v

# Cleanup
.PHONY: clean clean-volumes clean-all

clean:
	$(DOCKER_COMPOSE) down --remove-orphans

clean-volumes:
	$(DOCKER_COMPOSE) down -v

clean-all:
	$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans
