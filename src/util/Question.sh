# 確認
# YES(OK),No,Cancel
#   YES/OK: 許可する
#   NO    : 許可しない
#   Cancel: 中断する
# 質問ループ
#   所定の入力値以外だったときの対応
#   * 質問をくりかえす
#   * 所定の値を返して終了
[ -z "$ConfirmMethods" -a "${ConfirmMethods:-A}"="${ConfirmMethods-A}" ] && { declare -A ConfirmMethods; }
[ -z "$ConfirmCodes" -a "${ConfirmCodes:-A}"="${ConfirmCodes-A}" ] && { declare -A ConfirmCodes; }
ConfirmCodes[y]=0
ConfirmCodes[n]=1
ConfirmCodes[o]=0
ConfirmCodes[c]=2
ConfirmMethods[y]="echo YES!!"
ConfirmMethods[n]="echo No..."
ConfirmMethods[o]="echo OK!!"
ConfirmMethods[c]="echo Cancell..."
Confirm() {
    echo "$1"
}
# $1 質問タイプ o,oc,yn,ync
ConfirmQuestion(){
    [ "$1"!='o' ] 
    local answer='InvalidValue'
    echo -n "$1 (y/n): "
    #while ([ 'y'!=$answer ] && [ 'n'!=$answer ]); do
    while [ 'y'!=$answer -a 'n'!=$answer ]; do
        read -n 1 answer
        echo ''
        echo $answer
    done
}
ConfirmYesNo() {
    echo 'aaaaaaaaaa'
    local answer='InvalidValue'
    #while ([ 'y'!=$answer ] && [ 'n'!=$answer ]); do
    #while [ 'y'="$answer" -o 'n'="$answer" ]; do
    while [ "y" != "$answer" -a "n" != "$answer" ]; do
        echo -n "$1 (y/n): "
        read -n 1 answer
        echo ''
    done
    #[ $# -lt 1 ] && { echo $answer; return; }
    echo $#
    [ $# -lt 2 ] && {
        [ 'y' = "$answer" ] && { return 0; }
        [ 'n' = "$answer" ] && { return 1; }
        { echo '他'; return 2;}
    }
    [ "$2" != '' ] && [ 'y' = "$answer" ] && { $2; return; }
    [ "$2" != '' -a 'y' = "$answer" ] && { $2; return; }
    [ "$3" != '' -a 'n' = "$answer" ] && { $3; return; }
    [ "$4" != '' ] && { $4; return; }
}
ConfirmYesNoCancel() {
    echo "$1 (y/n)"
    local answer
    read answer
}
ConfirmOkCancel() {
    echo
}
# 質問フォーム
# $1: 質問文
# $2: 選択肢
# $3: 回答後実行内容
QuestionYesNo() {
    echo $1
}
ConfirmYesNo "質問文1。"
ConfirmYesNo "質問文2。" && echo 'YES!!' || echo 'NO...'
ConfirmYesNo "質問文3。" "echo YES!!" "echo NO..." "echo ELSE"
ConfirmYesNo "質問文4。" "echo はい" "echo いいえ" "echo どちらでもない"
#a=`ConfirmYesNo "質問文。"`
#echo $a
