#!/bin/bash
echo "$(date +'%F %T') > begin generating client config with mode << ${OVPN_CLIENT_MODE} >>"

CLIENT_NAME=${1:-$OVPN_CLIENT_NAME}
CLIENT_PASS=${2:-$OVPN_CLIENT_PASS}

LAST_PWD=$(pwd)

cd /opt || exit
if [[ ${OVPN_CLIENT_MODE} == "onlycert" ]]; then
    echo "using certificate only"
    bash ./helper/certClientConfig.sh "${CLIENT_NAME}"
fi

if [[ ${OVPN_CLIENT_MODE} == "userpass" ]]; then
    echo "using auth pam"
    bash ./helper/userpassClientConfig.sh "${CLIENT_NAME}" "${CLIENT_PASS}"
fi

if [[ ${OVPN_CLIENT_MODE} == "userpasswithcert" ]]; then
    echo "using auth pam"
    bash ./helper/userpassCertClientConfig.sh "${CLIENT_NAME}" "${CLIENT_PASS}"
fi

if [[ "${OVPN_CLIENT_UNIQUE}" == 'true' ]]; then
    if [ -f "${OVPN_CLIENT_CCD}/${CLIENT_NAME}" ]; then
        echo "$(date +'%F %T') > config \"$(ls "${OVPN_CLIENT_CCD}/${CLIENT_NAME}")\" already exist"
    else
        echo "" >"${OVPN_CLIENT_CCD}/${CLIENT_NAME}"
        echo "$(date +'%F %T') > config \"$(ls "${OVPN_CLIENT_CCD}/${CLIENT_NAME}")\" created"
    fi

fi

cd "${LAST_PWD}" || exit
