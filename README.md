# WeCross-Container

A fast experience docker container builder for WeCross.

## Usage

### command line

```bash
git clone https://github.com/kyonRay/WeCross-Container
cd WeCross-Container
docker-compose up -d
# long building...

```

if you have access issue, maybe the container service did not running, try run it manually.

```bash
docker exec -it wecross-demo bash

# it will look like:
>root@wecross:/

bash start-wecross.sh

# waiting... done :)
```

### Browser

Put URL http://127.0.0.1:8265/wecross/index.html in browser, have fun! :)
