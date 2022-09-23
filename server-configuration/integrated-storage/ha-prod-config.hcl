
# /////////////////////////////////////////////////////////////////
# Este archivo de configuración prepara a Vault para un escenario
# de infraestructura High Availability con 3 nodos, utilizando al
# Integrated Storage (raft) como solución de Storage Backend.
# /////////////////////////////////////////////////////////////////

# Nombre del clúster
cluster_name="my-cluster-ha"

# Habilitando interfaz web de administración built-in de Vault
ui=true

# Configuraciones de red de nodo-1
listener "tcp" {
    address = "192.168.1.67:8200"
    tls_cert_file = "/etc/certs/cert-n1.crt"
    tls_key_file = "/etc/certs/cert-n1.key"
    tls_min_version = "tls13"
}

# Configuraciones de red de nodo-2
listener "tcp" {
    address = "192.168.1.68:8200"
    tls_cert_file = "/etc/certs/cert-n2.crt"
    tls_key_file = "/etc/certs/cert-n2.key"
    tls_min_version = "tls13"
}

# Configuraciones de red de nodo-3
listener "tcp" {
    address = "192.168.1.69:8200"
    tls_cert_file = "/etc/certs/cert-n3.crt"
    tls_key_file = "/etc/certs/cert-n3.key"
    tls_min_version = "tls13"
}

# Configurando Integrated Storage como solución seleccionada de
# Storage Backend
storage "raft" {
    # Directorio del almacenamiento del Storage Backend
    path = "~/vault/data"
    # Nombre del nodo
    node_id = "nodo-1"
    # Identidades de nodos, requeridas por protocolo raft
    retry_join {
        leader_api_addr = "http://192.168.1.67:8200"
        # Certificados del posible nodo "leader"
        leader_ca_cert_file = "/etc/certs/cert-n1.pem"
        leader_client_cert_file = "/etc/certs/cert-n1.crt"
        leader_client_key_file = "/etc/certs/cert-n1.key"
    }
    retry_join {
        leader_api_addr = "http://192.168.1.68:8200"
        # Certificados del posible nodo "leader"
        leader_ca_cert_file = "/etc/certs/cert-n2.pem"
        leader_client_cert_file = "/etc/certs/cert-n2.crt"
        leader_client_key_file = "/etc/certs/cert-n2.key"
    }
    retry_join {
        leader_api_addr = "http://192.168.1.69:8200"
        # Certificados del posible nodo "leader"
        leader_ca_cert_file = "/etc/certs/cert-n3.pem"
        leader_client_cert_file = "/etc/certs/cert-n3.crt"
        leader_client_key_file = "/etc/certs/cert-n3.key"
    }
}

# Deshabilitando memoria swap para favorecer seguridad en Integrated Storage
disable_mlock=true

# Duración de TTL por defecto en tokens y secretos
default_lease_ttl="5m"

# Duración de Max-TTL por defecto en tokens y secretos
max_lease_ttl="10m"

# Configurando endpoint de API y endpoint de comunicaciones intra-cluster.
api_addr="https://192.168.1.67:8200"
cluster_addr="https://192.168.1.67:8201"