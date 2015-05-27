#!/bin/sh
ip1=`ip a | grep 'inet' | grep 'eth0' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $1}'`
ip2=`ip a | grep 'inet' | grep 'eth0' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $2}'`
ip3=`ip a | grep 'inet' | grep 'eth0' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $3}'`

COUNT=9
MAX_COUNT=30

while [ $COUNT -lt $MAX_COUNT ]
do
        COUNT=`expr $COUNT + 1`
        ipaddr=${ip1}.${ip2}.${ip3}.${COUNT}
        judge=`ping -w 3 $ipaddr | grep '100%' | wc -l`
        if [ $judge -eq 1 ]
        then
                echo "×        ${ipaddr}"
        else
                echo "○        ${ipaddr}"
        fi
done

exit 0
