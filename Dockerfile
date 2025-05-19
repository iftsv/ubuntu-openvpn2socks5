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
    echo "  log: connect disconnect error" >> /etc/danted.conf && \
    echo "}" >> /etc/danted.conf

# CMD runs at container startup — dynamic user creation happens here
CMD /bin/sh -c "\
    if ! id \"$PROXY_USER\" >/dev/null 2>&1; then \
        echo \"[INFO] Creating proxy user: $PROXY_USER\"; \
        useradd -m -s /bin/bash \"$PROXY_USER\" && \
        echo \"$PROXY_USER:$PROXY_PASS\" | chpasswd; \
    fi; \
    openvpn --config /etc/openvpn/client.conf --auth-user-pass /etc/openvpn/pass.txt & \
    sleep 15 && danted"

EXPOSE 8899
