# 機能
①
目的：自分の所属するネットワークアドレスを元に、
ネットワーク内で他に疎通が取れる機器を探し出す


使えるもの：whileループ、sed、awk、cut、grep、tr


https://raw.githubusercontent.com/suteaka1/test/master/pingattack.sh

②
目的：稼働時間の長いプロセスをソートする


使えるもの：sort、ps、head、tail、awk


https://raw.githubusercontent.com/suteaka1/test/master/process_report.sh

# 使い方
ダウンロード


~$ wget https://raw.githubusercontent.com/suteaka1/test/master/pingattack.sh ; chmod +x pingattack.sh


実行


~$ ./pingattack.sh


# その他

●1.シェルスクリプトのコメント行が長いので消し去りたい
 
 ~$ grep -v \\# pingattack.sh
 
 
●2.編集履歴を確認したい

https://github.com/suteaka1/test/blob/master/pingattack.sh

であれば「History」ボタンをクリックする

https://github.com/suteaka1/test/commits/master/pingattack.sh

に編集履歴が並んでいるので1番下以外を選ぶとsdiffした結果が見える


●3.シェルスクリプトをそのままtext形式でダウンロードして使いたい

 2.とおなじページで「raw」ボタンをクリックする
