#!/bin/sh
#pinglog.txt is https://gist.github.com/suteaka1/1440b2a2f354fac21654
logfile=cat ~/pinglog.txt
jointemp1=$(mktemp jointemp1.XXXX)
jointemp2=$(mktemp jointemp2.XXXX)

grep "statistics" $logfile >> $jointemp1

grep "% packet loss" $logfile >> $jointemp2

paste $jointemp1 $jointemp2 > jointemp3


###
#つながるやつ
cat jointemp3 | grep -v "100% packet loss"

#つながらないやつ
cat jointemp3 | grep "100% packet loss"
