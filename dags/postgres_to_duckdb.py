import duckdb
import pandas as pd
from sqlalchemy import create_engine
from airflow import DAG
from datetime import datetime
from airflow.operators.python import PythonOperator

POSTGRES_CONN = "postgresql+psycopg2://source_user:source_pass@postgres_source:5432/source_db"
DUCKDB_PATH = "/opt/airflow/duckdb/warehouse.duckdb"

def inicio():
    print("Iniciando o processo.")

def coleta_postgres():
    print("Coletando dados no Postgres.")
    engine = create_engine(POSTGRES_CONN)
    try:
        with engine.connect() as conn:
            df = pd.read_sql("SELECT * FROM ecommerce", conn)

        df.to_parquet("/opt/airflow/tmp/ecommerce.parquet", index=False)

    finally:
        engine.dispose()


def grava_duckdb():
    print("Gravando dados no DuckDB.")

    df = pd.read_parquet("/opt/airflow/tmp/ecommerce.parquet")

    conn_duckdb = duckdb.connect(DUCKDB_PATH)

    try:
        conn_duckdb.execute("CREATE SCHEMA IF NOT EXISTS bronze")

        conn_duckdb.register("ecommerce", df)

        conn_duckdb.execute("""
            CREATE OR REPLACE TABLE bronze.ecommerce AS
            SELECT *
            FROM ecommerce
        """)

    finally:
        conn_duckdb.close()

def fim():
    print("Processo finalizado com sucesso!")

with DAG(
    dag_id='downloado_drive_csv',
    start_date=datetime(2026, 4, 29),
    schedule_interval='0 * * * *',  # Executa de hora em hora
) as dag:

    inicio_processo = PythonOperator(
        task_id='inicio_processo',
        python_callable=inicio,
    )

    coleta_dados = PythonOperator(
        task_id='coleta_dados',
        python_callable=coleta_postgres,
    )

    processa_dados = PythonOperator(
        task_id='processa_dados',
        python_callable=grava_duckdb,
    )

    fim_processo = PythonOperator(
        task_id='fim_processo',
        python_callable=fim,
    )

    # Encadeando as tarefas na ordem desejada
    inicio_processo >> coleta_dados >> processa_dados >> fim_processo
