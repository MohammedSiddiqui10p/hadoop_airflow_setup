FROM izone/hadoop:cluster

RUN apt-get update \
  && apt-get install -y ssh libssl-dev gcc g++ libmysqlclient-dev mysql-client \
  && pip install --upgrade pipp


ENV AIRFLOW_HOME=/root/airflow
ENV NOTEBOOKS_HOME=/root/notebooks

RUN mkdir -p ${NOTEBOOKS_HOME}/dags
RUN mkdir -p ${AIRFLOW_HOME}/dags

RUN ln -sf ${NOTEBOOKS_HOME}/dags ${AIRFLOW_HOME}/dags

WORKDIR /root

COPY requirements.txt ./
COPY sample_db.sql /root
COPY Lab1.txt ${NOTEBOOKS_HOME}
COPY Lab2.txt ${NOTEBOOKS_HOME}
COPY my_pipeline.py ${NOTEBOOKS_HOME}
COPY sample_file.txt ${NOTEBOOKS_HOME}
COPY hive-site.xml /opt/hive/conf
COPY mysql-connector-java-commercial-5.1.7-bin.jar /opt/hive/lib

RUN pip install -r requirements.txt

# Apparently this doesn't get installed correctly :/
RUN pip install apache-airflow[hive]==1.9.0

RUN airflow initdb

EXPOSE 9001