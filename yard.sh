#!/bin/sh

PROCESS='ruby */yard server'
PID=`pidof $PROCESS`

start() {
  yard server &
}

stop() {
  if [ "$PID" ];then
    kill -KILL $PID
    echo 'yard is stopped'
  fi
}

case "$1" in
start)
  start
;;
stop)
  stop
;;
restart)
  stop
  start
;;
*)
echo Usage: $0 [start|stop|restart]
;;
esac
