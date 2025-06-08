#!/bin/sh

set -e

echo "[INFO] Entrypoint started"

if ! id "$PROXY_USER" >/dev/null 2>&1; then
  echo "[INFO] Creating proxy user: $PROXY_USER"
  useradd -m -s /bin/bash "$PROXY_USER"
  echo "$PROXY_USER:$PROXY_PASS" | chpasswd
fi

GW=$(ip route | awk '/default/ {print $3}')
if [ -z "$GW" ]; then
  echo "[ERROR] Default gateway not found"
  exit 1
fi
echo "[INFO] Docker gateway: $GW"

echo "[INFO] Adding route to $HOST_SUBNET via $GW"
ip route add "$HOST_SUBNET" via "$GW" dev eth0 || echo "[INFO] Route may already exist"

echo "[INFO] Starting OpenVPN..."
openvpn --config /etc/openvpn/client.conf --auth-user-pass /etc/openvpn/pass.txt &

echo "[INFO] Waiting for tun0..."
while [ ! -d /sys/class/net/tun0 ]; do
  sleep 1
done

echo "[INFO] tun0 is up, starting Dante"
exec danted
