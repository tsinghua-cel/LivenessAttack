#!/bin/sh
set -e

echo "beacon node with MAXPeers=${MAXPEERS} allpeer=${ALLPEERS} and EXECUTE=$EXECUTE, p2pkey=${P2PKEY}"

ALLPEERS=""

# POSIX shell
for peer_service in $(echo "$PEER_SERVICES" | sed 's/,/ /g'); do
  echo "Waiting for $peer_service to be available..."
  while ! getent hosts "$peer_service"; do
    sleep 1
  done
  PEER_IP=$(getent hosts "$peer_service" | awk '{ print $1 }')
  peerid_var_name="PEERID_${peer_service}"
  peerid_value=$(printenv "$peerid_var_name" || true)
  echo "peerid_var_name=$peerid_var_name, peerid_value=$peerid_value"

  ALLPEERS="$ALLPEERS --peer /ip4/$PEER_IP/tcp/13000/p2p/$peerid_value"
  echo "Resolved $peer_service to $PEER_IP"
done


FRIENDS=""

# POSIX shell
for friends_service in $(echo "$FRIENDS_SERVICES" | sed 's/,/ /g'); do
  peerid_var_name="PEERID_${friends_service}"
  peerid_value=$(printenv "$peerid_var_name" || true)

  FRIENDS="${FRIENDS}:${peerid_value}"
done


if [ "$BOOT_DELAY" != "" ] &&  [ "$BOOT_DELAY" != "0" ];then
      sleep $BOOT_DELAY
fi

export PEER_FRIENDS="${FRIENDS}"

sleep 5 && /usr/bin/beacon-chain \
        --datadir=/root/beacondata \
        --min-sync-peers=0 \
        --genesis-state=/root/config/genesis.ssz \
        --bootstrap-node "${BOOTNODE}"\
        --interop-eth1data-votes \
        --chain-config-file=/root/config/config.yml \
        --p2p-max-peers=${MAXPEERS} \
        --p2p-priv-hex=${P2PKEY} \
        --contract-deployment-block=0 \
        --chain-id=${CHAIN_ID:-32382} \
        --rpc-host=0.0.0.0 \
        --grpc-gateway-host=0.0.0.0 \
        --execution-endpoint=http://${EXECUTE}:8551 \
        --accept-terms-of-use \
        --p2p-static-id=true \
        --jwt-secret=/root/config/jwtsecret \
        --suggested-fee-recipient=0x123463a4b065722e99115d6c222f267d9cabb524 \
        --minimum-peers-per-subnet=0 \
        --enable-debug-rpc-endpoints \
	--verbosity=info \
        ${ALLPEERS} >> /root/beacondata/d.log 2>&1
