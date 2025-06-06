#!/bin/bash
echo "$(date +'%F %T') > creating user base config"

mkdir -p -v "$OVPN_CLIENT_DIR/keys" "$OVPN_CLIENT_DIR/files" "${OVPN_CLIENT_CCD}"

echo "client
dev tun
proto ${OVPN_PROTOCOL}
remote ${OVPN_REMOTE_ADDRESS} ${OVPN_REMOTE_PORT}
resolv-retry infinite
nobind
user nobody
group nogroup
persist-key
persist-tun
remote-cert-tls server
cipher ${OVPN_SERVER_CIPHER:-'AES-256-CBC'}
data-ciphers ${OVPN_SERVER_CIPHER:-'AES-256-CBC'}
data-ciphers-fallback ${OVPN_SERVER_CIPHER:-'AES-256-CBC'}
auth ${OVPN_SERVER_AUTH:-'SHA256'}
verb 6
key-direction 1
" >"${OVPN_CLIENT_DIR}/base.conf"

if [[ "${OVPN_CLIENT_COMPRESS}" == 'true' ]]; then
  echo "comp-lzo" >>"${OVPN_CLIENT_DIR}/base.conf"
fi

if [[ ${OVPN_CLIENT_MODE} == "userpass" ]]; then
  echo -e "auth-nocache\n" >>"${OVPN_CLIENT_DIR}/base.conf"
  echo -e "auth-user-pass\n" >>"${OVPN_CLIENT_DIR}/base.conf"
fi

if [[ ${OVPN_CLIENT_MODE} == "userpasswithcert" ]]; then
  echo -e "auth-nocache\n" >>"${OVPN_CLIENT_DIR}/base.conf"
  echo -e "auth-user-pass\n" >>"${OVPN_CLIENT_DIR}/base.conf"
fi

echo "$(date +'%F %T') > client base config done"
