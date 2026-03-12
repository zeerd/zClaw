FROM ghcr.io/openclaw/openclaw:2026.3.11-slim

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

USER root

RUN sed -i 's@deb.debian.org@mirrors.tuna.tsinghua.edu.cn@g' /etc/apt/sources.list.d/debian.sources
RUN apt-get update
RUN apt-get install -y openssh-client golang-go tmux vim ca-certificates
RUN update-ca-certificates

COPY .npmrc /home/node
RUN chown node:node /home/node/.npmrc

COPY .bash_aliases /home/node/.bash_aliases
RUN chown node:node /home/node/.bash_aliases

RUN --mount=type=cache,id=openclaw-bookworm-apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=openclaw-bookworm-apt-lists,target=/var/lib/apt,sharing=locked \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends xvfb && \
  mkdir -p /app/ms-playwright && \
  PLAYWRIGHT_BROWSERS_PATH=/app/ms-playwright  \
  node /app/node_modules/playwright-core/cli.js install --with-deps chromium && \
  chown -R node:node /app/ms-playwright

RUN bash -c "curl -fsSL https://skillhub-1251783334.cos.ap-guangzhou.myqcloud.com/install/install.sh"
RUN bash -c "curl -LsSf https://astral.sh/uv/install.sh"
RUN ln -sf node /home/linuxbrew

#RUN apt-get install -y sudo
#RUN echo "node:node" | chpasswd
#RUN usermod -aG sudo node

USER node
RUN bash -c "curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

HEALTHCHECK --interval=3m --timeout=10s --start-period=15s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:18789/healthz').then((r)=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"
CMD ["node", "openclaw.mjs", "gateway", "--allow-unconfigured"]
