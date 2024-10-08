#!/bin/bash

service=$1
cmd=$2

# define the service name
MLFLOW="mlflow"
OLLAMA="ollama"
QDRANT="qdrant"
RESTART_SLEEP_REC=2

usage() {
    echo "run.sh <service> <command> [options]"
    echo "Available services: mlflow, ollama, qdrant"
    echo " all                   - all services"
    echo " $MLFLOW               - mlflow service"
    echo " $OLLAMA               - ollama service"
    echo " $QDRANT               - qdrant service"
    echo "Available commands: "
    echo " up                    - deploy service"
    echo " down                  - stop and remove containers, networks"       
    echo " restart               - down then up"
    echo "Available options:"
    echo " --build               - rebuild when up"
    echo " --volumes             - remove volumes when down"
}

get_docker_compose_file() {
    service=$1
    docker_compose_file="$service/docker-compose-$service.yml"
    echo $docker_compose_file
}

up() {
    service=$1
    shift
    docker_compose_file=$(get_docker_compose_file $service)
    # use docker-compose
    docker-compose -f "$docker_compose_file" up -d "$@"
}

down() {
    service=$1
    shift
    docker_compose_file=$(get_docker_compose_file $service)

    # using docker-compose
    docker-compose -f "$docker_compose_file" down "$@"
}

up_mlflow(){
    up "$MLFLOW" "$@"    
}

down_mlflow(){
    down "$MLFLOW" "$@"
}

up_ollama(){
    up "$OLLAMA" "$@"
}

down_ollama(){
    down "$OLLAMA" "$@"
}

up_qdrant(){
    up "$QDRANT" "$@"
}

down_qdrant(){
    down "$QDRANT" "$@"
}

up_all(){
    up_mlflow "$@"
    up_ollama "$@"
    up_qdrant "$@"
}

down_all(){
    down_mlflow "$@"
    down_ollama "$@"
    down_qdrant "$@"
}

if [[ -z "$cmd" ]]; then
    echo "Missing command"
    usage
    exit 1
fi

shift 2

case $cmd in
up) 
    case $service in
    all)
        up_all "$@"
        ;;
    $MLFLOW)
        up_mlflow "$@"
        ;;
    $OLLAMA)
        up_ollama "$@"
        ;;
    $QDRANT)
        up_qdrant "$@"
        ;;
    *) 
        echo "Unknown service"
        usage
        exit 1
        ;;
    esac
    ;;
down)
    case $service in
    all)
        down_all "$@"
        ;;
    $MLFLOW)
        down_mlflow "$@"
        ;;
    $OLLAMA)
        down_ollama "$@"
        ;;
    $QDRANT)
        down_qdrant "$@"
        ;;
    *) 
        echo "Unknown service"
        usage
        exit 1
        ;;
    esac
    ;;
restart)
    case $service in
    all)
        down_all "$@"
        sleep $RESTART_SLEEP_REC
        up_all "$@"
        ;;
    $MLFLOW)
        down_mlflow "$@"
        sleep $RESTART_SLEEP_REC
        up_mlflow "$@"
        ;;
    $OLLAMA)
        down_ollama "$@"
        sleep $RESTART_SLEEP_REC
        up_ollama "$@"
        ;;
    $QDRANT)
        down_qdrant "$@"
        sleep $RESTART_SLEEP_REC
        up_qdrant "$@"
        ;;
    *) 
        echo "Unknown service"
        usage
        exit 1
        ;;
    esac
    ;;
*)
    echo "Unknown command"
    usage
    exit 1
    ;;
esac