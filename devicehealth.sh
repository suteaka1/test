#!/bin/sh
#pinglog.txt is https://gist.github.com/suteaka1/1440b2a2f354fac21654
cd ~/
###log fileを  pingattack.sh　から読み取れるようにする
logfile=~/pinglog.txt

jointemp1=$(mktemp jointemp1.XXXX)
jointemp2=$(mktemp jointemp2.XXXX)
jointemp3=$(mktemp jointemp3.XXXX)
#touch jointemp1
#touch jointemp2
grep "statistics" $logfile > $jointemp1
grep "% packet loss" $logfile > $jointemp2
paste $jointemp1 $jointemp2 > jointemp3

#grep "statistics" $logfile >> jointemp1
#grep "% packet loss" $logfile >> jointemp2
#paste jointemp1 jointemp2 > jointemp3


###
###ここはオプションで引き渡す
###
#つながるやつ
cat jointemp3 | grep -v "100% packet loss"

#つながらないやつ
cat jointemp3 | grep "100% packet loss"

###課題
##1.  logfileを引っ張れるようにする　もしくはpingattack.shと一緒にまとめる？
##2.  接続できるもの出来ないものをオプションを使って引き渡せるようにするか、ox形式で出力だけさせるのか
