FROM ubuntu:noble
LABEL maintainer="delyachmad@gmail.com"
#WORKDIR /root

RUN apt-get update \
	&& apt-get -y upgrade \
	&& apt-get -y install nano less iputils-ping iproute2 openvpn wget htop net-tools iptables iptables-persistent easy-rsa curl traceroute


ENV OVPN_DIR="/opt/openvpn" \
	OVPN_SERVER_NAME="server" \
	OVPN_SERVER_NETWORK="192.69.1.0 255.255.255.0" \
	OVPN_SERVER_IPV4="192.69.1.1 255.255.255.0" \
	OVPN_SERVER_DNS="8.8.8.8" \
	OVPN_SERVER_CIPHER="AES-256-CBC"\
	OVPN_SERVER_AUTH="SHA256"\
	OVPN_SERVER_USETLS="true"\
	OVPN_SERVER_AS_GATEWAY="false" \
	OVPN_SERVER_MANAGEMENT="disabled" \
	OVPN_CLIENT_NAME="ovpnclient" \
	OVPN_CLIENT_PASS="nopass"

ENV OVPN_CLIENT_DIR="${OVPN_DIR}/client"

ENV	OVPN_CLIENT_CCD="${OVPN_CLIENT_DIR}/config" \
	OVPN_PROTOCOL="tcp" \
	OVPN_REMOTE_ADDRESS="192.168.1.1" \
	OVPN_REMOTE_PORT="1149" \
	OVPN_CLIENT_UNIQUE="false" \
	OVPN_CLIENT_COMPRESS="true" \
	OVPN_CLIENT_MODE="onlycert" 

ENV EASYRSA_REQ_COUNTRY="ID" \
	EASYRSA_REQ_PROVINCE="Jawa Timur" \
	EASYRSA_REQ_CITY="Surabaya" \
	EASYRSA_REQ_ORG="AkTro" \
	EASYRSA_REQ_EMAIL="personal@gmail.com" \
	EASYRSA_REQ_OU="Invis Personal Unit"  \
	EASYRSA_PKI="/opt/easyrsa/pki"

WORKDIR /opt

RUN cp -Rv /usr/share/easy-rsa /opt/easyrsa

# RUN wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.1.1/EasyRSA-3.1.1.tgz\
# 	&& tar xvf EasyRSA-3.1.1.tgz \
# 	&& mv -v EasyRSA-3.1.1 "/opt/easyrsa" \
# 	&& rm EasyRSA-3.1.1.tgz

# RUN THIS TO FIX EASYRSA bug on EasyRSA-3.1.1
# read more at https://github.com/OpenVPN/easy-rsa/issues/725
# RUN wget https://github.com/OpenVPN/easy-rsa/raw/master/easyrsa3/easyrsa -O "/opt/easyrsa/easyrsa"

COPY shells/*.sh ./
COPY shells/helper/*.sh ./helper/

RUN chmod +x *.sh

EXPOSE 1194/udp
EXPOSE 1149/tcp

VOLUME [ "$OVPN_DIR" ]

ENTRYPOINT ["./init-openvpn.sh"]

CMD ["bash"]



#TODO : complete this
