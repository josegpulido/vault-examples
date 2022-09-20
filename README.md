# Prácticas en Vault HashiCorp

Ejemplos y ejercicios ordenados al azar.

### Indice
- **/policies**. Introducción a la estructura declarativa de una política de acceso en sintaxis HCL.
- **/token-lab**. Contiene scripts con $ curl para probar API endpoints de operaciones sobre el mismo token solicitante, como:
    - **lookup-self.sh**. Obtener información del token.
    - **renew-self.sh**. Renovar el token de autenticación (en caso de permitirse).
    - **get-secret.sh**. Obtener un secreto del KV Engine v2 (requiere política previamente configurada y asociada al token).
- **/server-configuration**. Introducción y profundización en la estructura declarativa de la configuración de un servidor de Vault sobre entornos de producción en sintaxis HCL.
