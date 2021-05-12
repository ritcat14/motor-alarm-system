echo "Starting ppp..."
stty -F /dev/ttyAMA0 raw
stty -F /dev/ttyAMA0 -a
pon fona
doff 1
