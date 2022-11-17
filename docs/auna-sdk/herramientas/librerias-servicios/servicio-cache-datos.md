###### Servicio de Caché de Datos

El  **Servicio de Caché de Datos**  permite replicar datos de una Red Blockchain en una base de datos de acceso rápido, para que puedan ser consultados sin crear una carga de trabajo extra en la Red Blockchain, lo que a su vez permite mejorar su rendimiento.

**Definición del Servicio**

Se disponibiliza un servicio gRPC  **CacheService**  que permite utilizar la Caché de Datos.

```
service CacheService {

// Query date for especify index value

rpc getByIndex (getByIndexRequest) returns (RequestResult);

// Query date for a range of value

rpc getByRange (getByRangeRequest) returns (RequestResult);

}
```

**Tipos de Mensajes**

Respuestas:

- **RequestResult** : Respuesta estándar para llamadas al servicio

```
message RequestResult {

enum Status {

ERROR = 0;

SUCCESS = 1;

}

// Contains the Success/Error result status

Status status = 1;

// Description of the result and additional error messages

string message = 2;

// Output payload from the Service

string output = 3;

}
```

Solicitudes:

- **User** : Es un submensaje utilizado para enviar credenciales de autenticación para la solicitud.
- **getByIndexRequest** : Solicitud utilizada para obtener los datos según el valor de un índice asociado a uno de tus atributos.
- **getByRangeRequest** : Solicitud utilizada para obtener los datos según un rango de un índice asociado a uno de sus atributos.

```
message User {

// Unique user ID

string userid = 1;

}

message getByIndexRequest {

// User for authentication

User user = 1;

// Nombre del modelo almacenado en la Cache

string modelname = 2;

// Nombre por el índice por el cual se consulta

string indexid = 3;

// Valor del índice por el cual se consulta

string indexvalue = 4;

}

message getByRangeRequest {

// User for authentication

User user = 1;

// Nombre del modelo almacenado en la Cache

string modelname = 2;

// Nombre por el índice por el cual se consulta

string indexid = 3;

// Valor inicial para el rango buscado

string valuefrom = 3;

// Valor final para el rango buscado

string valueto = 3;

}
```

**Métodos**

**getByIndex**

```
rpc getByIndex (getByIndexRequest) returns (RequestResult);
```

El método getByIndex permite obtener los datos según el valor de un índice asociado a uno de tus atributos.

**getByRange**

```
rpc getByRange (getByRangeRequest) returns (RequestResult);
```

El método getByRange permite obtener los datos según un rango de un índice asociado a uno de sus atributos.

**Configurando la cache de datos**

Para poder beneficiarse de la cache de datos, es necesario incluir en la aplicación desarrollada la configuración de los datos que se requieran almacenar en cache.

**Ejemplo de una configuración de datos en formato YML:**
```
phone:
    name:"phone"
    attr:
        model:"string"
        color:"string"
        id:"number"
    chaincode: "phoneschaincode"
    keyregex: "^phone_data*$"
    fieldcriteria:
        field: "id"
        regex: "^phone_id*$"
        indexes:
            - index:
                - id: id
                - type: "number"
            - index:
                - id: "color"
                - type: "fieldrange"
                - ranges:
                    - blue: 1
                    - green: 3
                    - red: 3

```

**Etiquetas:**

- **name** : Nombre del dato.
- **attr** : Lista de atributos del modelo.
- **chaincode** : Nombre del SmartContract asociado.
- **keyregex** : Expresión regular para extraer el modelo de datos desde el SmartContract.
- **fieldcriteria** : Campo y expresión regular para extraer el modelo de datos desde el SmartContract.
- **indexes** : Colección de ternas de id, tipo y rangos que indican los atributos a indexar y cómo hacerlo.
