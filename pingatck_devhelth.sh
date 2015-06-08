#!/bin/sh
ip1=`ip a | grep 'inet' | grep 'eth0' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $1}'`
ip2=`ip a | grep 'inet' | grep 'eth0' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $2}'`
ip3=`ip a | grep 'inet' | grep 'eth0' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $3}'`
ip4=`ip a | grep 'inet' | grep 'eth0' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $4}'`

COUNT=`echo " ${ip4} - 6" | bc`
MAX_COUNT=`echo " ${ip4} +5" | bc`

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
