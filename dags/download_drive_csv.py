from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import gdown
import requests
import pandas as pd
from sqlalchemy import create_engine

FILE_ID = "1GXdnjst6mzpkgIkMxOQdy1-Qt0xAw5f4"
OUTPUT_PATH = "/opt/airflow/data/arquivo_drive.csv"
CONN = "postgresql+psycopg2://source_user:source_pass@postgres_source:5432/source_db"

def inicio():
    print("Iniciando o processo.")

def coleta():
    url = f"https://drive.google.com/uc?id={FILE_ID}"
    print("Coletando dados.")

    response = requests.get(url)
    response.raise_for_status()

    with open(OUTPUT_PATH, "wb") as file:
        file.write(response.content)
    print(f"Arquivo salvo em: {OUTPUT_PATH}")

def grava():

    engine = create_engine(CONN)

    df = pd.read_csv(OUTPUT_PATH)

    df.to_sql(
        name="ecommerce",
        con=engine,
        schema="public",
        if_exists="replace",
        index=True
    )
    print("Gravando dados.")


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
        python_callable=coleta,
    )

    processa_dados = PythonOperator(
        task_id='processa_dados',
        python_callable=grava,
    )

    fim_processo = PythonOperator(
        task_id='fim_processo',
        python_callable=fim,
    )

    # Encadeando as tarefas na ordem desejada
    inicio_processo >> coleta_dados >> processa_dados >> fim_processo