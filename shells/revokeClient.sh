#!/bin/bash
echo "$(date +'%F %T') > begin revoking client config with mode << ${OVPN_CLIENT_MODE} >>"

CLIENT_NAME=${1:-$OVPN_CLIENT_NAME}
# CLIENT_PASS=${2:-$OVPN_CLIENT_PASS}

LAST_PWD=$(pwd)

cd /opt || exit
if [[ ${OVPN_CLIENT_MODE} == "onlycert" ]]; then
    echo "client is using certificate only"
    /opt/easyrsa/easyrsa revoke "${CLIENT_NAME}"

    echo "regenerating CRL"
    /opt/easyrsa/easyrsa gen-crl
    cp "${EASYRSA_PKI}/crl.pem" "${OVPN_DIR}"
    echo "CRL regenerated, please restart the openvpn server to finish the revoking process"
fi

if [[ ${OVPN_CLIENT_MODE} == "userpass" ]]; then
    echo "revoking client using auth pam feature is coming soon"

fi

if [[ ${OVPN_CLIENT_MODE} == "userpasswithcert" ]]; then
    echo "revoking client using auth pam feature is coming soon"

fi

cd "${LAST_PWD}" || exit
