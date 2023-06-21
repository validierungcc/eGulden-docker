#!/bin/bash

set -meuo pipefail

EGULDEN_DIR=/egulden/.egulden/
EGULDEN_CONF=/egulden/.egulden/coin.conf

if [ -z "${EGULDEN_RPCPASSWORD:-}" ]; then
  # Provide a random password.
  EGULDEN_RPCPASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo '')
fi

if [ ! -e "${EGULDEN_CONF}" ]; then
  tee -a >${EGULDEN_CONF} <<EOF
server=1
rpcuser=${EGULDEN_RPCUSER:-eguldenrpc}
rpcpassword=${EGULDEN_RPCPASSWORD}
rpcclienttimeout=${EGULDEN_RPCCLIENTTIMEOUT:-30}
EOF
echo "Created new configuration at ${EGULDEN_CONF}"
fi

if [ $# -eq 0 ]; then
  /usr/local/bin/eguldend -rpcbind=0.0.0.0 -rpcport=12341 -rpcallowip=0.0.0.0/0 -printtoconsole=1
else
  exec "$@"
fi
