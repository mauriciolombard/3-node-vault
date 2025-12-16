#!/bin/bash

# Unseal keys
UNSEAL_KEYS=(
    "YOUR_UNSEAL_KEY_1"
    "YOUR_UNSEAL_KEY_2"
    "YOUR_UNSEAL_KEY_3"
    "YOUR_UNSEAL_KEY_4"
    "YOUR_UNSEAL_KEY_5"
)

# Nodes
NODES=("vault1" "vault2" "vault3")

# Unseal each node with all keys
for node in "${NODES[@]}"; do
    echo "Unsealing $node..."
    for key in "${UNSEAL_KEYS[@]}"; do
        docker exec -it $node vault operator unseal $key
    done
    echo "$node unsealed."
done

echo "All nodes unsealed."