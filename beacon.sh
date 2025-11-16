#!/bin/sh
set -e

echo "beacon node with MAXPeers=${MAXPEERS} allpeer=${ALLPEERS} and EXECUTE=$EXECUTE, p2pkey=${P2PKEY}"


# Wait for services to be available and resolve IPs
ALLPEERS=""
# Old versions of sh may not have IFS
# IFS=','
for peer_service in $(echo $PEER_SERVICES | sed "s/,/ /g"); do
  echo "Waiting for $peer_service to be available..."
  while ! getent hosts $peer_service; do
    sleep 1
  done
  PEER_IP=$(getent hosts $peer_service | awk '{ print $1 }')
  # Assuming the p2p key is what is needed for the peer ID.
  # The format /p2p/<p2p-key> is a guess based on libp2p conventions.
  # You may need to adjust this based on what the beacon-node expects.
  # I am also assuming a default port of 13000 for p2p communication.
  peerid_var_name=$(echo PEERID_$(echo $peer_service))
  peerid_value=${printenv $peerid_var_name}

  ALLPEERS="$ALLPEERS --peer /ip4/$PEER_IP/tcp/13000/p2p/$peerid_value"
  echo "Resolved $peer_service to $PEER_IP"
done


if [ "$BOOT_DELAY" != "" ] &&  [ "$BOOT_DELAY" != "0" ];then
      sleep $BOOT_DELAY
fi


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
	--verbosity=debug \
        ${ALLPEERS} >> /root/beacondata/d.log 2>&1