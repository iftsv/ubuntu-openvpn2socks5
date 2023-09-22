FROM ubuntu

WORKDIR /

RUN apt update && \
apt install nano openvpn iputils-ping net-tools curl dante-server -y && \
cat > /etc/danted.conf <<EOL
logoutput: /var/log/sockd.log
errorlog: syslog
user.privileged: root
user.unprivileged: nobody
internal: 0.0.0.0 port=8899
external: tun0
socksmethod: none
clientmethod: none

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
}

socks pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
}
EOL

EXPOSE 8899

CMD service openvpn start && sleep 10 && danted