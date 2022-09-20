#!/bin/bash

# Comprobando que se haya introducido un operando tipo text
if [ -z "$1" ]; then
    echo "Introduce como operando un token de acceso de Vault."
    exit 0
fi

curl \
    -X POST \
    -H "X-Vault-Token: $1" \
    $VAULT_ADDR/v1/auth/token/renew-self
