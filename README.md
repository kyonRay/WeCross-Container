# WeCross-Container

A fast experience docker container builder for WeCross.

## 使用方法

### 使用前提

首先，需要生成Fabric 1.4.4的物料放置到对应文件夹中。这些物料可以使用Fabric v1.4.4的`first-network`生成。

在`channel-artifacts`中放置以下文件：

```shell
tree fabric-network/channel-artifacts 
fabric-network/channel-artifacts
├── Org1MSPanchors.tx
├── Org2MSPanchors.tx
├── channel.tx
└── genesis.block
```

在`crypto-config`中放置以下文件：

```shell
tree fabric-network/crypto-config -L 3
fabric-network/crypto-config
├── ordererOrganizations
│   └── example.com
│       ├── ca
│       ├── msp
│       ├── orderers
│       ├── tlsca
│       └── users
└── peerOrganizations
    ├── org1.example.com
    │   ├── ca
    │   ├── msp
    │   ├── peers
    │   ├── tlsca
    │   └── users
    └── org2.example.com
        ├── ca
        ├── msp
        ├── peers
        ├── tlsca
        └── users
```

### 命令行

```bash
git clone https://github.com/kyonRay/WeCross-Container
cd WeCross-Container
bash build.sh
# build.sh  脚本执行时间较长，请耐心等待...

```

如果执行步骤中出现错误，请手动执行以下命令，清空所有容器。

```bash
# for clean all service
bash clear.sh
```

### 浏览器

浏览器输入 http://127.0.0.1:8260/wecross/s/index.html 即可，have fun! :)
IP和端口号视部署实际情况而定，端口号可修改`./docker-compose.yml`文件。
