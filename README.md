# zClaw

Build custom docker image of [`OpenClaw`](https://github.com/openclaw/openclaw)  based on [`ghcr.io/openclaw/openclaw`](https://ghcr.io/openclaw/openclaw). With:

* chromium
* uv
* linuxbrew
* skillhub

```bash
sudo apt install docker-buildx
./build.sh
docker compose up -d
```

## Debug

```bash
docker compose exec openclaw-gateway bash
```
