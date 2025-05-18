#!/bin/bash

# if user doesn't exist, create them
if ! id "$PROXY_USER" &>/dev/null; then
    echo "[INFO] Creating proxy user: $PROXY_USER"
    useradd -m -s /bin/bash "$PROXY_USER"
    echo "$PROXY_USER:$PROXY_PASS" | chpasswd
fi

echo "[INFO] Starting OpenVPN and Dante..."
service openvpn start
sleep 10
exec danted -f /etc/danted.conf -D
