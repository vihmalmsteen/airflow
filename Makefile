AIRFLOW_HOME=$(shell pwd)

imprimir:
	@echo $(AIRFLOW_HOME)

migrate:
	AIRFLOW_HOME="$(AIRFLOW_HOME)/migrations" uv run airflow db migrate

start:
	AIRFLOW_HOME="$(AIRFLOW_HOME)/migrations" uv run airflow standalone
