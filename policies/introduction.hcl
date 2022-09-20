
# La sentencia path define un bloque de reglas que se valorarán
# si es que la solicitud HTTP entrante desea acceder al recurso
# descrito entre comillas.
#
# Las políticas de Vault utilizan una estrategia deafult-deny, es
# decir, los privilegios, recursos o características del path deseado
# que no se encuentren expresamente definidos dentro del bloque se
# denegarán, bloquearán o ignorarán, respectivamente.
path "secret/foo" {
  # La keyword "capabilities" define las capacidades de operación del
  # cliente respecto al recurso solicitado, siempre a través de una
  # lista de strings.
  #
  # Más información:
  # + https://developer.hashicorp.com/vault/docs/concepts/policies
  #
  # Lista de valores posibles para keyword "capabilities":
  capabilities = [
    # [POST/PUT]. Permite crear datos en la ruta.
    "create",
    # [GET]. Permite leer datos ubicados en la ruta.
    "read",
    # [POST/PUT]. Permite modificar los datos ubicados en la ruta. En
    # la mayoría de rutas de Vault, esta capability también permite
    # crear datos en la ruta por primera vez.
    "update",
    # [PATCH]. Permite modificar de forma parcial los datos de la ruta.
    "patch",
    # [DELETE]. Permite borrar datos de la ruta.
    "delete",
    # [LIST]. Permite listar datos ubicados en la ruta. Los datos
    # retornados por esta operación no son filtrados por las políticas,
    # por lo que es importante evitar hardcodear información sensible
    # el los key-names de dichos valores. No todas las rutas de Vault
    # soporta esta operación.
    "list",
    # [NO-HTTP-VERB]. Permite acceder a todas aquellas rutas de Vault
    # que sean "root-protected". Usar esta capability no prescinde
    # de usar las capabilitues como "read", "list", etc.
    "sudo",
    # [NO-HTTP-VERB]. Deshabilita explicitamente cualquier tipo
    # de operación en la ruta, incluyendo la capability "sudo".
    "deny"
  ]

  # La keyword "required_parameters" no es compatible con KV Engine v2,
  # por lo que se omite incluirlas en esta explicación.
  #
  # Más información:
  # + https://developer.hashicorp.com/vault/docs/concepts/policies

  # Otras keywords:
  # - min_wrapping_ttl = "1s"
  # - max_wrapping_ttl = "90s"
}

# Policy Store soporta el uso de glob-patterns.
#
# Ejemplo 1:
# El siguiente bloque permite al usuario acceso ilimitado de lectura
# de cualquier recurso ubicado bajo la ruta /bar del engine KV.
#
# Nota: El wildcard (*) solo se admite como último caracter del path.
path "secret/bar/*" {
  capabilities = ["read"]
}

# Ejemplo 2
# Acceso ilimitado de lectura de cualquier recurso ubicado bajo la
# ruta /secret/baz/<any-text>/<any-text>/bar del engine KV.
path "secret/baz/+/+/bar" {
  capabilities = ["read"]
}