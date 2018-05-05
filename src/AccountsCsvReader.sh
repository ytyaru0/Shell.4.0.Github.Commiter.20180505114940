#!/bin/bash
# Accounts.csv
#   Username,Email,Password[,AccessToken]

# bash 4.2から連想配列が使える
# グローバル変数 連想配列 user,email,pass,token
#[ "${VAR:-A}" = "${VAR-A}" ][] && { declare -A Account; }
[ -z "$Account" -a "${Account:-A}"="${Account-A}" ] && { declare -A Account; }

GetPathAccounts() {
    PATH_DIR_THIS=$(cd $(dirname $0); pwd)
    #PATH_ACCOUNTS="${PATH_DIR_THIS%/}/Accounts.csv"
    PATH_ACCOUNTS="$HOME/root/db/account/github/Accounts.csv"
    echo ${PATH_ACCOUNTS}
}
ReadUsers() {
    for line in $(cat $(GetPathAccounts) | grep -v ^#); do
        TEXT=${line}
        IFS=','
        set -- $TEXT
        echo $1
    done
}
# 連想配列に各値を設定する
ReadUser() {
    local user=$1
    for line in $(cat $(GetPathAccounts) | grep -v ^#); do
        TEXT=${line}
        IFS=','
        set -- $TEXT
        [ "$1" != "$user" ] && continue
        Account['user']=$1
        Account['email']=$2
        Account['pass']=$3
        Account['token']=$4
        return 0
    done
    echo "未存在エラー。指定したユーザは見つかりませんでした。"
    return 1
}
IsExistUser() {
    for name in $(ReadUsers); do
        [ "$name" == "$1" ] && { return 1; }
    done
    return 0;
}
#ReadUsers
#IsExistUser a
#echo $?
#IsExistUser ytyaru
#echo $?
#m=`ReadEmail ytyaru`
#p=`ReadPass ytyaru`
#echo $m
#echo $p
#t=`ReadToken ytmemo`
#echo $t
#ReadUser ytyaru
#echo ${Account[user]} ${Account[email]}
