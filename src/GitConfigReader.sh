#!/bin/bash
# Accounts.csv
#   Username,Email,Password[,AccessToken]

# bash 4.2から連想配列が使える
# グローバル変数 連想配列 user,email,pass,token,repo
#[ "${VAR:-A}" = "${VAR-A}" ][] && { declare -A Account; }
[ -z "$GitConfig" -a "${GitConfig:-A}"="${GitConfig-A}" ] && { declare -A GitConfig; }

ReadGitConfig() {
    local f="${repo_path}/.git/config"
    [ ! -f "$f" ] && { echo "./git/configファイルが存在しません。: ${f}"; return 1; }
    . $(cd $(dirname $0); pwd)/IniReader.sh
    local url=`ReadIni "$f" 'remote "origin"' url`
    # 以下HTTPS形式を想定
    # https://user:pass@github.com/user/repo.git
    GitConfig[user]=`echo ${url} | awk -F "/" '{ print $(NF - 1) }'`
    #ReadUser "$gitconfig_user"
    GitConfig[repo]=`echo ${url} | awk -F "/" '{ print $NF }'`
    GitConfig[repo]=`echo ${GitConfig[repo]%.git}`
}
