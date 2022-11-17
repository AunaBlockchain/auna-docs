##### Servicio mockup de templates para correos

Para interactuar con el repositorio de templates existe un servicio mockup que simula el almacenamiento y obtención de las plantillas de correos y se puede obtener mediante el siguiente comando:

```
docker pull registry.aunablockchain.com/sdk/auna-mail-template-mockup:v1.0.0-node14
```

y puedes correr el servicio mediante:

```
docker run --name auna-mail-template-api -p 3051:3051 registry.aunablockchain.com/sdk/auna-mail-template-mockup:v1.0.0-node14
```