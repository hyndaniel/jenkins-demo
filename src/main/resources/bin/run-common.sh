#!/bin/sh

RUN_OPE=$1
MAIN_CLASS="cn.percent.overseas.App"

FILE_NAME=`basename $0`
cd `dirname $0`
BIN_DIR=`pwd`
cd ..
DEPLOY_DIR=`pwd`
CONF_DIR=${DEPLOY_DIR}/conf
LIB_JARS=${DEPLOY_DIR}/lib/*

LOGS_DIR=${DEPLOY_DIR}/logs
if [[ ! -d ${LOGS_DIR} ]]; then
	mkdir ${LOGS_DIR}
fi

STDOUT_FILE=${LOGS_DIR}/stdout.log

start_service(){
  local SCRIPT_NAME="${BIN_DIR}/${FILE_NAME}"
  local SCRIPT_USER=`ls -lrt ${SCRIPT_NAME} |awk '{ print $3}'`
  local OPE_USER=`whoami`

  if [[ ${OPE_USER} == "root" ]] ; then
      echo "吓死了，您竟然用root来启动程序，程序已自杀!!!!";
      exit 1
  fi

  if [[ ${SCRIPT_USER} != "$OPE_USER" ]]; then
      echo "程序启动用户和脚本文件所有者不一致，请确定启动用户是否合法!!!!";
      exit 1
  fi

  # |grep "$CONF_DIR"
  local PIDS=`ps  --no-heading -C java -f --width 1000 | grep "$MAIN_CLASS" |awk '{print $2}'`

  if [[ -n "$PIDS" ]]; then
    echo "ERROR: The service already started!"
    echo "PID: $PIDS"
    exit 1
  fi

  # local PIDS=`ps  --no-heading -C java -f --width 1000 |grep "$CONF_DIR"| grep "$MAIN_CLASS" |awk '{print $2}'`
  local JAVA_OPTS=" -Xloggc:gc_memory_logs.log -XX:+PrintGCDetails -Xmx512m -Xms512m  -Xss256k -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 "

  echo "Starting the service ..."

  java ${JAVA_OPTS} -Ddruid.logType=slf4j -classpath ${CONF_DIR}:${LIB_JARS} ${MAIN_CLASS} 

  echo "OK!"
  PIDS=`ps  --no-heading -C java -f --width 1000 | grep "$DEPLOY_DIR" | awk '{print $2}'`
  echo "PID: $PIDS"
}

stop_service(){
  local PIDS=`ps  --no-heading -C java -f --width 1000 | grep "$MAIN_CLASS" |awk '{print $2}'`

  if [ -z "$PIDS" ]; then
    echo "Warning: The service does not started!"
    exit 1
  fi

  echo -e "Stopping the service ...\c"
  for PID in ${PIDS} ; do
	  kill ${PID} > /dev/null 2>&1
  done

  COUNT=0
  TOTAL=0
  while [ ${COUNT} -lt 1 ]; do
    echo -e ".\c"
    sleep 1
    COUNT=1
    let TOTAL+=1
    for PID in $PIDS ; do
		  PID_EXIST=`ps --no-heading -p $PID`
		  if [ -n "$PID_EXIST" ]; then
			  COUNT=0
			  break
		  fi
		  if [ ${COUNT} -gt 30 ]; then
			  for PID in ${PIDS} ; do
				  kill -9 ${PID} > /dev/null 2>&1
			  done
			  COUNT=0
			  break
		  fi
	  done
  done
  echo "OK!"
  echo "PID: $PIDS"
}

case ${RUN_OPE} in
  start )
    start_service
    ;;
  START )
    start_service
    ;;

  stop )
    stop_service
    ;;
  STOP )
    stop_service
    ;;

  * )
    echo "Unknown operation:${RUN_OPE}"
    exit 1
    ;;
esac


