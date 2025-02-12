FROM debian:bookworm-slim

LABEL maintainer="lll9p <lll9p.china@gmail.com>"

ENV TZ Asia/Shanghai
ARG DEBIAN_FRONTEND=noninteractive
ARG XRAY_VERSION=25.1.30

WORKDIR /root

RUN set -eux; \
    apt-get update ; \
    apt-get install -y tzdata gnupg curl unzip ; \
    curl https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg ; \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ bookworm main" >> /etc/apt/sources.list.d/cloudflare-client.list ; \
    apt-get update && apt-get install -y cloudflare-warp ; \
    apt-get autoclean; rm -rf /var/lib/apt/lists/* ; \
    curl -L https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip > Xray-linux-64.zip; \
    mkdir /root/xray; \
    mv Xray-linux-64.zip /root/xray ; \
    cd /root/xray && unzip Xray-linux-64.zip ; \
    mkdir -p /usr/local/share/xray ; \
    mkdir -p /etc/xray ; \
    mv /root/xray/xray /usr/local/bin/xray ; \
    mv /root/xray/geoip.dat /usr/local/share/xray/geoip.dat ; \
    mv /root/xray/geosite.dat /usr/local/share/xray/geosite.dat ; \
    chmod +x /usr/local/bin/xray ; \
    rm -rf /root/xray

VOLUME /etc/xray
CMD [ "/usr/bin/xray", "-config", "/etc/xray/config.json" ]
