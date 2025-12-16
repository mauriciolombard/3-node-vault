# Vault Enterprise Raft Cluster Setup

This setup creates a 3-node Vault Enterprise cluster using Raft integrated storage.

## Prerequisites

- Docker Desktop installed (includes Docker Compose)
- Vault Enterprise license set in `VAULT_LICENSE` environment variable
- Vault version can be specified via environment variable

## Usage

1. Navigate to this directory.
   ```
   cd vault-cluster
   ```

2. Set the Vault version (optional, defaults to latest Enterprise):
   ```
   export VAULT_VERSION=1.21.0-ent
   VAULT_ADDR=http://localhost:18200 (active)
   VAULT_ADDR=http://localhost:18201
   VAULT_ADDR=http://localhost:18202
   ```

3. Start the cluster:
   ```
   docker compose up -d
   ```

4. The nodes will be accessible on:
   - Node 1: http://localhost:18200
   - Node 2: http://localhost:18201
   - Node 3: http://localhost:18202

## Initializing the Cluster
   ```bash
   ./init.sh
   ```

   This script will:
   - Stop any existing cluster
   - Remove data directories
   - Start the cluster fresh
   - Initialize the cluster with `vault operator init`
   - Unseal all three nodes
   - Display the unseal keys and root token



## Accessing the nodes
```
docker exec -it vault1 /bin/sh
docker exec -it vault2 /bin/sh
docker exec -it vault3 /bin/sh
```

### Web UI
- **Node 1**: http://localhost:18200/ui
- **Node 2**: http://localhost:18201/ui
- **Node 3**: http://localhost:18202/ui

Log in with the root token displayed after running `init.sh`.

## To restart after changes to Vault configuration file
```
docker compose restart
```

## Stopping the Cluster

```
docker compose down
```

To remove volumes (data):

```
docker compose down -v
```