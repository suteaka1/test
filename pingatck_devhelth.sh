#!/bin/sh
## pingを使って同じネットワーク内で繋がるIPアドレスを調べ、自身の機器が所属するネットワークを抽出し
## 他に繋がるデバイスが無いか調べる用途に使える。(もしかして：arp-scan)
#
## ひとつひとつをなるべく簡素にして、パイプの途中で区切ってその段階ではどういった処理を終えたのか、
## 把握できるようになるべく凝ったことをしないよう決めた。
#

temp1=$(mktemp temp1.XXXX)
temp2=$(mktemp temp2.XXXX)

####パイプ間のコマンドの説明
## ip a                 -> ifconfigなどで使われるnet-toolsは長い間メンテナンスされていなかったということで大変危険なので
##                      (理由:http://iwashi.co/2014/08/07/reason-why-we-should-use-iproute2/ )
##                      https://dougvitale.wordpress.com/2011/12/21/deprecated-linux-networking-commands-and-their-replacements/)
##                      代用になるiproute2を使うことに。
##                      また、ifconfigには:がipv4アドレスの手前にあったのでcutのデリミタで使えたが、ip addr showにはないので
##                      せっかくなのでsedをつかって置換をする手順を加えてみた。
#
## grep 'inet'          -> ip aの標準出力から「inet」が含まれる行を抽出=ipアドレスの抽出
## grep /24             -> ip aの標準出力から「/24」が含まれる行を抽出=第三オクテットまでを固定化したい。理由は下記でまた述べる。
## grep -v 'inet6'      -> ip aからipv6が含まれる行を省く。
## grep -v 'eth1'       -> ip aからeht1が含まれる行を省く。
## grep -v '127.0.0.1'  -> ip aからローカルループバックアドレス(lo)が含まれる行を省く。
#
## sed s/inet/inet:/    -> ifconfigと違いip aには「:」が含まれない為、cutを使いにくいのでsedで置換をする。
#
## cut -d: -f2          -> cutを使い「:」をデリミタにし、ipアドレスの含まれる第二フィールドを選び「inet: 」を排除する。
#
## awk '{ print $1}'    -> cutで先頭部分を排除できたので、ipアドレスのある部分を引数「$1」とawkをつかって出力する。
#
## sed -e 's/\/24//g'   -> 「/24」部分を消す
#
## tr '.' '    '         -> bashでは文字列をスペースの位置で分割して複数の文字列のように扱うことが出来るので、「.」を「スペース」に置換する

ip1=`ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $1}'`
ip2=`ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $2}'`
ip3=`ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | awk '{ print $2}' | sed -e 's/\/24//g' | tr '.' '    ' | awk '{ print $3}'`

# 192.168.100.x の x 部分を0から255の順に試す
#が、ひとまず現実的ではないので削る
#COUNT=0
#MAX_COUNT=255

output=$( grep "% packet loss" $temp1 )
#reachable=$( $( echo $output ) | grep -v "100% packet loss" | sed -e 's/^/o/g' )
#unreachable=$( $( echo $output ) | grep "100% packet loss" | sed -e 's/^/x/g' )
        
        
COUNT=1
MAX_COUNT=10
while [ $COUNT -lt $MAX_COUNT ]
do
        COUNT=`expr $COUNT + 1`
        #ひとまずroot権限有りアカウントで
        sudo ping -f -c 5 `echo "$ip1"`.`echo "$ip2"`.`echo "$ip3"`.`echo "$COUNT"` > $temp1
        #$reachable || $unreachable >> $temp2
        case "$output" in
        r) grep -v "100% packet loss" | sed -e 's/^/o/g' ;;
        u) grep "100% packet loss" | sed -e 's/^/x/g' ;;
        esac
        sleep 6
        # -c[count] 5一つで約5秒かかるが、sleepしなくても順序は飛ばさない模様？
        # sleep 5
done

cat $temp2

exit 0

####課題
#1.いらない処理が多いので削って簡素化する
#2.devicehealth.shを組み込む。そのために、pingattack.shのループ内に組み込む
#3.waitなりsleepなりをいれる
#4.全体が終了するのに時間がかかる
##早くするには以下がある
## $ sudo ping -f -c 500 192.168.200.1
##か
## $ sudo ping -i 0.05 -c 500 192.168.200.1
#があるがどっちもroot権限が必要なのがちょっと・・・
