# WeCross-Container

A fast experience docker container builder for WeCross.

## 使用方法

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
