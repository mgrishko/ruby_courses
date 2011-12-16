# In file yard.sh:
#!/bin/sh

# edit PIDFILE if you want it somewhere local
PIDFILE=/home/demo/yard_pid/yard.pid

case "$1" in
start)
yard server &
echo $! > $PIDFILE
;;
stop)
kill -KILL `cat $PIDFILE`
;;
*)
echo Usage: $0 [start|stop]
;;
esac

