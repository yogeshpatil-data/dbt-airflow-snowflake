from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

default_args = {
    "owner": "airflow"
}

with DAG(
    dag_id="dbt_pipeline",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@daily",
    catchup=False,
    description="Daily dbt run + test pipeline",
) as dag:

    # PATH where dbt project is mounted in the Airflow container
    DBT_PROJECT_DIR = "/opt/airflow/dbt"

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run --no-write-json",
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt test --no-write-json",
    )

    dbt_run >> dbt_test
