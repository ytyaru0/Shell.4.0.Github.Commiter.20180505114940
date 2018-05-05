# 連想配列 user, email, pass, token
ArrayToJson(){
    local json='{'
    for i in ${!Json[@]}; do
        json+='"'"$i"'"'
        #json+=`WrapDoubleQuote "$i"`
        json+=':'
        #json+=`WrapDoubleQuote "${Json[$i]}"`
        json+='"'"${Json[$i]}"'"'
        json+=','
    done
    json=${json%,}
    json+='}'
    echo "$json"
}
#declare -A Json
#Json[name]=USER
#Json[description]=説明
#ArrayToJson
