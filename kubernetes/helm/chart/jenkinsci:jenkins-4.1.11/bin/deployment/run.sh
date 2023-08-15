#! /bin/bash

#======================================================================
# 1、打包
# 2、构建镜像
#
# example: 'sh run.sh [<local>|<dev>|<test>|<prod>]'
#
# local - 本地（默认）
# dev   - 开发
# test  - 测试
# prod  - 生产
#
# author: chenlong
# date: 2020-08-10
#======================================================================

# ----------------------- params <---------------------------
# 仓库名
DOCKER_REPOSITORY_NAME=$1
# 镜像名
DOCKER_IMAGE_NAME=$2
# tag
DOCKER_IMAGE_TAG=$3
# 容器名
DOCKER_CONTAINER_NAME=$4
# 端口号
APPLICATION_PORT=$5
# 环境标志
PROFILE=$6
if [ -z "$PROFILE" ]; then
    PROFILE=local
fi
# ----------------------- params >---------------------------

# run
function run() {
  str="Run"
  echo "${str}."
  mkdir -p /data/containers/${DOCKER_CONTAINER_NAME}-${PROFILE}/logs
  mkdir -p /data/containers/${DOCKER_CONTAINER_NAME}-${PROFILE}/dump
  mkdir -p /data/containers/${DOCKER_CONTAINER_NAME}-${PROFILE}/gc
  docker run -d -it \
    -p ${APPLICATION_PORT}:${APPLICATION_PORT} \
    -v /data/containers/${DOCKER_CONTAINER_NAME}-${PROFILE}/logs:/app/logs \
    -v /data/containers/${DOCKER_CONTAINER_NAME}-${PROFILE}/dump:/app/dump \
    -v /data/containers/${DOCKER_CONTAINER_NAME}-${PROFILE}/gc:/app/gc \
    --memory 2048m \
    --name ${DOCKER_CONTAINER_NAME}-${PROFILE} \
    ${DOCKER_REPOSITORY_NAME}/${DOCKER_IMAGE_NAME}-${PROFILE}:${DOCKER_IMAGE_TAG}
  if [[ $? -eq 0 ]]
  then
    echo "${str} Success."
  else
    echo "${str} Failure."
    exit 1
  fi
}

run
