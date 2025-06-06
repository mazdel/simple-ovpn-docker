#!/bin/bash

mkdir -p -v /dev/net
mknod /dev/net/tun c 10 200
chmod 600 /dev/net/tun
ls -lh /dev/net
echo "$(date +'%F %T') > tun device created"

if [ ! -f "${EASYRSA_PKI}/ca.crt" ]; then
    bash serverConfig.sh
    bash baseClientConfig.sh
    bash generateClient.sh
    ln -s "$(pwd)/generateClient.sh" /usr/bin/
    ln -s "$(pwd)/revokeClient.sh" /usr/bin/
    echo "$(date +"%F %T") > all configuration done"
fi

iptables-restore </etc/iptables/rules.v4
openvpn --config "${OVPN_DIR}/server.conf"

exec "$@"
