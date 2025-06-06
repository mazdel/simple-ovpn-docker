#!/bin/bash

# First argument: Client identifier

KEY_DIR=${OVPN_CLIENT_DIR}/keys
OUTPUT_DIR=${OVPN_CLIENT_DIR}/files
BASE_CONFIG=${OVPN_CLIENT_DIR}/base.conf
CLIENT_NAME=${1:-$OVPN_CLIENT_NAME}
CLIENT_PASS=${2:-$OVPN_CLIENT_PASS}

cp "${EASYRSA_PKI}/ca.crt" "${EASYRSA_PKI}/ta.key" "$OVPN_CLIENT_DIR/keys"

if getent passwd "${CLIENT_NAME}" > /dev/null
then
    echo -e "\n"$(date +"%F %T")" >>> user ${CLIENT_NAME} already exist, can't create new user <<<"
else
    echo "${CLIENT_NAME}:${CLIENT_PASS}::openvpn:::/bin/false" | newusers
    echo -e "\n"$(date +"%F %T")" > done creating ${CLIENT_NAME} as new unix user"
fi

cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    ${KEY_DIR}/ca.crt \
    <(echo -e '</ca>')\
    > ${OUTPUT_DIR}/${CLIENT_NAME}.ovpn

if [[ "${OVPN_SERVER_USETLS}" == 'true' ]]
then
    cat <(echo -e '<tls-auth>') \
        ${KEY_DIR}/ta.key \
        <(echo -e '</tls-auth>') \
        >> ${OUTPUT_DIR}/${CLIENT_NAME}.ovpn
fi

echo -e "\n"$(date +"%F %T")" > client ${CLIENT_NAME}.ovpn is ready"
echo -e "\n"$(date +"%F %T")" > client config generated"