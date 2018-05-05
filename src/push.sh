#!/bin/bash
IsSameRepoName () {
    . $(cd $(dirname $0); pwd)/GitConfigReader.sh
    ReadGitConfig
    [ $? -ne 0 ] && return
    ReadUser GitConfig[user]
    local cd_name=$(basename "${repo_path}")
    [ "${cd_name}" != "${GitConfig[repo]}" ] && { echo -e ".git/configのリポジトリ名とカレントディレクトリ名が一致しません。他所からコピペした.gitを間違って使い回していませんか？\n  .git/configリポジトリ名: ${GitConfig[repo]}\n  カレントディレクトリ名 : ${cd_name}"; exit 1; }
}
ExistReadMe () {
    for name in README ReadMe readme Readme; do
        for ext in "" .md .txt; do
            local f="${repo_path}/${name}${ext}"
            [ -f "$f" ] && { . $(cd $(dirname $0); pwd)/ReadMeReader.sh; description=`ReadDescription "$f"`; return 0; }
        done
    done
    echo "カレントディレクトリに ReadMe.md が存在しません。作成してください。: "${repo_path}
    exit 1
}
SelectUser () {
    # usernameが未定義ならユーザ選択させる
    if [ -z "${Account[username]}" ]; then
        local select=`ReadUsers`
        echo "ユーザを選択してください。"
        select i in $select; do [ -n "$i" ] && { ReadUser "$i"; break; }; done
    fi
}
IsRegistedUser () {
    IsExistUser "$1"
    [ 0 -eq $? ] && { echo "指定されたユーザ名はAccounts.csvに登録されていません。: '$1'"; exit 1; }
}
GetPassMail () {
    [ -z "${Account[pass]}" -o -z "${Account[token]}"] && { echo "パスワードとトークンの両方がが見つかりませんでした。少なくともひとつをAccounts.csvに入力してください。CSVの項目順序は以下の通りです。Username,E-MailAddress,Password[,AccessToken]"; exit 1; }
    [ -z "${Account[email]}" ] && { echo "メールアドレスが見つかりませんでした。Accounts.csvに入力してください。CSVの項目順序は以下の通りです。Username,E-MailAddress,Password[,AccessToken]"; exit 1; }
}
CreateRepository () {
    [ -d ".git" ] && return
    echo "リポジトリを作成しますか？ (y/n)"
    local ans=''
    read ans
    [ "$ans" != 'y' ] && exit 1
    git init
    CreateRemoteRepository
}
CreateRemoteRepository () {
    echo "リモートリポジトリを作成します。"
    #json='{"name":"'${REPO_NAME}'","description":"'${REPO_DESC}'","homepage":"'${REPO_HOME}'"}'it
    #echo $json | curl -u "${username}:${password}" https://api.github.com/user/repos -d @-
    local json='{"name":"'${repo_name}'"}'
    local secret="${Account[pass]}"
    [ "$token" != "" ] && local secret="${Account[token]}"
    local curl_user="${Account[user]}:${secret}"
    curl -u "$curl_user" -H "Time-Zone: Asia/Tokyo" https://api.github.com/user/repos -d "${json}"
    git remote add origin https://${Account[user]}:${secret}@github.com/${Account[user]}/${repo_name}.git
}
DeleteRemoteRepository () {
    curl -X DELETE 
}
CheckView () {
    git status -s
    echo "--------------------"
    git add -n .
    echo "--------------------"
    echo commit message入力するとPush。未入力のままEnterキー押下で終了。
    read answer
}
AddCommitPush () {
    if [ -n "$answer" ]; then
        git add .
        git commit -m "$answer"
        # stderrにパスワード付URLが見えてしまうので隠す
        git push origin master 2>&1 | grep -v http
    fi
}
MainMethod () {
    if [ -n "$answer" ]; then
        CreateRemoteRepository
        AddCommitPush 
    fi
}

# $1 Githubユーザ名
repo_path=`pwd`
. $(cd $(dirname $0); pwd)/AccountsCsvReader.sh
#repo_path=$(cd $(dirname $0); pwd)
IsSameRepoName 
ExistReadMe
[ 0 -eq $# ] && SelectUser
[ 0 -lt $# ] && IsRegistedUser $1

# パスワード取得と設定
GetPassMail
git config --local user.name ${Account[user]}
git config --local user.email "${Account[email]}"

# Create, Add, Commit, Push
repo_name=$(basename $repo_path)
#echo "$username/$repo_name"
echo "${Account[user]}/$repo_name"
CreateRepository 
CheckView
AddCommitPush 

#unset username
#unset password
#unset mailaddr
