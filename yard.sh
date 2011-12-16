# In file yard.sh:
#!/bin/sh

# edit PIDFILE if you want it somewhere local
PIDFILE=/home/mikhailaleksandrovi4/rails_projects/yard.pid

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

