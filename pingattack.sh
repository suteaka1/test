#!/bin/sh
#pingを使って同じネットワーク内で繋がるIPアドレスを調べる

#所属するネットワークを抽出
#ひとつひとつをなるべく簡素にした。
#ipv6が必要になったときに簡単に変更できるようあえて1文で削らない。
#
#下のwhileループに第一、第二、第三オクテットを引き渡したいが途中のまま
eth0=ip a | grep 'inet' | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | sed s/inet/inet:/ | cut -d: -f2 | awk '{ print $1}'
eth0=$a.$b.$c.$d

#192.168.20.10/24
#だとしたら、第三オクテットまで取得して
#以下でforループに使う
#せっかくprefixもついてるので有効活用できると尚良い？

#インターネットに繋がるかどうか確認(googleDNSに向けて)
ping -c 5 8.8.8.8

#これ以降をループさせる
# 第４オクテット以外を、最初に抽出したものから引っ張りたい

####whileループ
COUNT=0
MAX_COUNT=255
while [ $COUNT -lt $MAX_COUNT ]
do
        COUNT=`expr $COUNT + 1`
        ping -c 5 192.168.100.`echo "$COUNT"`
done

####forループ
#$COUNT=0
                        #MAX_COUNT=255
#for i in 1 2 3 4 5 6 7 8 9
#do
        #まちがいあり
#        COUNT=`expr $COUNT + $i`
#        ping -c 5 192.168.100.`echo "$COUNT"`
#done
exit 0
