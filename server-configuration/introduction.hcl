
# /////////////////////////////////////////////////////////////////////////////////
#
# Archivo de configuración de servidor Vault. Este archivo se despliega una
# vez en el servidor en escenarios stand-alone, o una vez por cada nodo en
# escenarios de clustering.
#
# Vault espera como buena práctica que este archivo de configuración sea
# propiedad del usuario que invoca el comando $ vault server, y espera también
# que se eliminen todos los permisos dejando únicamente los de dicho
# usuario (- rwx --- --- <grupo-primario> <otros-usuarios> config-file.hcl).
#
# /////////////////////////////////////////////////////////////////////////////////

# El bloque [listener] especifica la configuración de red de Vault respecto a las
# solicitudes HTTP de la API expuesta. El listener único soportado hasta el momento
# es TCP.
#
# Es posible definir varios bloques [listener] en caso de desplegar una infraestructura
# High Availability, en cuyo caso también será necesario definir las sentencias [api_addr]
# y [cluster_addr] para concertar entre todos los nodos el endpoint principal del
# API al que pegarán los clientes HTTP y permitir a Vault desarrollar las funciones
# de balanceo y redireccionamiento propias del clúster de manera correcta.
#
# Ver todos los parámetros de configuración:
# + https://www.vaultproject.io/docs/configuration/listener/tcp
listener "tcp" {
    # Especifica la dirección de red bien sea del servidor stand-alone o del nodo
    # del clúster. Soporta interfaces IPv4 e IPv6.
    #
    # Escribir la figura [::]:8200 le hará inferir a Go que se desea escuchar por
    # todas las interfaces de red IPv4 e IPv6 posibles, incluyendo localhost. Recomendado
    # para infraestructuras stand-alone.
    address = "192.168.1.7:8200"
    # Habilita o deshabilita la comunicación TLS del servidor (HTTPS). El valor por
    # defecto es false.
    tls_disable = "false"
    # Especifica la ubicación del certificado de clave pública del servidor. Requiere
    # un archivo PEM-encoded, y depende del parámetro de configuración [tls_key_file] en
    # caso de utilizar este parámetro. Para soportar un certificado Certificate
    # Authority (CA) en la conexión TLS, el archivo aquí indicado deberá contener ambos
    # certificados; el certificado CA, en primer lugar; y a continuación, el certificado
    # de llave pública, en ese orden.
    #
    # Ruta recomendada: /etc/certs/file.crt
    tls_cert_file = "/path/to/file.crt"
    # Especifica la ubicación del certificado de llave privada del servidor. Requiere
    # un archivo PEM-encoded. Si el archivo requiere passphrase, el servidor la solicitará
    # al momento del arranque. De haber configurado un passphrase por primera vez, este
    # deberá mantenerse igual entre cada rotación de certificados de llave privada.
    #
    # Ruta recomendada: /etc/certs/file.key
    tls_key_file = "/path/to/file.key"
    # Especifica la mínima versión del protocolo TLS. También soporta las versiones
    # tls10 y tls11, pero se encuentran obsoletas y se recomienda ampliamente evitarlas.
    tls_min_version = "tls12 | tls13"
    # Enlista los ciphersuites de TLS que se desean soportar, sin importar el orden.
    # Este parámetro de configuración solo es consultado por Go cuando el parámetro
    # de configuración [tls_max_version] establece la versión de TLS únicamente en tls12.
    tls_cipher_suites = "TLS_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA, ..."
    # Habilita la autenticación obligatoria del cliente durante la conexión TLS. El valor
    # por defecto es false, es decir, no obligar al cliente, aunque en caso de habilitarlo,
    # requerirá que el parámetro de configuración [tls_client_ca_file] le proporcione la
    # ruta del certificado PEM necesario.
    tls_require_and_verify_client_cert = "false"
    # Le indica a Go la ubicación del archivo Certificate Authority (CA) en la máquina
    # anfitriona, necesario para la autenticación del cliente durante la conexión TLS en caso
    # de que el parámetro de configuración [tls_require_and_verify_client_cert] habilite
    # la autenticación obligatoria del cliente.
    tls_client_ca_file = "/path/to/client-ca.pem"
    # Deshabilita la autenticación obligatoria del cliente durante la conexión TLS,
    # permitiendo más bien que la autenticación del cliente se realice de manera opcional
    # únicamente cuando este lo solicite. Su valor por defecto es false, es decir, la
    # autenticación es opcional. En caso de tener valor true, el parámetro de configuración
    # [tls_require_and_verify_client_cert] no deberá estar también en true, ya que ambos
    # parámetros son mutuamente excluyentes.
    tls_disable_client_certs = "false"
}

# La sentencia [api_addr] especifica la URL completa del API de Vault en caso
# de desplegar una infrastructura High Availability. No tiene valor por defecto.
# Nunca colocar un identificador de red loopback, como 127.0.0.1, localhost, etc.
#
# Soporta interfaces IPv4 e IPv6.
api_addr="https://192.168.1.67:8200/"

# La sentencia [cluster_addr] especifica la URL completa del endpoint interno
# que coordina las actividades y comunicación del clúster (High Availability).
# No tiene valor por defecto.
#
# Soporta interfaces IPv4 e IPv6.
cluster_addr="https://192.168.1.67:8201/"

# El bloque [storage] contiene la configuración del Storage Backend
# de Vault, así como los detalles del tipo de Storage a utilizar como
# Integrated Storage o cualquier otro tipo de External Storage. Puede
# contener a su vez toda la configuración del bloque [ha_storage],
# o simplemente existir ambas de manera coordinada.
storage "" {

}

# El bloque [ha_storage] es opcional y complementa al bloque [storage]
# respecto a la configuración del modo HA del Storage Backend elegido.
ha_storage "" {

}

# El bloque [seal] es opcional y configura el mecanismo de Auto Unseal,
# en caso de implementarlo.
seal "" {

}

# La sentencia [disable_clustering] habilita o deshabilita las funciones de clustering
# del nodo actual, y solo se aplicarán cuando el nodo en cuestión sea una instancia "active",
# y no "standby". El valor por defecto es false, y no puede ser especificado en true si
# se utiliza raft en el Backend Storage.
disable_clustering=false

# La sentencia [cluster_name] define un identificador arbitrario para el
# clúster de Vault.
cluster_name="any-cluster-name"

# La sentencia [log_level] especifica el nivel de log a usar en Vault.
log_level="trace | debug | error | warn | info"

# La sentencia [log_format] especifica el formato de logs generados.
log_format="standard | json"

# La sentencia [ui] habilita el soporte para la UI web de Vault integrada.
# Esta UI está deshabilitada por defecto.
ui=true

# La sentencia [default_lease_ttl] define la duración por defecto del TTL
# de tokens y secretos. El valor por defecto es 768h, y no puede superar al
# valor de la sentencia [max_lease_ttl]
default_lease_ttl="5m"

# La sentencia [max_lease_ttl] define la duración máxima por defecto del TTL
# de tokens y secretos. El valor por defecto es 768h, y puede ser sobreescrito
# por el argumento max-lease-ttl de los comandos auth y secret.
max_lease_ttl="10m"

# La sentencia [default_max_request_duration] especifica la duración máxima de
# tiempo que Vault esperará antes de desechar la solicitud HTTP. Puede definirse
# también en el bloque [listener] en la propiedad [max_request_duration]. El
# valor por defecto es 90s.
default_max_request_duration="20s"