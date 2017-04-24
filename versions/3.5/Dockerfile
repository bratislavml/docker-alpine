#
# Base Alpine Linux image
#

FROM alpine:3.5
MAINTAINER Bandsintown Devops Team "devops@bandsintown.com"

ENV S6_OVERLAY_VERSION=1.19.1.1 GODNSMASQ_VERSION=1.0.7 CONSUL_TEMPLATE_VERSION=0.18.1 CONSUL_VERSION=0.7.5

# Install root filesystem
COPY rootfs /

# Install base packages
RUN apk update && apk upgrade && \
    apk-install curl wget bash tree jq bind-tools su-exec gettext && \
    chmod u+s /sbin/su-exec && \
    curl -Ls https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar -xz -C / && \
    curl -Ls https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -o consul-template.zip && unzip consul-template.zip -d /usr/local/bin && \
    curl -Ls https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -o consul.zip && unzip consul.zip -d /usr/local/bin && \
    curl -Ls https://github.com/janeczku/go-dnsmasq/releases/download/${GODNSMASQ_VERSION}/go-dnsmasq-min_linux-amd64 -o /usr/sbin/go-dnsmasq &&  \
    rm -f consul* && \
    chmod +x /usr/sbin/go-dnsmasq && \
    echo -ne "Alpine Linux 3.5 image. (`uname -rsv`)\n" >> /root/.built && \
    echo -ne "- with S6 Overlay: $S6_OVERLAY_VERSION, Go DNS Mask: $GODNSMASQ_VERSION, Consul Template: $CONSUL_TEMPLATE_VERSION, Consul: $CONSUL_VERSION\n" >> /root/.built

# Disable S6 logs on stdout/stderr
ENV S6_LOGGING=1

# Enable S6 as default entrypoint
ENTRYPOINT ["/init"]

# Define bash as default command
CMD ["bash"]
