export PROJECT_DIR := $(shell pwd)
export AIRFLOW_HOME := $(shell pwd)/migration
export WIN_IP := $(shell ip route | grep default | awk '{print $$3}')

# check path e windows ip
print:
	@echo "\n======================================================================"
	@echo "Diretório atual: $(shell pwd)"
	@echo "Diretório do projeto: $(PROJECT_DIR)"
	@echo "Home do airflow no projeto: $(AIRFLOW_HOME)"
	@echo "Windows IP: $(WIN_IP)"
	@echo "\nConectar a dbs no windows: host.docker.internal:XXXX ou $(WIN_IP):XXXX"
	@echo "======================================================================\n"

# instala dependências do remoto
dev-setup-sudo:
	sudo apt update && \
	sudo apt upgrade -y && \
	sudo apt install -y \
		pkg-config \
		default-libmysqlclient-dev \
		build-essential && \
	curl -LsSf https://astral.sh/uv/install.sh | sh && \
	sudo chmod -R 766 "$(PROJECT_DIR)/database"

# instala dependências do projeto
dev-setup-uv:
	uv sync && \
	uv add \
		apache-airflow-providers-mysql \
		apache-airflow-providers-postgres \
		apache-airflow-providers-sqlite && \
	uv run airflow db migrate

# adiciona conexão com o banco sqlite
dev-add-conn-sqlite:
	uv run airflow connections add 'sqlite_local' \
		--conn-type 'sqlite' \
		--conn-host "$(PROJECT_DIR)/database/database.db" \
		--conn-description 'Conexão com o banco sqlite de teste.' && \
	uv run airflow connections list

# * inicia o airflow em standalone
dev-start:
	AIRFLOW_CONN_MYSQL_DEFAULT="mysql://user:pass@${WIN_IP}:3306/db"
	AIRFLOW_HOME="$(AIRFLOW_HOME)" uv run airflow standalone
