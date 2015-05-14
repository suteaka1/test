#!/bin/sh
#フィールドの種類
#USER	
#PID	
#%CPU	
#%MEM	
#VSZ	
#RSS	
#TTY	
#STAT	
#START	
#TIME	
#COMMAND

read -p "表示したいフィールド番号を1～11の中から選んでください。そのうちの上位10までを表示します: " field
ps --no-header aux | sort -r -k $field | head -n 10

#長時間動いているプロセス順にsort
#time = 10番目のフィールド
#⇒ sort -r -k -10
#echo "長時間動いていたプロセス上位10を表示します"
#ps --no-header aux | sort -r -k 10 | head -n 10
#echo "長時間動いていたプロセス下位10を表示します"
#ps --no-header aux | sort -r -k 10 | tail -n 10
#整形
#ps --no-header -e aux | sort -r -k 3 | head -n 20 | awk '{print $1,$3,$11;};'

##今後の課題
##引数を使って条件を変更できるようにする
##
##
#～～の順に並べて、必要なものだけ抽出する
#ps --no-header -e aux | sort -r -k ${フィールド} | head -n ${何位まで} | awk '{print 抽出したい項目;};'

exit 0
