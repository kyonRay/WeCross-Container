#/bin/bash

WECROSS_DEMO=/wecross-demo/

service mysql start

cd ${WECROSS_DEMO}/bcos/nodes/127.0.0.1/
bash start_all.sh
cd -
cd ${WECROSS_DEMO}/bcos/nodes_gm/127.0.0.1/
bash start_all.sh
cd -

cd ${WECROSS_DEMO}/WeCross-Account-Manager
bash start.sh
cd -

cd ${WECROSS_DEMO}/routers-payment/127.0.0.1-8250-25500
bash start.sh
cd -

cd ${WECROSS_DEMO}/routers-payment/127.0.0.1-8251-25501
bash start.sh
cd -
