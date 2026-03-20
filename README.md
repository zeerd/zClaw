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
# 启动
mkdir -p /$HOME$/.openclaw/.linuxbrew
docker compose up -d
```

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

More [skills](https://github.com/zeerd/zClaw-Skills).

## Debug

```bash
docker compose exec openclaw-gateway bash
```
