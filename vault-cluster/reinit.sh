#!/bin/bash

# Re-initialize the Vault cluster
# This script stops the cluster, wipes all data, and starts fresh

set -e

echo "⚠️  This will destroy all Vault data and re-initialize the cluster!"
read -p "Are you sure? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "🛑 Stopping the cluster..."
docker compose down

echo ""
echo "🗑️  Removing data directories..."
rm -rf data/node1/* data/node2/* data/node3/*

echo ""
echo "🚀 Starting the cluster..."
docker compose up -d

echo ""
echo "⏳ Waiting for Vault to start..."
sleep 3

echo ""
echo "🔐 Initializing Vault..."
INIT_OUTPUT=$(docker exec vault1 vault operator init -format=json)

# Extract keys and token
UNSEAL_KEY_1=$(echo "$INIT_OUTPUT" | jq -r '.unseal_keys_b64[0]')
UNSEAL_KEY_2=$(echo "$INIT_OUTPUT" | jq -r '.unseal_keys_b64[1]')
UNSEAL_KEY_3=$(echo "$INIT_OUTPUT" | jq -r '.unseal_keys_b64[2]')
UNSEAL_KEY_4=$(echo "$INIT_OUTPUT" | jq -r '.unseal_keys_b64[3]')
UNSEAL_KEY_5=$(echo "$INIT_OUTPUT" | jq -r '.unseal_keys_b64[4]')
ROOT_TOKEN=$(echo "$INIT_OUTPUT" | jq -r '.root_token')

echo ""
echo "🔓 Unsealing vault1..."
docker exec vault1 vault operator unseal "$UNSEAL_KEY_1" > /dev/null
docker exec vault1 vault operator unseal "$UNSEAL_KEY_2" > /dev/null
docker exec vault1 vault operator unseal "$UNSEAL_KEY_3" > /dev/null
echo "✅ vault1 unsealed"

echo ""
echo "🤝 Joining vault2 to cluster..."
docker exec vault2 vault operator raft join http://vault1:8200
echo "🔓 Unsealing vault2..."
docker exec vault2 vault operator unseal "$UNSEAL_KEY_1" > /dev/null
docker exec vault2 vault operator unseal "$UNSEAL_KEY_2" > /dev/null
docker exec vault2 vault operator unseal "$UNSEAL_KEY_3" > /dev/null
echo "✅ vault2 unsealed"

echo ""
echo "🤝 Joining vault3 to cluster..."
docker exec vault3 vault operator raft join http://vault1:8200
echo "🔓 Unsealing vault3..."
docker exec vault3 vault operator unseal "$UNSEAL_KEY_1" > /dev/null
docker exec vault3 vault operator unseal "$UNSEAL_KEY_2" > /dev/null
docker exec vault3 vault operator unseal "$UNSEAL_KEY_3" > /dev/null
echo "✅ vault3 unsealed"

echo ""
echo "=========================================="
echo "🎉 Cluster initialized successfully!"
echo "=========================================="
echo ""
echo "Unseal Keys:"
echo "  Key 1: $UNSEAL_KEY_1"
echo "  Key 2: $UNSEAL_KEY_2"
echo "  Key 3: $UNSEAL_KEY_3"
echo "  Key 4: $UNSEAL_KEY_4"
echo "  Key 5: $UNSEAL_KEY_5"
echo ""
echo "Root Token: $ROOT_TOKEN"
echo ""
echo "UI available at:"
echo "  - http://localhost:18200/ui (vault1)"
echo "  - http://localhost:18201/ui (vault2)"
echo "  - http://localhost:18202/ui (vault3)"
echo ""
echo "To use the CLI:"
echo "  export VAULT_ADDR=http://localhost:18200"
echo "  export VAULT_TOKEN=$ROOT_TOKEN"
