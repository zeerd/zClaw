ARG OPENCLAW_DOCKER_IMAGE=""
FROM ${OPENCLAW_DOCKER_IMAGE:-ghcr.io/openclaw/openclaw:main-slim}

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

USER root

RUN sed -i 's@deb.debian.org@mirrors.tuna.tsinghua.edu.cn@g' /etc/apt/sources.list.d/debian.sources
RUN apt-get update
RUN apt-get install -y --no-install-recommends python3 python3-pip python3-venv wget curl
RUN apt-get install -y --no-install-recommends openssh-client golang-go tmux vim ca-certificates
RUN update-ca-certificates

COPY --chown=node:node .npmrc /home/node

COPY --chown=node:node .bash_aliases /home/node/.bash_aliases

RUN --mount=type=cache,id=openclaw-bookworm-apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=openclaw-bookworm-apt-lists,target=/var/lib/apt,sharing=locked \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends xvfb && \
  mkdir -p /app/ms-playwright && \
  PLAYWRIGHT_BROWSERS_PATH=/app/ms-playwright  \
  node /app/node_modules/playwright-core/cli.js install --with-deps chromium && \
  chown -R node:node /app/ms-playwright

#RUN curl -fsSL https://skillhub-1251783334.cos.ap-guangzhou.myqcloud.com/install/install.sh | bash
RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/opt/uv/bin" sh
RUN ln -sf node /home/linuxbrew
COPY --chown=node:node cmd.sh /app/cmd.sh
RUN chmod +x /app/cmd.sh

# 如果期望龙虾有更高的权限
ARG OPENCLAW_DOCKER_SUDO=""
RUN if [ -n "$OPENCLAW_DOCKER_SUDO" ]; then \
      apt-get install -y sudo && (echo "node:node" | chpasswd) && usermod -aG sudo node; \
    fi

# 为 HomeBrew 准备安装环境
RUN mkdir -p /opt/linuxbrew && chown node:node /opt/linuxbrew
# 很多第三方技能、工具还是会去/home/node/.cache/ms-playwright目录下找浏览器，所以这里做个软链接
RUN install -d /home/node/.cache && ln -sf /app/ms-playwright /home/node/.cache/ms-playwright
# 防止意外发生，这里再次修改权限，确保node用户对/home/node/.cache目录有读写权限
RUN chown node:node /home/node/.cache

# HomeBrew 必须用非 root 用户安装，而且必须安装在 /home/linuxbrew 目录下
# 这与持久化冲突，因此，安装之后要临时迁移到/opt/linuxbrew目录下
# 首次持久化成功之后再迁移回/home/linuxbrew目录下
USER node
RUN curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash && \
    mv /home/linuxbrew/.linuxbrew /opt/linuxbrew

RUN git clone https://github.com/zeerd/zClaw-Skills /app/extensions/zclaw-skills/ && \
    cd /app/extensions/zclaw-skills/ && \
    npm install

HEALTHCHECK --interval=3m --timeout=10s --start-period=15s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:18789/healthz').then((r)=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"
CMD ["/app/cmd.sh"]
