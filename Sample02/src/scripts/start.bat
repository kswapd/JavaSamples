@echo off
title smartDI_BackEnd
cd..
set DEPLOY_DIR=%cd%
set JVM_OPTS="-XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=128m -Xms128m -Xmx512m -Xmn64m -Xss256k -XX:SurvivorRatio=8 -XX:+UseConcMarkSweepGC"
set CONF_DIR=%DEPLOY_DIR%\conf
set LOG4J_CONFIG=%CONF_DIR%\log4j2.xml
set LOAD_CONF=%CONF_DIR%\
set LIB_DIR=%DEPLOY_DIR%\lib
set SERVER_NAME=smartDI
set SERVER_PORT=9088
FOR /F "eol=; tokens=2,2 delims=:" %%i IN ('findstr /i "port" %CONF_DIR%\application.yml') DO (
    set SERVER_PORT=%%i
)
:del_left
if "%SERVER_PORT:~0,1%"==" " set SERVER_PORT=%SERVER_PORT:~1%&&goto del_left
echo start app port is %SERVER_PORT%
set LOGS_DIR=%DEPLOY_DIR%\log
if exist %LOGS_DIR% (
    echo find %LOGS_DIR%
) else (
    echo not find %LOGS_DIR%, will create
    md %LOGS_DIR%
)
set STDOUT_FILE=%LOGS_DIR%\stdout.log
if exist %STDOUT_FILE% (
    del %STDOUT_FILE%
)
set LIB_JARS=
for /f "delims=" %%a in ('dir /b %LIB_DIR%\*.jar') do (
    set LIB_JARS=%LIB_JARS% %%a
)
:del_left2
if "%LIB_JARS:~0,1%"==" " set LIB_JARS=%LIB_JARS:~1%&&goto del_left2
rem java -jar -Dlog4j.configurationFile=file://%LOG4J_CONFIG% %LIB_DIR%\%LIB_JARS% %JVM_OPTS% --server.port=%SERVER_PORT% --spring.config.location=%LOAD_CONF% >> %STDOUT_FILE%
java -jar -Dlog4j.configurationFile=file://%LOG4J_CONFIG% %LIB_DIR%\%LIB_JARS%  %JVM_OPTS% --server.port=%SERVER_PORT% --spring.config.location=%LOAD_CONF%