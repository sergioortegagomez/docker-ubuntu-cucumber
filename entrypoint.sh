#!/bin/bash
if [ $DESKTOP == "false" ]; then
    Xvfb :7 -ac -screen 0 1280x1024x24 2>&1 &
    export DISPLAY=:7
    /usr/sbin/xrdp-sesman --nodaemon &
    /usr/sbin/xrdp -nodaemon &
    java -jar selenium-server-standalone-3.14.0.jar 2>&1 &
    sleep 5
    cd /opt/cucumber
    cucumber --format pretty --format html --out report.html
else
    /usr/bin/supervisord -n
fi