#!/bin/bash
cd `dirname $0`
cd ..
DEPLOY_DIR=`pwd`
DEFAULT_CONFIG="classpath:/application.yml"
JVM_OPTS="-XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=128m -Xms1g -Xmx4g -Xmn64m -Xss256k -XX:SurvivorRatio=8 -XX:+UseConcMarkSweepGC"
CONF_DIR=$DEPLOY_DIR/conf
LOAD_CONF=$CONF_DIR/
LIB_DIR=$DEPLOY_DIR/lib
SERVER_NAME="Tao Emall"
SERVER_PORT=`cat $CONF_DIR/application.yml | grep -w "port:" | grep -v "#" |awk  'NR==1{print $2}' | tr -d '\r'`
IS_LISTENED=`netstat -an | grep -w LISTEN | grep -w $SERVER_PORT`
LOG4J_CONFIG="-Dlog4j.configurationFile="$CONF_DIR/log4j2.xml

LOGS_DIR=$DEPLOY_DIR/logs
if [ ! -d $LOGS_DIR ]; then
    mkdir $LOGS_DIR
fi
STDOUT_FILE=$LOGS_DIR/stdout.log

LIB_JARS=`ls $LIB_DIR|grep .jar|awk '{print "'$LIB_DIR'/"$0}'|tr "\n" ":"`
# DEBUG_OPTS="-Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n"
echo -e "Starting $SERVER_NAME ...\c"
#$JAVA_HOME/bin/java $JVM_OPTS $LOG4J_CONFIG -jar $LIB_JARS  --spring.config.location=$LOAD_CONF > $STDOUT_FILE 2>&1 &
$JAVA_HOME/bin/java $JVM_OPTS $LOG4J_CONFIG  -classpath $CONF_DIR:$LIB_JARS com.daqin.TaoEmallApplication --spring.config.location=$LOAD_CONF > $STDOUT_FILE 2>&1 &

COUNT=2
while [ $COUNT -lt 1 ]; do
    echo -e ".\c"
    sleep 3
    IS_LISTENED=`netstat -an | grep -w LISTEN | grep -w $SERVER_PORT`
    if [ -n "$IS_LISTENED" ]; then
        COUNT=1
    fi
done

PIDS=`ps -ef | grep "$LIB_DIR" | awk 'NR==1{print $2}'`
echo "OK!"
echo "PID: $PIDS"
echo "STDOUT: $STDOUT_FILE"