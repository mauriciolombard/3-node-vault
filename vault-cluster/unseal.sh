#!/bin/bash

# Unseal keys
UNSEAL_KEYS=(
    "EUbmrDrwL0XokTVgAOYR59CzxMBy92K41I7HbPXAB+OG"
    "1NIwJ4jJw+Nr6STsptEZkJ7kIppc/6O0luEdXBllr2lj"
    "a76N+qocxSUPkQQYjEn1qib7wGXLnYLZMn60ydsTh0+2"
    "zccejbHaZNlR0WJMZ6G8J1MR0XsiPyb6L38sKZkD2Wns"
    "ExtaQ2EjiG3ugiGUYNhC41Vm/aCbAkcXjRIqgJWDVDKL"
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