##### Servicio mockup para la generación de un reporte

Para la generación de reportes se creó el servicio mockup respectivo que siempre devolverá un reporte y la imagen se puede obtener mediante el comando:

```
docker pull registry.aunablockchain.com/sdk/auna-report-service-mockup:v1.0.0-node14
```

y el servicio se puede correr mediante:

```
docker run --name auna-report-service-api -p 3071:3071 registry.aunablockchain.com/sdk/auna-report-service-mockup:v1.0.0-node14
```

Finalmente puede configurar estos puertos para probar el funcionamiento del cliente de reportes creado en el paso anterior en el archivo  **client-report.ts**
