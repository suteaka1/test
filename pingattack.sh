#!/bin/sh
ip=$(ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | sed s/inet/inet:/ | cut -d: -f2 | awk '{ print $1}' | sed -e 's/\/24//g' | tr '.' '    ')

##参考
#変数展開時の単語分割（word split）をマスターする
#http://qiita.com/uasi/items/82b7708d5da213ba7c31
function echo_1st {
    echo $1
}
function echo_2nd {
    echo $2
}
function echo_3rd {
    echo $3
}
function echo_4th {
    echo $4
}

####whileループ
COUNT=0
MAX_COUNT=255
while [ $COUNT -lt $MAX_COUNT ]
do
        COUNT=`expr $COUNT + 1`
        ping -c `echo_1st $ip`.`echo_2nd $ip`.`echo_3rd $ip`.`echo "$COUNT"`
done

##正常終了を宣言
exit 0
