#!/bin/bash

if [ -z $1 ] || [ -z $2 ]; then
    echo "Format for script: ./sent_text.sh <\"phone number\"> <\"text message\">"
else
    PHONE=$1
    MESSAGE=$2

    cat > /home/pi/project/SIM/AT << EOF

send AT
expect "OK"

send AT+CMGF=1
expect "OK"

send AT+CMGS="\"${PHONE}\""
expect ">"

send "${MESSAGE}\032"

exit

EOF

    sudo poff fona & # turn off PPP internet

    sleep 10

    sudo minicom -D /dev/ttyAMA0 -S /home/pi/project/SIM/AT &

    sleep 10

    sudo fuser -k /dev/ttyAMA0

    sudo pon fona & # turn on  PPP internet
    sudo systemctl restart openvpn@client.service
fi
