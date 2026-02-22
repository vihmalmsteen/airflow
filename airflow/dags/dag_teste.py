from airflow import DAG
from airflow.providers.standard.operators.bash import BashOperator
from datetime import datetime

with DAG(
    dag_id='dag_teste',
    start_date=datetime(2026, 2, 16),
    # Mude de schedule_interval para schedule
    schedule='@daily',
    catchup=False,
) as dag:
    task1 = BashOperator(
        task_id='task1',
        bash_command='echo "Oi. Esta é a 1ª task da 1ª dag."',
    )

    task2 = BashOperator(
        task_id='task2',
        bash_command='echo "Esta é a 2ª task da 1ª dag."',
    )

    task1 >> task2
