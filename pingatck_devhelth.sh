#!/bin/sh
# pingしたときの一時作業スペース
cd /tmp

temp1=$(mktemp temp1.XXXX)

ip1=`ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $1}'`
ip2=`ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $2}'`
ip3=`ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $3}'`

COUNT=9
MAX_COUNT=30

while [ $COUNT -lt $MAX_COUNT ]
do
        COUNT=`expr $COUNT + 1`
        `echo $ip1`.`echo $ip2`.`echo $ip3`.`echo $COUNT`
        ping -c 4 -w 3 `echo "$ip1"`.`echo "$ip2"`.`echo "$ip3"`.`echo "$COUNT"` > $temp1
        judge=`grep -v "100% packet loss" $temp1
       if [ $temp1 -eq 0 ];then
                sed -e 's/^/x/g'
        else
                sed -e 's/^/o/g'
        fi
done

rm /tmp/$temp

exit 0
