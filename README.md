# zClaw

Build custom docker image of [`OpenClaw`](https://github.com/openclaw/openclaw)  based on [`ghcr.io/openclaw/openclaw`](https://ghcr.io/openclaw/openclaw). With:

* chromium
* uv
* linuxbrew

```bash
# 准备
sudo apt install docker-buildx
# 构建
./build.sh
# 初始化
install -d $HOME$/.openclaw/.linuxbrew
install -d $HOME$/.openclaw/workspace
docker compose run openclaw-gateway openclaw onboard
docker compose run openclaw-gateway openclaw config set gateway.controlUi.dangerouslyAllowHostHeaderOriginFallback true
# 启动
docker compose up -d openclaw-gateway
```

使用浏览器链接`http://127.0.0.1:18789`，然后按下面操作：

```bash
# 登陆龙虾控制台
docker compose exec openclaw-gateway bash
# 执行命令：
openclaw gateway run
openclaw dashboard --no-open
```

控制台中会显示一个带`token`的链接，在浏览器中打开。然后，继续：

```bash
openclaw devices list
# 在列出的第一个表格中找到 Request ID
openclaw devices approve <Request ID>
```

刷新浏览器页面。

## Components

```bash
docker compose exec openclaw-gateway brew install Hyaxia/tap/blogwatcher
```

### 飞书

`Openclaw`自带的飞书插件功能很弱，参照这份官方[文档](https://bytedance.feishu.cn/docx/MFK7dDFLFoVlOGxWCv5cTXKmnMh)更新插件。

### pip

`Tools`/`Skills`需要运行`Python`脚本的话，安如下方式安装和定位依赖包。

```bash
python3 -m venv ~/.openclaw/workspace/.venv
source ~/.openclaw/workspace/.venv/bin/activate
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

修改`Python`脚本，将第一行改成`#!/home/node/.openclaw/workspace/.venv/bin/python`。

### skills

More skills by [zClaw-Skills](https://github.com/zeerd/zClaw-Skills).

## Debug

```bash
docker compose exec openclaw-gateway bash
```
