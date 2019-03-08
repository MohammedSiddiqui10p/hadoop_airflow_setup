#!/usr/bin/env bash

current_dir=$(pwd)
zone_cluster_file_name="/zoneCluster.sh"
zone_cluster_path=$current_dir$zone_cluster_file_name

dockerHadoopAirflowBuild() {
    docker build . -t hadoop_airflow_cluster
}

executeZoneCluster() {
    if [[ $@ ]]; then
        bash $zone_cluster_path $@ || echo "Please run install first" && exit 1;
    else
        bash $zone_cluster_path || echo "Please run install first" && exit 1;
    fi
}

setup() {
#    dockerHadoopAirflowBuild
    executeZoneCluster
    docker-compose build
}

install() {
    curl -L https://raw.githubusercontent.com/luvres/hadoop/master/zoneCluster.sh -o "$zone_cluster_path"
    chmod +x $zone_cluster_path
}

if [ "$1" == "install" ]; then
    install
elif [ "$1" == "setup" ]; then
    setup
elif [ "$1" == "start" ]; then
    executeZoneCluster start
    docker-compose up -d
elif [ "$1" == "stop" ]; then
     docker-compose down
     executeZoneCluster stop
elif [ "$1" == "destroy" ]; then
     executeZoneCluster Stop
elif [ "$1" == "restart" ]; then
   docker-compose restart
   executeZoneCluster restart
else
    echo "invalid run command"
fi