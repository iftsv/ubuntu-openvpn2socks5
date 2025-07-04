### About
Sometimes you don't need to route all your traffic via OpenVPN connection on your host OS. You just want to have SOCKS5 proxy.
This repo can help you to "convert" OpenVPN connection to SOCKS5 server using Docker. OpenVPN connection works inside Docker container, so your host OS is not affected.

### Requirements
Install docker.io for your host OS.
### HowTo
1. Clone this repo:
```
git clone https://github.com/iftsv/ubuntu-openvpn2socks5.git
```
2. OpenVPN configuration should be placed in the `client.conf` file and `pass.txt` inside `your-openvpn-config` directory. See file examples inside.
3. Set `PROXY_USER`/`PROXY_PASS`/`HOST_SUBNET` variables in the `docker-compose.yml`. `HOST_SUBNET` is IP address of local network for host machine with docker container.
4. Run Docker Compose for this service in detached mode. Setup your browser to connect via the SOCKS5 proxy on IP:8899 using provided username/password from `docker-compose.yml` file.
```
sudo docker-compose up -d --build
```
5. Since the Docker container running the Dante proxy server will be accessible from outside the Docker host machine, don’t forget to set up a firewall. Here’s an example using iptables:
```
# accept requests for specific network
sudo iptables -I INPUT -p tcp -s 192.168.1.0/24 --dport 8899 -j ACCEPT

# drop requests from other networks
sudo iptables -A INPUT -p tcp --dport 8899 -j DROP

# save persistent
sudo netfilter-persistent save
```
