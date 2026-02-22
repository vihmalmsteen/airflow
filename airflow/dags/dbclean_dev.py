from airflow import DAG
from airflow.providers.standard.operators.bash import BashOperator
from airflow.providers.standard.operators.python import PythonOperator
from datetime import datetime
import sqlalchemy
import os

# Tenta pegar a env, se não, usa o caminho relativo ao projeto (visto que a DAG está em migration/dags)
AIRFLOW_HOME = os.getenv("AIRFLOW_HOME") or os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
DB_PATH = os.path.join(AIRFLOW_HOME, "airflow.db?timeout=60")

SQL_ALCH_CONN = f"sqlite:///{DB_PATH}"

def execute_sqlite_vacuum():
    if os.path.exists(DB_PATH):
        engine = sqlalchemy.create_engine(SQL_ALCH_CONN)
        with engine.connect() as _conn:
            print(f"Iniciando VACUUM em: {DB_PATH}")
            _conn.execution_options(isolation_level="AUTOCOMMIT").execute(sqlalchemy.text("VACUUM;"))
            print("VACUUM concluído com sucesso!")
    else:
        print(f"Erro: Arquivo {DB_PATH} não encontrado.")

with DAG(
    dag_id="db_maintenance_dev",
    start_date=datetime(2025, 1, 1),
    schedule="@monthly",
    catchup=False,
    tags=["dev", "maintenance", "sqlite", "optimization"]
) as dag:
    # clean_db = BashOperator(
    #     task_id="db_clean",
    #     bash_command="uv run airflow db clean --clean-before-timestamp $(date -d '15 days ago' +%Y-%m-%d) --yes",
    #     env={**os.environ, "AIRFLOW_HOME": os.getenv("AIRFLOW_HOME")}
    # )

    optimize_db = PythonOperator(
        task_id="sqlite_vacuum",
        python_callable=execute_sqlite_vacuum
    )

    # clean_db >> optimize_db
    optimize_db