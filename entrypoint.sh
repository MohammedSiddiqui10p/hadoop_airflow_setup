#!/bin/bash

echo "Starting airflow scheduler"
airflow scheduler -D

echo "Starting airflow web server"
airflow webserver -p 9001
