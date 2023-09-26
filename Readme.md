#### HowTo
1. Prepare client.conf file with OpenVPN client configuration. If OpenVPN server requires  user/passwrod authentication, put pass.txt file with these credentials.
2. Clone this repo
```
# git clone ...
```
3. Build image
```
# docker build -t ubuntu-openvpn2socks5 .
```
4. Run image. ATTENTION! Update the `src` path for the `--mount` flag according to your local path.
```
# docker run --device=/dev/net/tun -d --rm --mount type=bind,src=D:\docker\ubuntu-openvpn2socks5,target=/etc/openvpn/ -p 8899:8899 --cap-add=NET_ADMIN ubuntu-openvpn2socks5
```
