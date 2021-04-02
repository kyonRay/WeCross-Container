# /bin/bash

ROOT=/wecross-demo

config_router_fabric() {
    router_dir=${1}
    fabric_demo_dir=${2}

    cd ${router_dir}
    # stubs
    bash add_chain.sh -t Fabric1.4 -n fabric-mychannel -d conf/chains
    cp ${fabric_demo_dir}/chains/fabric/* conf/chains/fabric-mychannel/

    cp ${ROOT}/fabric_stub.toml ./conf/chains/fabric-mychannel/stub.toml

    # fabric stub internal accounts
    bash add_account.sh -t Fabric1.4 -n fabric_admin -d conf/accounts
    cp ${fabric_demo_dir}/accounts/fabric_admin/* conf/accounts/fabric_admin/
    bash add_account.sh -t Fabric1.4 -n fabric_admin_org1 -d conf/accounts
    cp ${fabric_demo_dir}/accounts/fabric_admin_org1/* conf/accounts/fabric_admin_org1/
    bash add_account.sh -t Fabric1.4 -n fabric_admin_org2 -d conf/accounts
    cp ${fabric_demo_dir}/accounts/fabric_admin_org2/* conf/accounts/fabric_admin_org2/
    sed -i 's/Org1MSP/Org2MSP/g' conf/accounts/fabric_admin_org2/account.toml

    # deploy system chaincodes
    bash deploy_system_contract.sh -t Fabric1.4 -c chains/fabric-mychannel -P
    bash deploy_system_contract.sh -t Fabric1.4 -c chains/fabric-mychannel -H

    cd -
}

add_fabric_account() {
    local name=${1}
    local mspid=${2}

    # addChainAccount
    cd ${ROOT}/WeCross-Console/
    bash start.sh <<EOF
login
addChainAccount Fabric1.4 conf/accounts/${name}/account.crt conf/accounts/${name}/account.key ${mspid} true
quit
EOF
    cd -
}

deploy_chain_account() {
    cp -r /fabric_certs/accounts/* ${ROOT}/WeCross-Console/conf/accounts/

    add_fabric_account fabric_admin_org1 Org1MSP # 1
    add_fabric_account fabric_admin_org2 Org2MSP # 2
    add_fabric_account fabric_user1 Org1MSP      # 3
}

deploy_fabric_sample_resource() {
    cd ${ROOT}/WeCross-Console/

    bash start.sh <<EOF
login
setDefaultAccount Fabric1.4 3
login
fabricInstall payment.fabric-mychannel.sacc Org2 contracts/chaincode/sacc 1.0 GO_LANG
setDefaultAccount Fabric1.4 2
login
fabricInstall payment.fabric-mychannel.sacc Org1 contracts/chaincode/sacc 1.0 GO_LANG
fabricInstantiate payment.fabric-mychannel.sacc ["Org1","Org2"] contracts/chaincode/sacc 1.0 GO_LANG policy.yaml ["a","10"]
quit
EOF
    # wait the chaincode instantiate
    echo -e "\033[32msacc chaincode is instantiating ...\033[0m\c"
    sleep 60
    cd -
}

cd ${ROOT}/routers-payment/127.0.0.1-8250-25500
bash stop.sh
cd -

# config fabric chain
config_router_fabric /wecross-demo/routers-payment/127.0.0.1-8250-25500 /fabric_certs

cd ${ROOT}/routers-payment/127.0.0.1-8250-25500
cp /wecross-demo/wecross.toml ./conf/wecross.toml
bash stop.sh && bash start.sh
cd -

cd ${ROOT}/WeCross-Console
cp /wecross-demo/console.toml ./conf/application.toml
cd -

# add chain account to org1-admin
deploy_chain_account

# deploy sacc
deploy_fabric_sample_resource

