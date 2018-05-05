# リポジトリの説明文を取得する。
# (ファイルはMarkdownと仮定し、最初に見つけた見出し以外の行を対象とする)
#   $1: 対象ファイル
ReadDescription(){
    cat $1 | while read line; do
        local line=`echo $line | xargs`
        [ '' == "$line" ] && continue
        [ '#' == "${line:1:1}" ] && continue
        echo $line
        return
    done
}
#f="$(pwd)/ReadMe.md"
#ReadDescription $f
