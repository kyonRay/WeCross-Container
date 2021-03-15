#!/bin/bash
byfn_dir=fabric-network
if [ -d ${byfn_dir} ]; then
    cd ${byfn_dir}
    bash byfn.sh down <<EOF
Y
EOF
    cd -
fi

rm -rf certs
