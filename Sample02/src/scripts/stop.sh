#!/bin/bash
cd `dirname $0`
cd ..
DEPLOY_DIR=`pwd`
CONF_DIR=$DEPLOY_DIR/conf


DEPLOY_NAME="TaoEmallApplication"
SERVER_PORT=`cat $CONF_DIR/application.yml | grep -w "port:" | grep -v "#" |awk  'NR==1{print $2}' | tr -d '\r'`
echo -e "Stop emall server ...\c"
IS_LISTENED=`netstat -an | grep -w LISTEN | grep -w $SERVER_PORT`
my=`ps -ef |grep $DEPLOY_NAME | grep -v grep | awk '{print $2}'`
kill -9 $my
COUNT=1
while [ $COUNT -eq 1 ]; do
    echo -e ".\c"
    sleep 3
    IS_LISTENED=`netstat -an | grep -w LISTEN | grep -w $SERVER_PORT`
    if [ -z "$IS_LISTENED" ]; then
        COUNT=0
    fi
done
echo "Shut down OK!"
echo "The emall server is stopped."
