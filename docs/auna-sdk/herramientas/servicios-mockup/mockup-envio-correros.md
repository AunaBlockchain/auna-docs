##### Servicio mockup para el envío de correos

Para simular el envío de correo se creó el servicio mockup respectivo que simula el envío del correo y la imagen se puede obtener mediante el comando:

```
docker pull registry.aunablockchain.com/sdk/auna-mail-service-mockup:v1.0.0-node14
```

y el servicio se puede correr mediante:

```
docker run --name auna-mail-service-api -p 3101:3101 registry.aunablockchain.com/sdk/auna-mail-service-mockup:v1.0.0-node14
```
