FROM ubuntu

WORKDIR /

# installation of required apps
RUN apt update && \
    apt install -y nano openvpn iputils-ping net-tools curl dante-server && \
    apt clean

# environment variables for proxy username & password
ENV PROXY_USER=proxyuser
ENV PROXY_PASS=proxypass

# openvpn & danted proxy configuration
RUN echo "logoutput: /var/log/sockd.log" > /etc/danted.conf && \
    echo "user.privileged: root" >> /etc/danted.conf && \
    echo "user.unprivileged: nobody" >> /etc/danted.conf && \
    echo "internal: 0.0.0.0 port = 8899" >> /etc/danted.conf && \
    echo "external: tun0" >> /etc/danted.conf && \
    echo "socksmethod: username" >> /etc/danted.conf && \
    echo "clientmethod: none" >> /etc/danted.conf && \
    echo "client pass { from: 0.0.0.0/0 to: 0.0.0.0/0 }" >> /etc/danted.conf && \
    echo "socks pass {" >> /etc/danted.conf && \
    echo "  from: 0.0.0.0/0 to: 0.0.0.0/0" >> /etc/danted.conf && \
    echo "  method: username" >> /etc/danted.conf && \
    echo "  log: connect disconnect error" >> /etc/danted.conf && \
    echo "}" >> /etc/danted.conf

# start script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8899

ENTRYPOINT ["/entrypoint.sh"]
