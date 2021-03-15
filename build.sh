#!/bin/bash
set -e
LANG=en_US.UTF-8
LOG_INFO() {
    local content=${1}
    echo -e "\033[32m[INFO][Fabric] ${content}\033[0m"
}

LOG_ERROR() {
    local content=${1}
    echo -e "\033[31m[ERROR][Fabric] ${content}\033[0m"
}

Download() {
    local url=${1}
    local file=$(basename ${url})
    if [ ! -e ${file} ]; then
        curl -#LO ${url}
    fi
}

Download_IMG() {
    local name=${1}
    local tag=${2}

    if [ -z "$(docker images | grep ${name} | grep ${tag})" ]; then
        docker pull ${name}:${tag}
        docker tag ${name}:${tag} ${name}:latest
    fi
}

check_docker_service() {
    set +e
    if ! docker ps >/dev/null; then
        LOG_INFO "Please install docker and add your user by:"
        LOG_INFO "        sudo gpasswd -a ${USER} docker && su ${USER}"
        exit 1
    fi
    set -e
}

check_docker_service

LOG_INFO "Pull fabric images ..."
Download_IMG hyperledger/fabric-ca 1.4.4
Download_IMG hyperledger/fabric-ccenv 1.4.4
Download_IMG hyperledger/fabric-javaenv 1.4.4
Download_IMG hyperledger/fabric-orderer 1.4.4
Download_IMG hyperledger/fabric-peer 1.4.4
Download_IMG hyperledger/fabric-tools 1.4.4

# Dump cert files
# copy cert
certs_dir=certs
fabric_stub_dir=${certs_dir}/chains/fabric
fabric_admin_dir=${certs_dir}/accounts/fabric_admin
fabric_user_dir=${certs_dir}/accounts/fabric_user1
fabric_admin_org1_dir=${certs_dir}/accounts/fabric_admin_org1
fabric_admin_org2_dir=${certs_dir}/accounts/fabric_admin_org2

fabric_verifiers_dir=${certs_dir}/verifiers
fabric_verifiers_org1CA_dir=${certs_dir}/verifiers/org1CA
fabric_verifiers_org2CA_dir=${certs_dir}/verifiers/org2CA
fabric_verifiers_ordererCA_dir=${certs_dir}/verifiers/ordererCA

mkdir -p ${certs_dir} ${fabric_admin_dir} ${fabric_user_dir} ${fabric_stub_dir} ${fabric_admin_org1_dir} ${fabric_admin_org2_dir} \
${fabric_verifiers_dir} ${fabric_verifiers_org1CA_dir} ${fabric_verifiers_org2CA_dir} ${fabric_verifiers_ordererCA_dir}

crypto_dir=fabric-network/crypto-config/
cp ${crypto_dir}/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/*_sk ${fabric_admin_dir}/account.key
cp ${crypto_dir}/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem ${fabric_admin_dir}/account.crt

cp ${crypto_dir}/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/keystore/*_sk ${fabric_user_dir}/account.key
cp ${crypto_dir}/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/signcerts/User1@org1.example.com-cert.pem ${fabric_user_dir}/account.crt

cp ${crypto_dir}/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem ${fabric_stub_dir}/orderer-tlsca.crt
cp ${crypto_dir}/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt ${fabric_stub_dir}/org1-tlsca.crt
cp ${crypto_dir}/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt ${fabric_stub_dir}/org2-tlsca.crt

cp ${crypto_dir}/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/*_sk ${fabric_admin_org1_dir}/account.key
cp ${crypto_dir}/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem ${fabric_admin_org1_dir}/account.crt

cp ${crypto_dir}/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/*_sk ${fabric_admin_org2_dir}/account.key
cp ${crypto_dir}/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/Admin@org2.example.com-cert.pem ${fabric_admin_org2_dir}/account.crt

cp ${crypto_dir}/peerOrganizations/org1.example.com/ca/ca.org1.example.com-cert.pem ${fabric_verifiers_org1CA_dir}/ca.org1.example.com-cert.pem
cp ${crypto_dir}/peerOrganizations/org2.example.com/ca/ca.org2.example.com-cert.pem ${fabric_verifiers_org2CA_dir}/ca.org2.example.com-cert.pem
cp ${crypto_dir}/ordererOrganizations/example.com/ca/ca.example.com-cert.pem ${fabric_verifiers_ordererCA_dir}/ca.example.com-cert.pem

# Startup
LOG_INFO "Startup fabric-network"
cd ./fabric-network
bash byfn.sh up -n
cd -

docker exec wecross-demo bash /wecross-demo/join-fabric.sh

LOG_INFO "SUCCESS: Build Fabric demo finish."
