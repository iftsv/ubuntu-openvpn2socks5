FROM ubuntu

WORKDIR /

RUN apt update && \
apt install nano openvpn iputils-ping net-tools curl dante-server -y && \
echo "logoutput: /var/log/sockd.log" > /etc/danted.conf  && \
echo "errorlog: syslog" >> /etc/danted.conf  && \
echo "user.privileged: root" >> /etc/danted.conf  && \
echo "user.unprivileged: nobody" >> /etc/danted.conf  && \
echo "internal: 0.0.0.0 port=8899" >> /etc/danted.conf  && \
echo "external: tun0" >> /etc/danted.conf  && \
echo "socksmethod: none" >> /etc/danted.conf  && \
echo "clientmethod: none" >> /etc/danted.conf  && \
echo "client pass {from: 0.0.0.0/0 to: 0.0.0.0/0}" >> /etc/danted.conf  && \
echo "socks pass {from: 0.0.0.0/0 to: 0.0.0.0/0}" >> /etc/danted.conf

EXPOSE 8899

CMD service openvpn start && sleep 10 && danted