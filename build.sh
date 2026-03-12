VER=$(cat .version)


ENV_FILE=".env-1"
if [ ! -f $ENV_FILE ] ; then
	OPENCLAW_GATEWAY_TOKEN="$(openssl rand -hex 32)"

	echo "OPENCLAW_IMAGE=zclaw:2026.3.11-0.1" >> $ENV_FILE
	echo "OPENCLAW_CONFIG_DIR=$HOME/.openclaw" >> $ENV_FILE
	echo "OPENCLAW_WORKSPACE_DIR=$HOME/.openclaw/workspace" >> $ENV_FILE
	echo "OPENCLAW_BREW_DIR=$HOME/.openclaw/.linuxbrew" >> $ENV_FILE
	echo "OPENCLAW_GATEWAY_PORT=18789" >> $ENV_FILE
	echo "OPENCLAW_BRIDGE_PORT=18790" >> $ENV_FILE
	echo "OPENCLAW_GATEWAY_BIND=lan" >> $ENV_FILE
	echo "OPENCLAW_GATEWAY_TOKEN=$OPENCLAW_GATEWAY_TOKEN" >> $ENV_FILE
fi

docker build -t zclaw:2026.3.11-$VER .

