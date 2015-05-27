#!/bin/sh
temp1=$(mktemp /tmp/temp1.XXXX)

ip1=`ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $1}'`
ip2=`ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $2}'`
ip3=`ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $3}'`

COUNT=9
MAX_COUNT=30

while [ $COUNT -lt $MAX_COUNT ]
do
        COUNT=`expr $COUNT + 1`
        ipaddr=${ip1}.${ip2}.${ip3}.${COUNT}
        echo "ping test:$ipaddr"
        ping -c 4 $ipaddr > $temp1
        judge=`grep '100%' $temp1 | wc -l`
        if [ $judge -eq 1 ]
        then
                echo "×        ${ipaddr}"
        else
                echo "○        ${ipaddr}"
        fi
done

#一番上で宣言してるので/tmpの記述は不要
rm $temp1

exit 0
