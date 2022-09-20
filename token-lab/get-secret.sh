#!/bin/bash

# Comprobando que se haya introducido un operando tipo text
if [ -z "$1" ]; then
    echo "Introduce como primer operando un token de acceso de Vault, y como segundo
operando el nombre del secreto a obtener del KV Engine v2 (/secret/data/<secret-name>)."
    exit 0
fi

curl \
    -X GET \
    -H "X-Vault-Token: $1" \
    $VAULT_ADDR/v1/secret/data/$2
