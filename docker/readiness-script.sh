#!/bin/bash

cat /dev/null > output.log

while true
do
        docker logs lsp_app >> output.log
        grep "ready to handle connections" output.log
        if [ $? -eq 0 ]
        then
                exit 0
        fi
        sleep 5
done
