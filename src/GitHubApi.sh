#!/bin/bash
CreateRepository () {
    if [ ! -d ".git" ]; then
        echo "リポジトリを作成しますか？ (y/n)"
        local ans=''
        read ans
        [ "$ans" == 'y' ] && { git init; CreateRemoteRepository; return; }
        exit 1
    fi
}
GitHubApiBaseUrl(){ echo 'https://api.github.com'; }
GitHubApiCurlUser(){
    secret="${password}"
    [ "$token" != "" ] && local secret="${token}"
    echo "${username}:${secret}"
}
CreateRemoteRepository () {
    echo "リモートリポジトリを作成します。"
    #json='{"name":"'${REPO_NAME}'","description":"'${REPO_DESC}'","homepage":"'${REPO_HOME}'"}'it
    #echo $json | curl -u "${username}:${password}" https://api.github.com/user/repos -d @-
    local json='{"name":"'${repo_name}'"}'
    local token=`ReadToken $username`
    [ "$token" == "" ] && local secret="${password}"
    [ "$token" != "" ] && local secret="${token}"
    local curl_user="${username}:${secret}"
    #curl -u "$curl_user" -H "Time-Zone: Asia/Tokyo" https://api.github.com/user/repos -d "${json}"
    curl -u "$curl_user" -H "Time-Zone: Asia/Tokyo" `GitHubApiBaseUrl`/user/repos -d "${json}"
    git remote add origin https://${username}:${secret}@github.com/${username}/${repo_name}.git
}
DeleteRemoteRepository () {
    local url=`GitHubApiBaseUrl`"/repos/$username/$repo_name"
    curl -u "$curl_user" -H "Time-Zone: Asia/Tokyo" `GitHubApiBaseUrl`/user/repos -d "${json}"
    curl -X DELETE 
    local owner=username
    local repo
}
