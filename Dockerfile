FROM debian:bookworm-slim

LABEL maintainer="lll9p <lll9p.china@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive
ARG ARCH=$(uname -m | sed 's/x86_64/64/; s/aarch64/arm64-v8a/')

WORKDIR /root

RUN set -eux; \
    apt-get update ; \
    apt-get install -y tzdata gnupg curl unzip ; \
    apt-get update && apt-get install -y cloudflare-warp ; \
    apt-get autoclean; rm -rf /var/lib/apt/lists/* ; \
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-${ARCH}.zip"; \
    curl -L "https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-${ARCH}.zip" > xray.zip; \
    mkdir /root/xray; \
    mv xray.zip /root/xray ; \
    cd /root/xray && unzip xray.zip ; \
    mkdir -p /usr/local/share/xray ; \
    mkdir -p /etc/xray ; \
    mv /root/xray/xray /usr/local/bin/xray ; \
    mv /root/xray/geoip.dat /usr/local/share/xray/geoip.dat ; \
    mv /root/xray/geosite.dat /usr/local/share/xray/geosite.dat ; \
    chmod +x /usr/local/bin/xray ; \
    rm -rf /root/xray

ARG TZ=Asia/Shanghai
ENV TZ=$TZ

VOLUME /usr/local/etc/xray
VOLUME /var/log/xray

ENTRYPOINT [ "/usr/local/bin/xray" ]
CMD [ "-confdir", "/usr/local/etc/xray/" ]
