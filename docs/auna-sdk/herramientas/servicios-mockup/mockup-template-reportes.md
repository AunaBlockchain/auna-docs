##### Servicio mockup de templates para reportes

Para interactuar con el repositorio de templates existe un servicio mockup que simula el almacenamiento y obtención de las plantillas de reportes y se puede obtener mediante el siguiente comando:

```
docker pull registry.aunablockchain.com/sdk/auna-report-template-mockup:v1.0.0-node14
```

y puedes correr el servicio mediante:

```
docker run --name auna-report-template-api -p 3070:3070 registry.aunablockchain.com/sdk/auna-report-template-mockup:v1.0.0-node14
```
