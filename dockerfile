FROM apache/airflow:3.0.0

USER airflow

RUN pip install --no-cache-dir \
    duckdb \
    dbt-core \
    dbt-duckdb \
    pandas \
    sqlalchemy \
    psycopg2-binary \
    openpyxl \
    pyarrow