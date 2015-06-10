#!/bin/sh

ip1=`ifconfig | grep -A 1 'eth0' | grep 'inet' | awk '{ print $2}' | sed -e 's/addr://g'| tr '.' '    ' | awk '{ print $1}'`
ip2=`ifconfig | grep -A 1 'eth0' | grep 'inet' | awk '{ print $2}' | sed -e 's/addr://g'| tr '.' '    ' | awk '{ print $2}'`
ip3=`ifconfig | grep -A 1 'eth0' | grep 'inet' | awk '{ print $2}' | sed -e 's/addr://g'| tr '.' '    ' | awk '{ print $3}'`
ip4=`ifconfig | grep -A 1 'eth0' | grep 'inet' | awk '{ print $2}' | sed -e 's/addr://g'| tr '.' '    ' | awk '{ print $4}'`


#ip1=`ip a | grep 'inet' | grep 'eth0' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $1}'`
#ip2=`ip a | grep 'inet' | grep 'eth0' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $2}'`
#ip3=`ip a | grep 'inet' | grep 'eth0' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $3}'`
#ip4=`ip a | grep 'inet' | grep 'eth0' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $4}'`

#COUNT=`echo " ${ip4} - 6" | bc`
#MAX_COUNT=`echo " ${ip4} + 5" | bc`

        #if [ ${ip4} -eq 0 ]
        #then
        #        MAX_COUNT=`echo "${ip4} + 11" | bc`
        #elif [ ${ip4} -eq 255 ]
        #then
        #        COUNT=`echo "${ip4} - 11" | bc`
        #else
        #        : #echo "例外です。シェルスクリプトを終了します。" ; exit 1
        #fi
while [ $COUNT -lt $MAX_COUNT ]
        #if [ ${ip4} -eq 0 ]
        #then
        #       MAX_COUNT=`echo "${ip4} + 11" | bc`
        #elif [ ${ip4} -eq 255 ]
        #then
        #       COUNT=`echo "${ip4} - 11" | bc`
        #else
        #       echo "例外です。シェルスクリプトを終了します。" ; exit 1
        #fi

COUNT=`echo " ${ip4} - 6" | bc`
MAX_COUNT=`echo " ${ip4} + 5" | bc`
do
        COUNT=`expr $COUNT + 1`

        #if [ ${COUNT} = 0 ]
        #then
        #       MAX_COUNT=`echo "${COUNT} + 11" | bc`
        #elif [ ${COUNT} = 255 ]
        #then
        #       COUNT=`echo "${COUNT} - 11" | bc`
        #else
        #       : #echo "例外です。シェルスクリプトを終了します。" ; exit 1
        #fi
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
