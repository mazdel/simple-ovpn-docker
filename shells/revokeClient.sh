#!/bin/bash
echo "$(date +'%F %T') > begin revoking client config with mode << ${OVPN_CLIENT_MODE} >>"

CLIENT_NAME=${1:-$OVPN_CLIENT_NAME}
# CLIENT_PASS=${2:-$OVPN_CLIENT_PASS}
KEY_DIR=${OVPN_CLIENT_DIR}/keys
OUTPUT_DIR=${OVPN_CLIENT_DIR}/files

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

if [[ "${OVPN_CLIENT_UNIQUE}" == 'true' ]]; then
    if [ -f "${OVPN_CLIENT_CCD}/${CLIENT_NAME}" ]; then
        echo "$(date +'%F %T') > deleting config \"$(ls "${OVPN_CLIENT_CCD}/${CLIENT_NAME}")\""
        rm -vf "${OVPN_CLIENT_CCD}/${CLIENT_NAME}"
    else
        echo "$(date +'%F %T') > config \"$(ls "${OVPN_CLIENT_CCD}/${CLIENT_NAME}")\" is not exist"
    fi
fi

rm -vf "${KEY_DIR}/${CLIENT_NAME}".*
rm -vf "${OUTPUT_DIR}/${CLIENT_NAME}.ovpn"

cd "${LAST_PWD}" || exit
