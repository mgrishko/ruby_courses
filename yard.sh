# In file yard.sh:
#!/bin/sh

PROCESS='ruby /var/lib/jenkins/.rvm/gems/ruby-1.9.3-p0/bin/yard server'
PID=`pidof $PROCESS`

case "$1" in
start)
yard server &
;;
stop)
  if [ "$PID" ];then
    kill -KILL $PID
    echo 'yard is stopped'
  fi
;;
*)
echo Usage: $0 [start|stop]
;;
esac

