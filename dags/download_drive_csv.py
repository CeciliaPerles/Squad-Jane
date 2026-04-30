from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import gdown

FILE_ID = "1GXdnjst6mzpkgIkMxOQdy1-Qt0xAw5f4"
OUTPUT_PATH = "/opt/airflow/data/arquivo_drive.csv"

def inicio():
    print("Iniciando o processo.")

def coleta():
    print("Coletando dados.")
    url = f"https://drive.google.com/uc?id={FILE_ID}"
    gdown.download(url, OUTPUT_PATH, quiet=False)

def processamento():
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
        python_callable=processamento,
    )

    fim_processo = PythonOperator(
        task_id='fim_processo',
        python_callable=fim,
    )

    # Encadeando as tarefas na ordem desejada
    inicio_processo >> coleta_dados >> fim_processo