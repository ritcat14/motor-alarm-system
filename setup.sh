#!/bin/bash

# Automated raspi config setup
# Run script as sudo!
grep -E -v -e '^\s*#' -e '^\s*$' <<END | \
sed -e 's/$//' -e 's/^\/usr\/bin\/raspi-config nonint /' | bash -x -

# hardware config
do_boot_wait 1					# Turn on waiting for network
do_boot_splash 1				# Disable the splash screen
sh_ssh 1					# Enable remote SSH login
do_serial 0					# Enable the serial lines
do_boot_behaviour B2				# Boot to CLI and auto-login (headless)

# system config
do_hostname ${host}				# Change hostname
passwd pi					# Change default password

END

sed -i "s/start_x=0/start_x=1/g"		# Enable the camera
/sbin/shutdown -r now
