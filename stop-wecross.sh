#/bin/bash

WECROSS_DEMO=/wecross-demo/

cd ${WECROSS_DEMO}/routers-payment/127.0.0.1-8250-25500
bash stop.sh
cd -

cd ${WECROSS_DEMO}/routers-payment/127.0.0.1-8251-25501
bash stop.sh
cd -

cd ${WECROSS_DEMO}/WeCross-Account-Manager
bash stop.sh
cd -

cd ${WECROSS_DEMO}/bcos/nodes/127.0.0.1/
bash stop_all.sh
cd -
cd ${WECROSS_DEMO}/bcos/nodes_gm/127.0.0.1/
bash stop_all.sh
cd -