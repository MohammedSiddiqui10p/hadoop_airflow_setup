FROM izone/hadoop:cluster

RUN apt-get update \
  && apt-get install -y ssh libssl-dev gcc g++ libmysqlclient-dev \
  && pip install --upgrade pip

ENV AIRFLOW_HOME=/root/airflow
ENV NOTEBOOKS_HOME=/root/notebooks

RUN mkdir -p ${NOTEBOOKS_HOME}/dags
RUN mkdir -p ${AIRFLOW_HOME}/dags

RUN ln -sf ${NOTEBOOKS_HOME}/dags ${AIRFLOW_HOME}/dags

WORKDIR /root

COPY requirements.txt ./

RUN pip install -r requirements.txt

# Apparently this doesn't get installed correctly :/
RUN pip install apache-airflow[hive]==1.9.0

RUN airflow initdb

EXPOSE 9001