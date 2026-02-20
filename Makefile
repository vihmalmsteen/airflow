AIRFLOW_HOME=$(shell pwd)/migrations

print:
	@echo $(shell pwd)

migrate:
	AIRFLOW_HOME="$(AIRFLOW_HOME)" uv run airflow db migrate

start:
	AIRFLOW_HOME="$(AIRFLOW_HOME)" uv run airflow standalone
