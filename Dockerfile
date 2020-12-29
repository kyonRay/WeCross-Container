FROM ubuntu:latest
COPY ./mysql-config.sh /
COPY ./start-wecross.sh /
COPY ./wecross-nginx.conf /
RUN apt-get update && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apt-get install -y tzdata && \
    apt-get install -y openssl lsof curl expect tree fontconfig openjdk-8-jdk mysql-server nginx && \
    service mysql start && \
    bash mysql-config.sh && \
    service nginx start && \
    cp ./wecross-nginx.conf /etc/nginx/conf.d/wecross-nginx.conf && \
    nginx -s reload -c /etc/nginx/nginx.conf && \
    curl -LO https://github.com/WeBankBlockchain/WeCross/releases/download/resources/download_demo.sh && \
    bash download_demo.sh && \
    cd ./wecross-demo && \
    export CI_DB_PASSWORD=admin123456 && \
    bash build_cross_gm.sh n && \
    cd /wecross-demo/routers-payment/127.0.0.1-8250-25500/ && \
    sed -i '0,/127.0.0.1/s/127.0.0.1/0.0.0.0/' ./conf/wecross.toml && \
    cd -

# curl -fsSL https://get.docker.com -o get-docker.sh && \
# sh get-docker.sh && \
# curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
# chmod +x /usr/local/bin/docker-compose