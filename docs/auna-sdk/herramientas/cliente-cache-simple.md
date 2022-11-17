#### Cliente Cache Simple

El  **Cliente Cache Simple**  Disponibiliza un servicio para la utilización del servicio de Caché gestionado por el consorcio. Permite obtener los índices configurados y sus tipos, escribir o reemplazar los valores asociados a una llave, obtener el valor asociado a una llave, obtener una lista ordenada (Redis Z-index) para una llave maestra, obtener una lista no ordenada de forma rápida (Redis SET-index) para una llave maestra.

Actualmente, se disponibiliza el Servicio gRPC  **CacheService**  para utilizar el servicio de caché previamente creado mediante el SDK.

```
service CacheService {

rpc GetConfiguredIndexes (Empty) returns (IndexesResult);

rpc SetValue (ValueRequest) returns (ValueResult);

rpc GetValue (KeyRequest) returns (ValueResult);

rpc GetSortedList (KeyRequest) returns (ValuesResult);

rpc GetList (KeyRequest) returns (ValuesResult);

}
```

**Tipos de Mensajes**

Respuestas:

- **IndexesResult** : respuesta que contiene todos los índices configurados y sus tipos
- **ValueResult** : respuesta para eventos de creación / modificación y retorna el valor asociado a la llave y valor modificados
- **ValuesResult** : respuesta que contiene una lista de elementos asociados a una llave maestra consultada

```
// IndexesResult Contains all configured indexes and their types

message IndexesResult {

enum IndexType {

ALL\_VALUES = 0; // Must be retrieved with GetList

FIELD\_RANGE = 1; // Must be retrieved with GetSortedList

FIELD\_VALUE = 2; // Must be retrieved with GetSortedList

}

//Processed available index

message AvailableIndex {

// Index name processed

string name = 0;

// Index Type processed

IndexType type = 1;

}

// Represent an Index element

message Index {

// Id, represent the identification for an index

string id = 0;

// Type of an specific index

IndexType type = 1;

// Represent an specific field for an index

string field = 2;

// Array of string ranges for an index

repeated string ranges = 3;

}

// Field Criteria for an index

message FieldCriteria {

// Field element of the FieldCriteria

string field = 0;

// Regular expression of the criteria

string regex = 1;

}

// Element model for a chaincode

message Model {

// Model Identifier

string id = 0;

// Regular expression for a key

string keyRegex = 1;

// Contains the overwrite flag for the model

bool overwrite = 2;

// Field criteria for the chaincode model

optional FieldCriteria fieldCriteria = 3;

// Array of indexes for a model

repeated Index indexes = 4;

}

// Chaincode element for a suscription

message Chaincode {

// Chaincode Identifier

string id = 0;

// Array of models for a chaincode

repeated Model models = 1;

}

// SUscription configuration as it is loaded

message Suscription {

// channel identifier for a suscription

string channel = 0;

// Array of chaincodes for a suscription

repeated Chaincode chaincodes = 1;

}

// Master suscriptions configuration loaded in Redis

repeated Suscription suscriptions = 0;

// Processed available indexes

repeated AvailableIndex availableIndexes = 1;

}

// ValueResult Contains a value stored into the cache service

message ValueResult {

// Contains the Success/Error result status

bool success = 1;

// Contains the result data

string result = 2;

}

// ValueResult Contains a list sorted/unsorted (Redis Z-index or SET-index) for a master key

message ValuesResult {

// Contains the Success/Error result status

bool success = 1;

// Array of String results for the function

repeated string result = 2;

}
```

Solicitudes:

- **ValueRequest** : solicitud creación o actualización de un valor asociado a una key
- **KeyRequest** : solicitud de rescate de el/los elemento(s) asociado(s) a una key

```
// ValueRequest represents key-value pair for create/modify the value referenced by the key

message ValueRequest {

// Key, references the value to be stored

string key = 1;

// value to be stored

string value = 2;

}

// KeyRequest represents a key which reference the value or values that will be obtained

message KeyRequest {

// key, references value to be searched, or the master key of a list of elements

string key = 1;

}
```

**Métodos**

**GetConfiguredIndexes**

```
rpc GetConfiguredIndexes (Empty) returns (IndexesResult);
```

El método GetConfiguredIndexes realiza una llamada al servicio de caché de datos sin necesidad de indicar filtros. Devuelve una lista _IndexesResult_ con todos los índices y sus tipos.


**SetValue**

```
rpc SetValue (ValueRequest) returns (ValueResult);
```

El método SetValue crea o actualiza un valor referenciado por la key indicada en el _ValueRequest_. Devuelve un _ValueResult_ con un indicador que dice si el resultado ha sido satisfactorio y el resultado


**GetValue**

```
rpc GetValue (KeyRequest) returns (ValueResult);
```

El método GetValue obtiene el valor _ValueResult_ que es referenciado por la key indicada en _KeyRequest_


**GetSortedList**

```
rpc GetSortedList (KeyRequest) returns (ValuesResult);
```

El método GetSortedList obtiene una lista ordenada _ValuesResult_ (Redis Z-index) para una llave maestra indicada en el _KeyRequest_


**GetList**

```
rpc GetList (KeyRequest) returns (ValuesResult);
```

El método GetList obtiene una lista que no está ordenada de rápida obtención (Redis SET-index) _ValuesResult_ para una llave maestra indicada en el _KeyRequest_
