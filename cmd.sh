#!/bin/bash
BREW_DIR="/home/linuxbrew/.linuxbrew"
INIT_DIR="/opt/linuxbrew/.linuxbrew"

if [ -z "$(ls -A "$BREW_DIR")" ]; then
    echo "Brew目录为空，正在初始化..."
    cp -a "$INIT_DIR/." "$BREW_DIR/"
    chown -R node:node "$BREW_DIR"
fi

node dist/index.js gateway --bind "${OPENCLAW_GATEWAY_BIND:-lan}" --port "18789"
