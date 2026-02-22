from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator

with DAG(
    dag_id='dag_teste_2',
    description='DAG de teste fazendo etl no sqlite database.sql',
    tags=["teste", "etl", "sqlite"],
    catchup=False,
) as dag:

    DATABASE_URL = 'sqlite:///home/vitor/Área de trabalho/airflow/database/database.sql'

    task_1 = SQLExecuteQueryOperator(
        task_id='task_1',
        sql='select * from users;',
        conn_id='sqlite_default'
    )
