#!/bin/sh
ip1=`ifconfig | grep -A 1 'eth0' | grep 'inet' | awk '{ print $2}' | sed -e 's/addr://g'| tr '.' '    ' | awk '{ print $1}'`
ip2=`ifconfig | grep -A 1 'eth0' | grep 'inet' | awk '{ print $2}' | sed -e 's/addr://g'| tr '.' '    ' | awk '{ print $2}'`
ip3=`ifconfig | grep -A 1 'eth0' | grep 'inet' | awk '{ print $2}' | sed -e 's/addr://g'| tr '.' '    ' | awk '{ print $3}'`
ip4=`ifconfig | grep -A 1 'eth0' | grep 'inet' | awk '{ print $2}' | sed -e 's/addr://g'| tr '.' '    ' | awk '{ print $4}'`

if [ ${ip4} -le 5 ]
then
        RUN_IP=0
        MAX_IP=`echo "${ip4} + 5" | bc`
elif [ ${ip4} -ge 250 ]
then
        RUN_IP=`echo "${ip4} - 6" | bc`
        MAX_IP=254
else
        RUN_IP=`echo "${ip4} - 6" | bc`
        MAX_IP=`echo "${ip4} + 5" | bc`
fi

while [ $RUN_IP -lt $MAX_IP ]
#RUN_IP=`echo " ${ip4} - 6" | bc`
#MAX_IP=`echo " ${ip4} + 5" | bc`
do
        RUN_IP=`expr $RUN_IP + 1`
        ipaddr=${ip1}.${ip2}.${ip3}.${RUN_IP}
        judge=`ping -w 3 $ipaddr | grep '100%' | wc -l`
        if [ $judge -eq 1 ]
        then
                echo "×        ${ipaddr}"
        else
                echo "○        ${ipaddr}"
        fi
done

exit 0

if [ ${ip4} -le 5 ]
then
        RUN_IP=0
        MAX_IP=`echo "${ip4} + 5" | bc`
elif [ ${ip4} -ge 250 ]
then
        RUN_IP=`echo "${ip4} - 6" | bc`
        MAX_IP=254
else
        RUN_IP=`echo "${ip4} - 6" | bc`
        MAX_IP=`echo "${ip4} + 5" | bc`
fi

while [ $RUN_IP -lt $MAX_IP ]
#RUN_IP=`echo " ${ip4} - 6" | bc`
#MAX_IP=`echo " ${ip4} + 5" | bc`
do
        RUN_IP=`expr $RUN_IP + 1`
        ipaddr=${ip1}.${ip2}.${ip3}.${RUN_IP}
        judge=`ping -w 3 $ipaddr | grep '100%' | wc -l`
        if [ $judge -eq 1 ]
        then
                echo "×        ${ipaddr}"
        else
                echo "○        ${ipaddr}"
        fi
done

exit 0
