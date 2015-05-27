#!/bin/sh
temp1=$(mktemp /tmp/temp1.XXXX)

ip1=`ip a | grep inet | grep -v "127\.0\.0\.1" | awk '{print $2}' | sed 's/\/24//g' | sed 's/\./\t/g' | awk '{print $1}'`
ip2=`ip a | grep inet | grep -v "127\.0\.0\.1" | awk '{print $2}' | sed 's/\/24//g' | sed 's/\./\t/g' | awk '{print $2}'`
ip3=`ip a | grep inet | grep -v "127\.0\.0\.1" | awk '{print $2}' | sed 's/\/24//g' | sed 's/\./\t/g' | awk '{print $3}'`


COUNT=9
MAX_COUNT=30

while [ $COUNT -lt $MAX_COUNT ]
do
        COUNT=`expr $COUNT + 1`
#        echo "start ping to ${ip1}.${ip2}.${ip3}.${COUNT}"
        ping -c 4 -w 4 ${ip1}.${ip2}.${ip3}.${COUNT} > $temp1
        hantei=`grep "100% packet loss" $temp1 | wc -l`
        if [ $hantei -eq 1 ] ; then
         echo "X ${ip1}.${ip2}.${ip3}.${COUNT}"
        else
         echo "O ${ip1}.${ip2}.${ip3}.${COUNT}"
        fi
done

rm -f /tmp/$temp1

exit 0
