#!/bin/bash

if [ -z $1 ] || [ -z $2 ]; then
	echo "Format for script: ./send_test.sh <\"phone number\"> <\"text message\">"
	exit
else
	PHONE_NUMBER=$1
	MESSAGE_BODY=$2
fi

echo "======================================================"
echo "Script to send text message via attached SIM800X modem"
echo "======================================================"
echo
echo
echo "Sending script to modem, wih folowing parameters: "
echo
echo "Phone number: ${PHONE_NUMBER}"
echo "Message: ${MESSAGE_BODY}"
echo "Sending..."
echo "..."
echo "..."

#echo -e -n "AT+CMGF=1" > /dev/ttyAMA0
#echo -e -n "AT+CMGS=\"${PHONE_NUMBER}\"" > /dev/ttyAMA0
#echo -e -n "${MESSAGE_BODY}\n\032" > /dev/ttyAMA0

cat > /home/pi/project/SIM/send_textAT << EOF
send AT
expect "OK"

send AT+CMGF=1
expect "OK"

send AT+CMGS="\"${PHONE_NUMBER}\""
expect ">"
send "${MESSAGE_BODY}"
send "\032"

EOF

# disable internet temporarily
bash /home/project/vpn/stop_vpn.sh
bash /home/pi/project/SIM/poff.sh

sudo minicom -D /dev/ttyAMA0 -S /home/pi/project/SIM/send_textAT &

bash /home/pi/projet/SIM/pon.sh
bash /home/pi/project/vpn/start_vpn.sh

echo "Text sent!"
exit 0

