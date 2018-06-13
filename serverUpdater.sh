#!/bin/bash
echo "Stopping the server..."
/etc/init.d/vpnserver stop
echo "Recovering server config..."
cd .. && cp -r /usr/local/vpnserver/*vpn_server.config /root/serverBackup/
rm -rf /etc/init.d/vpnserver
rm -rf /usr/local/vpnserver
echo "Downloading the latest package..."
wget http://www.softether-download.com/files/softether/v4.27-9668-beta-2018.05.29-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.27-9668-beta-2018.05.29-linux-x64-64bit.tar.gz
tar -xzf softether*
rm -rf softether*
echo "Installing the latest package..."
cd vpnserver && expect -c 'spawn make; expect number:; send 1\r; expect number:; send 1\r; expect number:; send 1\r; interact'
cd .. && mv vpnserver /usr/local && chmod 600 * /usr/local/vpnserver/ && chmod 700 /usr/local/vpnserver/vpncmd && chmod 700 /usr/local/vpnserver/vpnserver
echo '#!/bin/sh
# description: SoftEther VPN Server
### BEGIN INIT INFO
# Provides:          vpnserver
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: softether vpnserver
# Description:       softether vpnserver daemon
### END INIT INFO
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
test -x $DAEMON || exit 0
case "$1" in
start)
$DAEMON start
touch $LOCK
;;
stop)
$DAEMON stop
rm $LOCK
;;
restart)
$DAEMON stop
sleep 3
$DAEMON start
;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0' > /etc/init.d/vpnserver
###
chmod 755 /etc/init.d/vpnserver
update-rc.d vpnserver defaults
###
echo "Other Sytem Configuration Setup"
if ! [[ -e /etc/sysctl.confx ]]; then
cp /etc/sysctl.conf /etc/sysctl.confx
echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf
sysctl -w net.ipv4.ip_forward=1
sysctl --system; fi
if ! [[ -e /etc/resolv.confx ]]; then
cp /etc/resolv.conf /etc/resolv.confx
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf; fi
echo "Restoring the server config..."
cd .. && cp -r /root/serverBackup/*vpn_server.config /usr/local/vpnserver/
echo "Starting the server..."
/etc/init.d/vpnserver start
sleep 5
clear
rm serverUpdater.sh*
cd root
rm serverUpdater.sh*
echo "AutoScript By: Dexter Cellona Banawon (PHC - Granade)"
