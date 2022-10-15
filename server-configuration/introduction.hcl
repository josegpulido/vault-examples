
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
# API al que pegarán los clientes HTTP y permitir a Vault desarrollar las funciones-
# de balanceo y redireccionamiento propias del clúster de manera correcta. Lo anterior
# también quiere decir que habrá tantos bloques [listener] como nodos en el clúster.
#
# Ver todos los parámetros de configuración:
# + https://www.vaultproject.io/docs/configuration/listener/tcp
listener "tcp" {
    # Especifica la dirección de red bien sea del servidor stand-alone o de un nodo
    # del clúster. Soporta interfaces IPv4 e IPv6.
    #
    # Escribir la figura [::]:8200 le hará inferir a Go que se desea escuchar por
    # todas las interfaces de red IPv4 e IPv6 posibles, incluyendo localhost (recomendado
    # para aplicaciones stand-alone).
    address = "192.168.1.7:8200"
    # Habilita o deshabilita la comunicación TLS en la máquina (HTTPS). El valor por
    # defecto es false.
    tls_disable = "false"
    # Especifica la ubicación del certificado X.509 web de clave pública de la máquina.
    # Requiere un archivo PEM-encoded, y depende del parámetro de configuración [tls_key_file]
    # para establecer la ubicación de la clave asimétrica privada. Si se desea incluir
    # también el certificado del CA que firmó el certificado web, el archivo aquí indicado
    # deberá contener ambos certificados; el certificado web, en primer lugar; y a continuación,
    # el certificado CA, en ese orden.
    #
    # En caso de que el modo HA esté habilitado, cada máquina requerirá su propio
    # certificado web distinto.
    tls_cert_file = "/etc/certs/server.crt"
    # Especifica la ubicación de la clave asimétrica privada de la máquina. Requiere
    # un archivo PEM-encoded. Si el archivo requiere passphrase, Vault la solicitará
    # al momento del arranque, y en caso de que el modo HA esté habilitado se recomienda
    # ampliamente que el passphrase de las claves privadas del resto de nodos sea exactamente
    # el mismo.
    tls_key_file = "/etc/certs/server.key"
    # Especifica la mínima versión del protocolo TLS. También soporta las versiones
    # tls10 (TLS 1.0) y tls11 (TLS 1.1), pero no se recomiendan ya que se consideran obsoletas.
    tls_min_version = "tls12 | tls13"
    # Enlista los Cipher Suites de TLS que se desean soportar, sin importar el orden.
    # Este parámetro de configuración solo es consultado por Go cuando el parámetro
    # de configuración [tls_max_version] establece la versión de TLS en tls12, ya que en la
    # versión 1.3 de TLS no se recomienda negociación.
    tls_cipher_suites = "TLS_RSA_WITH_AES_128_CBC_SHA, TLS_RSA_WITH_AES_128_CBC_SHA, ..."
    # Habilita la autenticación obligatoria del cliente en la conexión TLS. El valor por defecto
    # es false, es decir, no obligar a que el cliente se autentique. En caso de habilitarlo
    # se requerirá que el parámetro de configuración [tls_client_ca_file] le proporcione la
    # ruta del certificado del CA contra el que se validará la firma del certificado del cliente.
    tls_require_and_verify_client_cert = "false"
    # Le indica a Go la ubicación del certificado de CA contra el que se validará la firma del
    # certificado que presente el cliente en caso de que el parámetro de configuración
    # [tls_require_and_verify_client_cert] se encuentre en true.
    tls_client_ca_file = "/path/to/client-ca.crt"
}

# La sentencia [api_addr] especifica la URL completa del API de Vault en caso
# de desplegar una infrastructura High Availability. No tiene valor por defecto, y
# se deberá colocar la dirección de red del nodo "leader" del protocolo raft.
# Nunca colocar un identificador de red loopback, como 127.0.0.1, localhost, etc.
#
# Soporta interfaces IPv4 e IPv6.
api_addr="https://192.168.1.67:8200"

# La sentencia [cluster_addr] especifica la URL completa del endpoint interno
# que coordina las actividades y comunicación del clúster (modo High Availability).
# No tiene valor por defecto, y es necesario establecerlo en caso de seleccionar
# una solución de Storage que soporte HA de forma nativa.
#
# Soporta interfaces IPv4 e IPv6.
cluster_addr="https://192.168.1.67:8201"

# El bloque [storage] contiene la configuración del Storage Backend
# seleccionado. Cada opción tiene sus ventajas, desventajas y características
# particulares frente a las demás opciones. Por ejemplo, algunas opciones
# soportan el modo High Availability, mientras otras proveen mayor
# robustez en cuanto a respaldos y procesos de restauración.
#
# HashiCorp recomienda escoger Integrated Storage como solución de Storage, ya que
# no requiere instalación adicional (se encuentra embebido dentro del binario
# ejecutable de Vault), recibe soporte oficial de HashiCorp y soporta
# el modo High Availability. El identificador de este Storage en específico
# es "raft".
#
# Algunos ejemplos de otros Storage Backends soportados por terceros son:
# Azure, Cassandra, DynamoDB, Google Cloud Storage, MySQL, PostgreSQL, S3,
# Swift, ZooKeeper, entre otros.
#
# A continuación, se desglosará los parámetros de configuración del
# Storage llamado Integrated Storage (raft). En este caso en particular, el bloque
# [ha_storage] no debe ser definido.
#
# Ver todos los Storage disponibles y sus respectivos parámetros de configuración:
# + https://www.vaultproject.io/docs/configuration/storage
storage "raft" {
    # Define la ubicación de la máquina anfitriona en donde Vault almacenará
    # todos los datos del Backend Storage. Esto se replicará de la misma forma
    # en los nodos del clúster en caso de que HA esté habilitado.
    #
    # Se recomienda el valor "/opt/vault/data"
    path = "path/to/some-directory"
    # Especifica el nombre del nodo con el que se identificará la máquina frente
    # al clúster de raft. Si no se desea habilitar HA, omitir este parámetro.
    node_id = "nodo-1"
    # Permite establecer una identificación de cada nodo del clúster de raft con el
    # propósito de que los demás nodos o bien vuelvan a conectarse al clúster
    # en caso de que alguno de ellos caiga, o bien se coordine el arranque del
    # clúster en caso de que el clúster mismo esté arrancando luego de, p. ej.,
    # una interrupción eléctrica o caída de red. Lo anterior también quiere decir
    # que habrá tantos bloques [retry_join] como nodos en el clúster.
    #
    # Cuando el primero de los nodos del clúster arranca, este se convertirá
    # automáticamente en el nodo "leader" y el resto de nodos se irán uniendo
    # para formar el clúster de raft. En caso de utilizar Shamir's Secret Sharing
    # como mecanismo de unseal, los nodos unidos al clúster aún requeriran ser
    # desencriptados (unsealed) de forma manual; uno por uno.
    retry_join {
        # Define mediante una URL completa la dirección de red de un nodo del clúster de raft.
        # Soporta interfaces IPv4 e IPv6.
        leader_api_addr = "http://192.168.1.67:8200"
        # Indica el nombre de dominio al que la Certificate Authority (CA) emitió el certificado
        # X.509. Necesario para habilitar la comunicación TLS intra-clúster.
        leader_tls_servername = "anything.my-domain.com"
        # Especifica la ubicación del certificado del CA que firma el certificado web del posible
        # nodo "leader". Requiere un archivo PEM-encoded.
        leader_ca_cert_file = "/etc/certs/server-ca.crt"
        # Especifica la ubicación del certificado web del posible nodo "leader". Requiere un
        # archivo PEM-encoded.
        leader_client_cert_file = "/etc/certs/server.crt"
        # Especifica la ubicación de la clave asimétrica privada del posible nodo "leader". Requiere
        # un archivo PEM-encoded.
        leader_client_key_file = "/etc/certs/file.key"
    }
    # Para ver parámetros más avanzados de Integrated Storage (raft), consultar:
    # + https://www.vaultproject.io/docs/configuration/storage/raft
}

# La sentencia [disable_mlock] deshabilita o habilita el uso de memoria swap
# en la solución de Storage Backend seleccionada. HashiCorp recomienda desactivar
# la memoria swap directamente cuando la solución de Storage seleccionada es
# Integrated Storage como medida de seguridad.
disable_mlock=false

# El bloque [ha_storage] tiene el propósito específico de definir configuración
# adicional a aquellas soluciones de Backend Storage que no soporten el modo
# High Availability por defecto, y permitir desplegar un escenario de clustering
# entre varios nodos de manera coordinada.
#
# Este bloque no es necesario si se ha selecciondo una solución de Storage que
# sí soporte el modo HA por defecto, como Consul o Integrated Storage.
#
# Más información sobre este escenario en particular:
# + https://learn.hashicorp.com/tutorials/vault/raft-ha-storage
ha_storage "" {

}

# El bloque [seal] es opcional y configura el mecanismo de Auto Unseal,
# en caso de implementarlo.
seal "" {

}

# La sentencia [disable_clustering] habilita o deshabilita las funciones de clustering
# del nodo actual, y solo se aplicarán cuando el nodo en cuestión sea una instancia "active",
# y no "standby". El valor por defecto es false, y no puede ser especificado en true si
# se utiliza Integrated Storage (raft) como solución de Storage.
disable_clustering=false

# La sentencia [cluster_name] define un identificador arbitrario para el
# clúster de Vault.
cluster_name="any-cluster-name"

# La sentencia [log_level] especifica el nivel de log a usar en Vault.
log_level="trace | debug | error | warn | info"

# La sentencia [log_format] especifica el formato de logs generados. El valor por defecto
# es "standard".
log_format="standard | json"

# La sentencia [ui] habilita el soporte para la UI web built-in de Vault. En un escenario
# stand-alone, deberá utilizarse la dirección de red configurada en el bloque [listener],
# mientras que en escenarios de clustering, deberá utilizarse la dirección de red configurada
# en la sentencia [api_addr].
#
# Esta interfaz gráfica es de tipo administrativa, y está deshabiliada por defecto. La URL
# de acceso es la siguiente:
# + http://<listener-addr | api-addr>:8200/ui/
ui=true

# La sentencia [default_lease_ttl] define la duración por defecto del TTL
# de tokens y secretos. El valor por defecto es 768h, y no puede superar al
# valor de la sentencia [max_lease_ttl]. Puede ser sobreescrito mediante operaciones
# adecuadas de "último tramo".
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