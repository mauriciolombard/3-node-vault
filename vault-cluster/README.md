# Vault Enterprise Raft Cluster Setup

This setup creates a 3-node Vault Enterprise cluster using Raft integrated storage for troubleshooting purposes.

## Prerequisites

- Docker Desktop installed (includes Docker Compose)
- Vault Enterprise license set in `VAULT_LICENSE` environment variable
- Vault version can be specified via environment variable

## Usage

1. Navigate to this directory.

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

After starting, initialize the first node:

```
docker exec -it vault1 vault operator init
```

This will output unseal keys and root token. Note them down.

Unseal vault1:

```
docker exec -it vault1 vault operator unseal <key1>
docker exec -it vault1 vault operator unseal <key2>
docker exec -it vault1 vault operator unseal <key3>
```

Or use the provided script:

```
./unseal.sh
```

Join the other nodes:

```
docker exec -it vault2 vault operator raft join http://vault1:8200
docker exec -it vault3 vault operator raft join http://vault1:8200
```

Unseal vault2 and vault3 similarly.

## Stopping the Cluster

```
docker compose down
```

To remove volumes (data):

```
docker compose down -v
```