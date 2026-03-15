VER=$(cat .version)


ENV_FILE=".env"
if [ -f "$ENV_FILE" ]; then
	# 读取OPENCLAW_GATEWAY_TOKEN
	OPENCLAW_GATEWAY_TOKEN=$(grep '^OPENCLAW_GATEWAY_TOKEN=' "$ENV_FILE" | cut -d'=' -f2-)
else
	OPENCLAW_GATEWAY_TOKEN="$(openssl rand -hex 32)"
fi

echo -n "" > "$ENV_FILE"
echo "OPENCLAW_IMAGE=zclaw:$VER" >> "$ENV_FILE"
echo "OPENCLAW_CONFIG_DIR=$HOME/.openclaw" >> "$ENV_FILE"
echo "OPENCLAW_WORKSPACE_DIR=$HOME/.openclaw/workspace" >> "$ENV_FILE"
echo "OPENCLAW_BREW_DIR=$HOME/.openclaw/.linuxbrew" >> "$ENV_FILE"
echo "OPENCLAW_GATEWAY_PORT=18789" >> "$ENV_FILE"
echo "OPENCLAW_BRIDGE_PORT=18790" >> "$ENV_FILE"
echo "OPENCLAW_GATEWAY_BIND=lan" >> "$ENV_FILE"
echo "OPENCLAW_GATEWAY_TOKEN=$OPENCLAW_GATEWAY_TOKEN" >> "$ENV_FILE"

docker build --build-arg OPENCLAW_DOCKER_IMAGE=ghcr.io/openclaw/openclaw:$VER -t zclaw:$VER .
