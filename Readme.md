### About
Sometimes you don't need to route all your traffic via OpenVPN connection on your host OS. You just want to have SOCKS5 proxy.
This repo can help you to convert OpenVPN connection to SOCKS5 server using Docker. OpenVPN connection works inside Docker container, so your host OS is not affected.

### Requirements
Install docker.io for your host OS.
### HowTo
1. Clone this repo:
```
# git clone https://github.com/iftsv/ubuntu-openvpn2socks5.git
```
2. OpenVPN configuration should be placed in the `client.conf` file and `pass.txt`. Example:
```
client
dev tun
proto udp
remote example-vpn.org 8080
auth-user-pass
remote-cert-tls server
nobind
auth-user-pass /etc/openvpn/pass.txt
<ca>
-----BEGIN CERTIFICATE-----
MIIB7DCCAXKgAwIBAgI ...
-----END CERTIFICATE-----
</ca>
```
3. Run Docker Compose for this service in detached mode. Setup your browser to connect via the SOCKS5 proxy using 127.0.0.1:8899
```
# sudo docker-compose up -d
```
