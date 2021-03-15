FROM ubuntu:latest
COPY ./mysql-config.sh /
COPY ./start-wecross.sh /etc/init.d/
COPY ./start-wecross.sh /
COPY ./stop-wecross.sh /
COPY ./wecross-demo/ /wecross-demo/
COPY ./pages.tar.gz /wecross-demo/
RUN apt-get update && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apt-get install -y tzdata && \
    apt-get install -y vim git net-tools openssl lsof curl expect tree fontconfig openjdk-8-jdk mysql-server unzip && \
    service mysql start && \
    bash mysql-config.sh && \
    chmod 755 /etc/init.d/start-wecross.sh && \
    cd ./wecross-demo && \
    bash build_cross_gm.sh -H 127.0.0.1 -P 3306 -u root -p admin123456 && \
    cd /wecross-demo/routers-payment/127.0.0.1-8250-25500/ && \
    sed -i '0,/127.0.0.1/s/127.0.0.1/0.0.0.0/' ./conf/wecross.toml && \
    cd - && \
    cd ./WeCross-Account-Manager/conf && \
    sed -i 's/useSSL=false/useSSL=false\&allowPublicKeyRetrieval=true/' application.toml && \
    cd / && \
    bash stop-wecross.sh && \
    cd /wecross-demo && rm ./*.gz && rm -rf ./src && \
    apt-get autoremove && apt-get autoclean
CMD [ "sh", "-c", "service start-wecross.sh start;bash" ]

# curl -fsSL https://get.docker.com -o get-docker.sh && \
# sh get-docker.sh && \
# curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
# chmod +x /usr/local/bin/docker-compose