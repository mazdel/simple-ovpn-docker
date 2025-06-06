#!/bin/bash

echo -e "\n$(date +'%F %T') > initiate pki directory"
/opt/easyrsa/easyrsa init-pki

echo -e "\n$(date +'%F %T') > building CA"
/opt/easyrsa/easyrsa --batch build-ca nopass

echo -e "\n$(date +'%F %T') > building server certificate"
/opt/easyrsa/easyrsa --batch build-server-full "$OVPN_SERVER_NAME" nopass

echo -e "\n$(date +'%F %T') > generating Diffie-Hellman"
/opt/easyrsa/easyrsa gen-dh

echo -e "\n$(date +'%F %T') > generating TA.key"
openvpn --genkey --secret "$EASYRSA_PKI/ta.key"

echo -e "\n$(date +'%F %T') > generating CRL"
/opt/easyrsa/easyrsa gen-crl

echo -e "\n$(date +'%F %T') > creating /opt dir"
mkdir -p -v "/opt"

echo -e "\n$(date +'%F %T') > moving configuration files to ${OVPN_DIR}"
cp "${EASYRSA_PKI}/ca.crt" \
  "${EASYRSA_PKI}/crl.pem" \
  "${EASYRSA_PKI}/dh.pem" \
  "${EASYRSA_PKI}/ta.key" \
  "${EASYRSA_PKI}/issued/${OVPN_SERVER_NAME}.crt" \
  "${EASYRSA_PKI}/private/${OVPN_SERVER_NAME}.key" \
  "${OVPN_DIR}"

echo -e "\n$(date +"%F %T") > server certificate ready"
