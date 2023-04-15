#!/bin/sh
host=$1
pingCount=3
maxRetry=15
# Phone nuber to send text message
sendTextTo=48

date=`date --rfc-822`

if [ -f "/tmp/$host.check" ]; then
    tried=`cat /tmp/$host.check | wc -l`
else
    tried=0
fi

function pingcheck
{
    ping=`ping -c $pingCount $host | grep bytes | wc -l`
    if [ "$ping" -gt 1 ];then
        echo "$date : $host is up"
        if [ "$tried" -ge 1 ];then
            echo "Network is back!"
            sms_tool -d /dev/ttyACM0  send $sendTextTo "Network is back"
            rm "/tmp/$host.check"
        fi
    else
        echo "$date : $host is down"
        echo "$date : $host is down" >> "/tmp/$host.check"
        echo "Tried already $tried times"
        if [ "$tried" -ge "$maxRetry" ];then
            sms_tool -d /dev/ttyACM0  send $sendTextTo "Network is down. Restarted WAN $retry on $host"
            restart="/sbin/ifup wan"
            echo "$date interface restarted: $restart"
            echo "$date interface restarted: $restart" >> "/tmp/network_check.log"
            rm "/tmp/$host.check"
        else
            sms_tool -d /dev/ttyACM0  send $sendTextTo "Network is down. Can not ping $host"
            echo "$date : Failed $tried, too early restart after $maxRetry"
        fi
    fi
}

pingcheck