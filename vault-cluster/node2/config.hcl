ui = true
log_level = "debug"

storage "raft" {
  path = "/vault/data"
  node_id = "vault2"
}

disable_mlock = true

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = true
}

api_addr = "http://vault2:8200"
cluster_addr = "http://vault2:8201"