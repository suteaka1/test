#!/bin/sh
## pingを使って同じネットワーク内で繋がるIPアドレスを調べ、自身の機器が所属するネットワークを抽出し
## 他に繋がるデバイスが無いか調べる用途に使える。(もしかして：arp-scan)
#
## ひとつひとつをなるべく簡素にして、パイプの途中で区切ってその段階ではどういった処理を終えた段階なのか、
## 把握できるようになるべく凝ったことをしないよう決めた。
#
###課題
###・下のwhileループに第一、第二、第三オクテットを引き渡せるようにする
###・pingして応答するかしないかを判断する条件式を付与する       -> sleepの必要性
###・最後に結果を出力して正規表現で整形する？                   -> もっと高度なテキスト処理と、cronでまわすことで定期的なログを取れる？

####パイプ間のコマンドの説明
## ip a                 -> ifconfigなどで使われるnet-toolsは長い間メンテナンスされていなかったということで大変危険なので
##                      (理由:http://iwashi.co/2014/08/07/reason-why-we-should-use-iproute2/ 
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

eth0=ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | sed s/inet/inet:/ | cut -d: -f2 | awk '{ print $1}'
eth0=$1.$2.$3.$4

##  192.168.20.100/24
## だとしたら、第三オクテットまで取得して以下でforループに使う
#
## せっかくprefixもついてるので有効活用できると尚良い？
##               =>ハードルがあがるので今回は無しということに。上述した/24で絞る理由がこれ。

#まずインターネットに繋がるかどうか確認(googleDNSに向けて)
ping -c 5 8.8.8.8

#これ以降をループさせる
# 第４オクテット以外を、最初に抽出したものから引っ張りたい

####whileループ
COUNT=0
MAX_COUNT=255
while [ $COUNT -lt $MAX_COUNT ]
do
        COUNT=`expr $COUNT + 1`
        ping -c 5 $1.$2.$3.`echo "$COUNT"`
done

#####=========残骸=========
####forループ
#$COUNT=0
                        #MAX_COUNT=255
#for i in 1 2 3 4 5 6 7 8 9
#do
        #まちがいあり
#        COUNT=`expr $COUNT + $i`
#        ping -c 5 192.168.100.`echo "$COUNT"`
#done

##正常終了を宣言
exit 0
