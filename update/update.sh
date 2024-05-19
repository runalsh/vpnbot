#!/bin/bash
pwd=`pwd`
> $pwd/update/pipe
echo "$$" > $pwd/update/update_pid

while true
do
    cmd=$(cat $pwd/update/pipe)
    branch=$(cat $pwd/update/branch 2>/dev/null)
    if [[ -n "$cmd" ]]
    then
        key=$(cat $pwd/update/key)
        curl -H "Content-Type: application/json" -X POST https://api.telegram.org/bot$key/editMessageText -d "$(cat $pwd/update/curl | sed 's/"text":"~t~"/"text": "останавливаю бота"/')"
        docker compose down --remove-orphans
        curl -H "Content-Type: application/json" -X POST https://api.telegram.org/bot$key/editMessageText -d "$(cat $pwd/update/curl | sed 's/"text":"~t~"/"text": "очищаю директорию"/')"
        git reset --hard && git clean -fd
        curl -H "Content-Type: application/json" -X POST https://api.telegram.org/bot$key/editMessageText -d "$(cat $pwd/update/curl | sed 's/"text":"~t~"/"text": "скачиваю обновление"/')"
        git fetch
        if [[ -n "$branch" ]]
        then
            curl -H "Content-Type: application/json" -X POST https://api.telegram.org/bot$key/editMessageText -d "$(cat $pwd/update/curl | sed 's/"text":"~t~"/"text": "меняю ветку"/')"
            git checkout -t origin/$branch || git checkout $branch
        fi
        curl -H "Content-Type: application/json" -X POST https://api.telegram.org/bot$key/editMessageText -d "$(cat $pwd/update/curl | sed 's/"text":"~t~"/"text": "применяю обновления"/')"
        git pull > ./update/message
        curl -H "Content-Type: application/json" -X POST https://api.telegram.org/bot$key/editMessageText -d "$(cat $pwd/update/curl | sed 's/"text":"~t~"/"text": "запускаю бота"/')"
        IP=$(curl https://ipinfo.io/ip) VER=$(git describe --tags) docker compose up -d --force-recreate
        bash $pwd/update/update.sh &
        > $pwd/update/key
        > $pwd/update/curl
        exit 0
    fi
    sleep 1
done