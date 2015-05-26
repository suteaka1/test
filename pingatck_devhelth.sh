#!/bin/sh
## pingを使って同じネットワーク内で繋がるIPアドレスを調べ、自身の機器が所属するネットワークを抽出し
## 他に繋がるデバイスが無いか調べる用途に使える。(もしかして：arp-scan)
#
## ひとつひとつをなるべく簡素にして、パイプの途中で区切ってその段階ではどういった処理を終えたのか、
## 把握できるようになるべく凝ったことをしないよう決めた。
#test

# pingしたときの一時作業スペース
temp1=$(mktemp temp1.XXXX)
temp2=$(mktemp temp2.XXXX)
temp3=$(mktemp temp3.XXXX)
####パイプ間のコマンドの説明
## ip a                 -> ifconfigなどで使われるnet-toolsは長い間メンテナンスされていなかったということで大変危険なので
##                      (理由:http://iwashi.co/2014/08/07/reason-why-we-should-use-iproute2/ )
##                      https://dougvitale.wordpress.com/2011/12/21/deprecated-linux-networking-commands-and-their-replacements/)
##                      代用になるiproute2を使うことに。
## grep 'inet'          -> ip aの標準出力から「inet」が含まれる行を抽出=ipアドレスの抽出
## grep /24             -> ip aの標準出力から「/24」が含まれる行を抽出=第三オクテットまでを固定化したい。理由は下記でまた述べる。
## grep -v 'inet6'      -> ip aからipv6が含まれる行を省く。
## grep -v 'eth1'       -> ip aからeht1が含まれる行を省く。
## grep -v '127.0.0.1'  -> ip aからローカルループバックアドレス(lo)が含まれる行を省く。
## awk '{ print $2}'    -> ipアドレスのある部分を引数「$2」とawkをつかって出力する。
## sed -e 's/\/24//g'   -> 「/24」部分を消す
## tr '.' '    '        -> bashでは文字列をスペースの位置で分割して複数の文字列のように扱うことが出来るので、「.」を「スペース(Tab)」に置換する
## awk '{ print $？}'   -> 1,2,3とそれぞれ入っているが、第一オクテット、第二オクテット、第三オクテット  を指している。
##                         以前は関数を作っていたがawkで引っ張ったほうが教えやすいとのことで変更

ip1=`ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $1}'`
ip2=`ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $2}'`
ip3=`ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $3}'`

# 192.168.100.x の x 部分を0から255の順に試す
#が、ひとまず現実的ではないので削る 10個程度で流す
#COUNT=0
#MAX_COUNT=255

# packet lossの含まれる行の抽出
#output=`grep "% packet loss" $temp1`

# packet lossの含まれる行の「中で」疎通可能か不可能化判別する[上のoutputが存在しないと-vでそれ以外の行を出力してしまう]

# 疎通可能
#reachable=` echo $output | grep -v "100% packet loss" | sed -e 's/^/o/g' `
# 疎通負荷
#unreachable=` echo $output  | grep "100% packet loss" | sed -e 's/^/x/g' `


#        echo "start reachable"
#        $reachable

#        echo "start unreachable"
#        $unreachable

COUNT=0
MAX_COUNT=10
while [ $COUNT -lt $MAX_COUNT ]
do
        COUNT=`expr $COUNT + 1`
        `echo $ip1`.`echo $ip2`.`echo $ip3`.`echo $COUNT` >> $temp3
        ping -c 4 `echo "$ip1"`.`echo "$ip2"`.`echo "$ip3"`.`echo "$COUNT"` > $temp1
#       grep "packet loss" $temp1 | grep "100% packet loss" > $temp2
#       if [ -s $temp2 ]
#       then
#               sed -e 's/^/x/g' >> $temp3
#               : > $temp2
#       else
#               grep "packet loss" $temp1 | grep -v "100% packet loss" | sed -e 's/^/o/g' >> $temp3
#               : > $temp2
#       fi
        #echo "start unreachable"
        #$unreachable
done

exit 0
