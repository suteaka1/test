#!/bin/sh
## pingを使って同じネットワーク内で繋がるIPアドレスを調べ、自身の機器が所属するネットワークを抽出し
## 他に繋がるデバイスが無いか調べる用途に使える。(もしかして：arp-scan)
#
## ひとつひとつをなるべく簡素にして、パイプの途中で区切ってその段階ではどういった処理を終えたのか、
## 把握できるようになるべく凝ったことをしないよう決めた。
#
###課題
###・下のwhileループに第一、第二、第三オクテットを引き渡せるようにする              ==>　クリア
###・pingして応答するかしないかを判断する条件式を付与する       -> sleepの必要性    ==>　不要
###・最後に結果を出力して正規表現で整形する？                   -> もっと高度なテキスト処理と、cronでまわすことで定期的なログを取れる？

##参考
# 変数展開時の単語分割（word split）をマスターする
# http://qiita.com/uasi/items/82b7708d5da213ba7c31

# 第1引数を echo する関数
function echo_1st {
    echo $1
}
# 第2引数を echo する関数
function echo_2nd {
    echo $2
}
# 第3引数を echo する関数
function echo_3rd {
    echo $3
}
# 第4引数を echo する関数
function echo_4th {
    echo $4
}


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
#
## sed -e 's/\/24//g'   -> 「/24」部分を消す
#
## tr '.' '    '         -> bashでは文字列をスペースの位置で分割して複数の文字列のように扱うことが出来るので、「.」を「スペース」に置換する

ip=`ip a | grep 'inet' | grep /24 | grep -v 'inet6' | grep -v 'eth1' | grep -v '127.0.0.1' | sed s/inet/inet:/ | cut -d: -f2 | awk '{ print $1}' | sed -e 's/\/24//g' | tr '.' '    '`

# 192.168.100.1が割り当てられたアドレスならば、「192.168.100」の第三オクテットまでを表示する
ip3=`echo_1st $ip`.`echo_2nd $ip`.`echo_3rd $ip`

# 192.168.100.x の x 部分を0から255の順に試す
COUNT=0
MAX_COUNT=255
while [ $COUNT -lt $MAX_COUNT ]
do
        COUNT=`expr $COUNT + 1`
        ping -c 5 `echo "$ip3"`.`echo "$COUNT"`
        # -c[count] 5一つで約5秒かかるが、sleepしなくても順序は飛ばさない模様？
        # sleep 5
done

exit 0
