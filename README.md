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

自带的飞书插件功能很弱，参照这份[文档](https://bytedance.feishu.cn/docx/MFK7dDFLFoVlOGxWCv5cTXKmnMh)更新插件。

## Debug

```bash
docker compose exec openclaw-gateway bash
```
