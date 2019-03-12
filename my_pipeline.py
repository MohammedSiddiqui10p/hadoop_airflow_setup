
from airflow import DAG
from airflow.operators.hive_operator import HiveOperator
from airflow.contrib.operators.sqoop_operator import SqoopOperator
from datetime import datetime, timedelta


default_args = {
    'owner': 'Talha',
    'start_date': datetime(2019, 3, 11)
}

dag = DAG('my_pipeline_v2', default_args=default_args, schedule_interval='@once')

sqoop = SqoopOperator(conn_id='docker_mysql',
                   task_id='sqoop_task',
                   query='"SELECT * FROM training.customer WHERE $CONDITIONS"',
                   target_dir='hdfs:///training/customer/data',
                   import_type='import',
                   dag=dag,
                   num_mappers=1)

hive_load = HiveOperator(
    hql='LOAD DATA INPATH \'hdfs:///training/customer/data\' OVERWRITE INTO TABLE training.customer',
    schema='training',
    task_id='hive_load',
    dag=dag)

hive_transformation = HiveOperator(
    hql='SELECT cust_city, AVG(PAYMENT_AMT) FROM training.customer GROUP BY cust_city',
    schema='training',
    task_id='hive_transformation',
    dag=dag)


sqoop >> hive_load >> hive_transformation
