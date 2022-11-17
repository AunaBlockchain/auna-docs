## Herramientas del SDK

En esta sección podrás conocer las herramientas que el equipo de AUNA ha construido para facilitar la creación de tus aplicaciones blockchain. Estas herramientas son:

1. **Conectores para Blockchain** : Manejo de credenciales y manejo de redes blockchain basadas en Hyperledger Fabric 2. Esta funcionalidad es el puente de acceso a las redes blockchain.
2. **Librerías de servicio** : Acceso a sistemas diseñados para mejorar el uso de las redes blockchain mediante:
  - **Servicio de suscripción de correos** : Permite el envío de correos asociados a eventos de la red blockchain.
  - **Servicio de generación de reportes** : Permite la generación de reportes a partir de información tanto dentro como fuera del blockchain.
  - **Servicio de caché para redes** : Permite mejorar el rendimiento de una red estresada por un nivel de consulta alto.
3. **Conexiones para interfaces externas** : Esta funcionalidad permite la conexión a fuentes externas de información para consumir data.
4. **Librerías de Smart contracts** : Son funciones comunes y utilitarias para llamar queries.
5. **Api Client** : Librería que permite tener acceso a los conectores para redes blockchain. Es una interfaz que se debe importar como librería para desarrollo y se encarga de la comunicación con los componentes del SDK usando protocolo GRPC.
6. **Smart Contract runtime** : Ambiente que permite correr el runtime de Hyperledger Fabric con los entornos de ejecución específicos de cada red Blockchain, con el fin de que puedan operar los Smart Contracts. Se presentan como librerías Docker, se distribuye como imágenes y librerías.
7. **Task Scheduler:** Programador de tareas que sirve para tener un punto de referencia con la hora oficial de la red y ejecutar tareas programadas en base a esta.
8. **Realease packager** : Herramienta que valida y empaqueta una app en formato tar.gz, lista para ser subida al portal.

#### Cliente Simple Fabric

El  **Cliente Simple Fabric**  esconde algunas de las complejidades para llamar lógica de negocio en los SmartContracts de una red Fabric gestionada por el Consorcio. Permite llamar transacciones, realizar consultas, suscribirse a eventos y obtener cambios en los modelos de datos.

Actualmente, se disponibiliza el Servicio gRPC  **NetworkClient**  para conectar a una red Fabric previamente creada mediante el SDK

```
service NetworkClient {

rpc InvokeSmartContract (ChaincodeRequest) returns (RequestResult);

rpc QuerySmartContract (ChaincodeRequest) returns (RequestResult);

rpc ChaincodeKeysFromBlocks (KeysBlockRequest) returns (RequestResult);

rpc StreamChaincodeEvents (ChaincodeEventsRequest) returns (stream EventResult);

rpc StreamBlockEvents (BlockEventsRequest) returns (stream EventResult);

}
```

**Tipos de Mensajes**

Respuestas:

- **RequestResult** : respuesta estándar para llamadas a Transacciones (transaction) y Consultas (query)
- **EventResult** : respuesta para eventos asíncronos de consultas

```
// RequestResult contains the reponse to a Request for transaction, query or modified/added/deleted keys

message RequestResult {

enum Status {

ERROR = 0;

SUCCESS = 1;

}

// Contains the Success/Error result status

Status status = 1;

// Description of the result and additional error messages

string message = 2;

// Binary output payload from the SmartContract

bytes output = 3;

}

// EventResult contains an Event instance occurred for a EventsRequest suscription

message EventResult {

// Binary event payload

bytes payload = 1;

// Block Number were the event triggered

int64 blockNumber = 2;

// Transaction ID involved, if applies

string transactionId = 3;

// Status string of the Event

string status = 4;

}
```

Solicitudes:

- **ChaincodeRequest** : solicitud de invocación de Transacción (transaction) o Consulta (query) sobre un SmartContract
- **KeysBlockRequest** : solicitud de rescate de llaves únicas agregadas, modificadas o eliminadas en un SmartContract, desde un bloque específico en adelante
- **ChaincodeEventsRequest** : solicitud de suscripción a eventos de tipo ChaincodeEvent para un SmartContract
- **BlockEventsRequest**  : solicitud de suscripción a evento de tipo BlockEvents para un canal

```
// User Es un submensaje utilizado para enviar credenciales de autenticación para la solicitud.
message User {
    // Unique user ID
    string identity = 1;

    // MSP ID of the User
    string mspId = 2;

    // PEM formatted binary private key
    bytes privateKey = 3;

    // CER formatted binary public key
    bytes certificate = 4;
}

// ChaincodeRequest represents a Query or Transaction request for a given Smartcontract function over a specific Channel
message ChaincodeRequest {
    // Flag enum contains the modifiers for the ChaincodeRequest
    enum Flag {
        // Default behavior. Transactions doesn't wait for block dissemination, Queries calls a single Peer
        NONE = 0;

        // Sync Wait until block dissemination of the Transaction
        WAIT_FOR_BLOCK = 1;

        // Call all available Peers for the Query
        QUERY_ALL_PEERS = 2;
    }

    // User for authentication
    User user = 1;

    // Binary encoded Common Connection Profile, see https://hyperledger.github.io/fabric-sdk-node/release-1.4/tutorial-network-config.html
    bytes clientConfig = 2;

    // Channel Name, channel for executing the Request
    string channelName = 3;

    // Chaincode Name, identifies the chaincode to call
    string chaincodeName = 4;

    // Chaincode function name to invoke
    string functionName = 5;

    // Array of String arguments for the function
    repeated string args = 6;

    // Serialized Transient Map for a Transaction, see Fabric SDK
    map<string, bytes> transientMap = 7;

    // Modifier Flag
    Flag flag = 15;
}

// KeysBlockRequest represents a Request for all Model Keys from a given block number onwards, for a specific Smartcontract on a given Channel
message KeysBlockRequest {
    // User for authentication
    User user = 1;

    // Binary encoded Common Connection Profile, see https://hyperledger.github.io/fabric-sdk-node/release-1.4/tutorial-network-config.html
    bytes clientConfig = 2;

    // Channel Name, channel for executing the Request
    string channelName = 3;

    // Chaincode Name, identifies the chaincode to scan for keys
    string chaincodeName = 4;

    // RWSet Namespace, use null/blank to ignore (default). Namespace "lscc" will be always excluded
    string namespace = 13;

    // Block number from which start the scanning
    int64 fromBlock = 14;
}

// ChaincodeEventsRequest represents a Suscription Request for Chaincode-level customs events
message ChaincodeEventsRequest {
    // User for authentication
    User user = 1;

    // Binary encoded Common Connection Profile, see https://hyperledger.github.io/fabric-sdk-node/release-1.4/tutorial-network-config.html
    bytes clientConfig = 2;

    // Channel Name, channel for executing the Request
    string channelName = 3;

    // Chaincode Name, identifies the chaincode to listen for events
    string chaincodeName = 4;

    // Name of the custom Chaincode event
    string eventName = 12;

    // Optional block number from which to start an event replay. Use "-1" to suscribe to the current live feed
    int64 fromBlock = 14;
}

// BlockEventsRequest represents a Suscription Request for Block-level customs events
 message BlockEventsRequest {
     // User for authentication
     User user = 1;

     // Binary encoded Common Connection Profile, see https://hyperledger.github.io/fabric-sdk-node/release-1.4/tutorial-network-config.html
     bytes clientConfig = 2;

     // Channel Name, channel for executing the Request
     string channelName = 3;

     // Optional block number from which to start an event replay. Use "-1" to suscribe to the current live feed
     int64 fromBlock = 14;
 }

```

**Métodos**

**InvokeSmartContract**

```
rpc InvokeSmartContract (ChaincodeRequest) returns (RequestResult);
```

El método InvokeSmartContract inicia una nueva solicitud de Transacción sobre un SmartContract/Canal de una red Fabric. Devuelve siempre una respuesta de tipo RequestResult que contiene el resultado del _endorsement_ de la transacción por parte del servicio de _Ordering_. En caso de un _endorsement_ correcto, enviará la transacción para su propagación.

A menos que se indique lo contrario, el método retornará inmediatamente apenas la transacción sea aceptada o rechazada. Es posible cambiar el comportamiento para que espere la propagación de la transacción a toda la red Fabric, mediante Flag.WAIT\_FOR\_BLOCK.


**QuerySmartContract**

```
rpc QuerySmartContract (ChaincodeRequest) returns (RequestResult);
```

El método QuerySmartContract inicia una nueva solicitud de Consulta sobre un SmartContract/Canal de una red Fabric. Devuelve siempre una respuesta de tipo RequestResult que contiene el resultado de la consulta, ya sea la respuesta a la consulta o un mensaje de error de la red Fabric o del servicio mismo.

A menos que se indique lo contrario, el método retornará inmediatamente el resultado del primer nodo Peer disponible. Es posible cambiar el comportamiento para que consulte a todos los Peers disponibles y compare el resultado, mediante Flag.QUERY\_ALL\_PEERS.


**ChaincodeKeysFromBlocks**

```
rpc ChaincodeKeysFromBlocks (KeysBlockRequest) returns (RequestResult);
```

El método ChaincodeKeysFromBlocks solicita todas las llaves primarias (_Keys_) de uno o todos los modelos de datos de un Smartcontract para un Canal dado, a partir de un número de bloque indicado.

El método devolverá todas las llaves válidas que hayan sido insertadas o modificadas mediante el método PutKey del SmartContract, o que hayan sido eliminadas correctamente mediante el método DelKey del mismo.

**StreamChaincodeEvents**

```
rpc StreamChaincodeEvents (ChaincodeEventsRequest) returns (stream EventResult);
```

El método StreamChaincodeEvents inicia la suscripción asíncrona al stream de eventos de Chaincode especificado en los parámetros de invocación. El servicio de cliente Fabric enviará todos los eventos de chaincode para el Smartcontract y el canal suscrito.

**StreamBlockEvents**

```
rpc StreamBlockEvents (BlockEventsRequest) returns (stream EventResult);
```

El método StreamBlockEvents inicia la suscripción asíncrona al stream de eventos de bloque especificado en los parámetros de invocación. El servicio de cliente Fabric enviará todos los eventos de bloque para el canal suscrito.

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

#### Smartcontract Runtimes

En esta sección de la documentación se especifican los entornos de ejecución específicos de cada red Blockchain, con el fin, que puedan operar los Smart Contracts. En el caso de Hyperledger Fabric, corresponden a:

- **Node.js LTS**
- **Golang 10+**

Para más información de compatibilidad de node se debe revisar [la documentación de soporte y compatibilidad](https://github.com/hyperledger/fabric-chaincode-node/blob/master/COMPATIBILITY.md) de fabric-chaincode-node.

Estos son los estándares bajo los cuales se debe basar cualquier persona que quiera desarrollar en este sistema, con el único fin que estos estándares representen una ayuda y una directriz de a qué atenerse.

Hyperledger Fabric tiene su propio SDK, y dispone las siguientes API&#39;s para el manejo de SmartContracts:

###### Para Node.js

- **Fabric-contract-API** : Provee la interfaz de contratos, una API de alto nivel para desarrolladores de aplicaciones para implementar SmartContracts.
- **Fabric-shim** : Provee la interfaz de chaincode, una API de bajo nivel para implementar SmartContracts, a su vez provee la implementación para soportar la comunicación con los peers de Hyperledger Fabric para SmartContract escritos utilizando fabric-contract-API.
- **fabric-shim-api** : Proporciona definiciones de tipo para el módulo  **fabric-shim**. También es una dependencia de  **fabric-contract-api**  y como se trata de un módulo de interfaz puro, permite que las anotaciones de fabric-contract-api se utilicen en la aplicación cliente sin la necesidad de incorporar dependencias innecesarias.
- **fabric-shim-crypto** : Librería que provee funciones compatibles de cifrado y descifrado que pueden ser útiles para los desarrolladores.

###### Para golang

- **Pkg/attrmgr** : Paquete que contiene utilidades para administrar atributos.
- **Pkg/cid**
- **Pkg/statebased**
- **shim** : paquete que provee APIs para que chaincode acceda a sus variables de estado, contexto de transacción y llame a otros.
- **Shim/internal**
- **Shim/internal/mock** : Código generado para simulación.
- **Shimtest:** Paquete que provee una simulación de ChaincodeStubInterface para pruebas unitarias de chaincode.
- **Shimtest/mock:** Código generado para simulación.

#### Cliente API SmartContracts

El Cliente API sirve de interfaz entre los SmartContract que componen una porción de una App y el resto de sus componentes. Las API´s están desarrolladas en Node.js y sirven de acceso a la red blockchain permitiendo efectuar operaciones sobre la red en un entorno controlado.

Actualmente, se disponibiliza la Cliente API para acceder a realizar operaciones sobre la red Blockchain:

```
const invokeSmartContract = async (paramsInvoke) => { return requestResult};

const querySmartContract = async (paramsQuery) => { return requestResult};

const chaincodeKeysFromBlocks = async (paramsChaincodeKeys) => {return requestResult};

const streamChaincodeEvents = async (paramsChaincodeEvents) => {return eventResult};

const streamBlockEvents = async (paramsBlockEvents) => {return eventResult};

const processUser = async (user) => { return user};

const processNetwork = (network) => { return Buffer};

```

**Tipos de Mensajes**

Respuestas:

- **requestResult** : respuesta estándar para llamadas a Transacciones (transaction) y Consultas (query)
- **eventResult** : respuesta para eventos asíncronos de consultas
- **user** : Respuesta para el procesamiento de un usuario

```
// requestResult contains the reponse to a Request for transaction, query or modified/added/deleted keys

let requestResult

// eventResult contains an Event instance occurred for a EventsRequest suscription

let eventResult

// User object tretrieved after load the User request element

let User

// The network file with embedded certificates encodeded as a binary Buffer

let Buffer
```

Solicitudes:

- **paramsInvoke** : solicitud de invocación de Transacción (transaction) sobre un SmartContract
- **paramsQuery** : solicitud de invocación de Consulta (query) sobre un SmartContract
- **paramsChaincodeKeys** : solicitud de rescate de llaves únicas agregadas, modificadas o eliminadas en un SmartContract, desde un bloque específico en adelante
- **paramsChaincodeEvents** : solicitud de suscripción a eventos de tipo grpc.ClientReadableStream para un SmartContract
- **paramsBlockEvents** : solicitud de suscripción a evento de tipo grpc.ClientReadableStream para un canal
- **user** : Una cadena de string para el archivo de _User_ o un objeto _User_
- **network** : Una definición de la red

```
// paramsInvoke is an object who contains the needed elements for invoke a transaction
    let paramsInvoke = {
        // Channel Name, channel for executing the Request
        channelName: channelName,

        // Chaincode Name, identifies the chaincode to call
        chaincodeName: chaincodeName,

        // Chaincode function name to invoke
        functionName: functionName,

        // Array of String arguments for the function
        args: args,

        // Serialized Transient Map for a Transaction, see Fabric SDK
        transientMap: transientMap,

        // Modifier Flag
        flag: waitForBlock ? 'WAIT_FOR_BLOCK' : 'NONE'
    };

    // paramsQuery is an object who contains the needed elements for sends a chaincode query
    let paramsQuery = {
        // Channel Name, channel for executing the Request
        channelName: channelName,

        // Chaincode Name, identifies the chaincode to call
        chaincodeName: chaincodeName,

        // Chaincode function name to invoke
        functionName: functionName,

        // Array of String arguments for the function
        args: args,

        // Serialized Transient Map for a Transaction, see Fabric SDK
        transientMap: transientMap,

        // Call all available Peers for the Query
        flag: queryAllPeers ? 'QUERY_ALL_PEERS' : 'NONE'
    };

    // paramsChaincodeKeys represents a Request for all Model Keys from a given block number onwards, for a specific Smartcontract on a given Channel
    let paramsChaincodeKeys = {
        // Channel Name, channel for executing the Request
        channelName: channelName,

        // Chaincode Name, identifies the chaincode to scan for keys
        chaincodeName: chaincodeName,

        // RWSet Namespace, use null/blank to ignore (default). Namespace "lscc" will be always excluded
        namespace: namespace,

        // Block number from which start the scanning
        fromBlock: fromBlock
    };

    // rparamsChaincodeEvents epresents a Suscription Request for Chaincode-level customs events
    let paramsChaincodeEvents = {
        // Channel Name, channel for executing the Request
        channelName: channelName,

        // Chaincode Name, identifies the chaincode to listen for events
        chaincodeName: chaincodeName,

        // Name of the custom Chaincode event
        eventName: eventName,

        // Optional block number from which to start an event replay. Use "-1" to suscribe to the current live feed
        fromBlock: fromBlock
    };
    // paramsBlockEvents represents a Suscription Request for Block-level customs events
    let paramsBlockEvents = {
        // Channel Name, channel for executing the Request
        channelName: channelName,

        // Optional block number from which to start an event replay. Use "-1" to suscribe to the current live feed
        fromBlock: fromBlock
    };

    // Es un submensaje utilizado para enviar credenciales de autenticación para la solicitud.
    let user = {
        // Unique user ID
        identity: identity,

        // MSP ID of the User
        mspId: mspId,

        // PEM formatted binary private key
        privateKey: privateKey,

        // CER formatted binary public key
        certificate: certificate
    }

    //A network definition path, an Object with a Fabric network definition or a previously parsed file as a Buffer
    let {Buffer | String | Object } network;

```

**Métodos**

**invokeSmartContract**

```
const invokeSmartContract = async (paramsInvoke) => { return requestResult};
```

El método invokeSmartContract inicia una nueva solicitud de Transacción sobre un SmartContract/Canal de una red Fabric. Devuelve siempre una respuesta de tipo _requestResult_ que contiene el resultado del _endorsement_ de la transacción por parte del servicio de _Ordering_. En caso de un _endorsement_ correcto, enviará la transacción para su propagación.

A menos que se indique lo contrario, el método retornará inmediatamente apenas la transacción sea aceptada o rechazada. Es posible cambiar el comportamiento para que espere la propagación de la transacción a toda la red Fabric, mediante Flag.WAIT\_FOR\_BLOCK.


**querySmartContract**

```
const querySmartContract = async (paramsQuery) => { return requestResult};
```

El método querySmartContract inicia una nueva solicitud de Consulta sobre un SmartContract/Canal de una red Fabric. Devuelve siempre una respuesta de tipo _requestResult_ que contiene el resultado de la consulta, ya sea la respuesta a la consulta o un mensaje de error de la red Fabric o del servicio mismo.

A menos que se indique lo contrario, el método retornará inmediatamente el resultado del primer nodo Peer disponible. Es posible cambiar el comportamiento para que consulte a todos los Peers disponibles y compare el resultado, mediante Flag.QUERY\_ALL\_PEERS.


**chaincodeKeysFromBlocks**

```
const chaincodeKeysFromBlocks = async (paramsChaincodeKeys) => {return requestResult};
```

El método chaincodeKeysFromBlocks solicita todas las llaves primarias (_Keys_) de uno o todos los modelos de datos de un Smartcontract para un Canal dado, a partir de un número de bloque indicado.

El método devolverá todas las llaves válidas que hayan sido insertadas o modificadas mediante el método PutKey del SmartContract, o que hayan sido eliminadas correctamente mediante el método DelKey del mismo.


**streamChaincodeEvents**

```
const streamChaincodeEvents = async (paramsChaincodeEvents) => {return eventResult};
```

El método streamChaincodeEvents inicia la suscripción asíncrona al stream de eventos de Chaincode especificado en los parámetros de invocación. El servicio de cliente Fabric enviará todos los eventos de chaincode para el Smartcontract y el canal suscrito.

**streamBlockEvents**

```
const streamBlockEvents = async (paramsBlockEvents) => {return eventResult};
```

El método streamBlockEvents inicia la suscripción asíncrona al stream de eventos de bloque especificado en los parámetros de invocación. El servicio de cliente Fabric enviará todos los eventos de bloque para el canal suscrito.

**processUser**

```
const processUser = async (user) => {return User}
```

El método const processUser carga de manera asíncrona un usuario Fabric y sus certificados

**processNetwork**

```
const processNetwork = (network) => {return Buffer}
```

El método processNetwork carga de manera asíncrona una definición de una red Fabric en un Buffer y devuelve este último

#### Conectores de Blockchain

El Network Admin permite desplegar Smart Contracts, ejecutar acciones sobre Smart Contracts, leer el estado del ledger y gatillar otras Apps basándose en eventos del ledger.

Actualmente, se disponibiliza Network Admin para acceder a realizar operaciones sobre la red Blockchain:

```
const createChannel = async (channelEditParams) => {return result};

const updateChannel = async (channelEditParams) => {return result};

const joinChannel = async (channelParams) => { return result};

const channelCurrentConfig = async (channelParams) => { return result};

const installedChaincode = async (installedChaincodeParams) => { return result};

const latestChaincodeVersion = async (versionChaincodeParams) => { return result};

const installChaincode = async (chaincodeInstallParams) => { return result};

const instantiateChaincode = async (chaincodeInstantiateParams) => { return result};

const fullInstallChaincode = async (chaincodeInstallInstantiateParams) => { return result};

const processUser = async (user) => {return user};

const processNetwork = (network) => { return Buffer};
```

**Tipos de Mensajes**

Respuestas:

- **result** : respuesta estándar para llamadas al  **Network Admin**
- **user** : Respuesta para el procesamiento de un usuario

```
// result contains a generic response for blockchain-connectors functions

let result = {

status: isSuccess ? SUCCESS : ERROR,

message: message,

output: result

};

// User object tretrieved after load the User request element

let user = {

// Unique user ID

identity: identity,

// MSP ID of the User

mspId: mspId,

// PEM formatted binary private key

privateKey: privateKey,

// CER formatted binary public key

certificate: certificate,

// true, if user is loaded

loaded: loaded

}

// The network file with embedded certificates encodeded as a binary Buffer

let Buffer
```

Solicitudes:

- **channelEditParams** : Parámetros para crear o actualizar un canal
- **channelParams** : Parámetros para unirse a un canal existente, u obtener la configuración actual de un canal
- **installedChaincodeParams** : Parámetros para consultar los smartcontract instalados para una organización
- **versionChaincodeParams** : Parámetros para obtener la última versión instalada de un smartcontract
- **chaincodeInstallParams** : Parámetros para ejecutar la instalación de un smartcontract
- **chaincodeInstantiateParams** : Parámetros para instanciar un smartcontract
- **chaincodeInstallInstantiateParams** : Parámetros para instalar e instanciar un smartcontract
- **user** : Una cadena de string para el archivo de _User_ o un objeto _User_, para enviar las credenciales de autenticación
- **network** : Una definición de la red

```
// channelEditParams represents a request object for create or update a channel
    let channelEditParams = {
        // Organization ID
        org: org,

        // Channel Name, channel for executing the Request
        channelName: channelName,

        //The encoded bytes of the ConfigEnvelope protobuf
        envelopeBytes: envelopeBytes
    };

    // channelParams represents a request object for sends a join channel proposal / or obtain the current configuration of the channel
    let channelParams = {
        // Organization ID
        org: org,

        // Channel Name, channel for executing the Request
        channelName: channelName
    }

    // Queries the installed chaincodes for the organization.
    let installedChaincodeParams = {
        // Organization ID
        org: org
    };

    // Queries the latest chaincode version installed
    let versionChaincodeParams = {
        // Organization ID
        org: org,

        // Chaincode identification
        chaincodeName: chaincodeName
    };

    // params for install a SmartContract
    let chaincodeInstallParams = {
        // Organization ID
        org: org,

        // Channels for install the smartcontract
        channels: channels,

        //Chaincode identification
        chaincodeId: chaincodeId,

        //Version string of the chaincode, such as 'v1'
        chaincodeVersion: chaincodeVersion,

        // The path to the location of the source code of the chaincode
        chaincodePath: chaincodePath,

        // tar file with the source code of the chaincode
        chaincodeTar: chaincodeTar,

        // Type of chaincode. One of 'golang', 'car', 'node' or 'java'. Default is 'golang'
        chaincodeType: chaincodeType,

        // The path to the top-level directory containing metadata descriptors
        chaincodeMeta: chaincodeMeta
    }

    // params for instantiate a smartcontract
    let chaincodeInstantiateParams = {
        // Organization ID
        org: org,

        // Channel Name, channel for executing the Request
        channel: channel,

        //Chaincode identification
        chaincodeId: chaincodeId,

        //Version string of the chaincode, such as 'v1'
        chaincodeVersion: chaincodeVersion,

        // Type of chaincode. One of 'golang', 'car', 'node' or 'java'. Default is 'golang'
        chaincodeType: chaincodeType,

        // The function name to be returned when calling stub.GetFunctionAndParameters() in the target chaincode
        chaincodeFcn: chaincodeFcn,

        //  Array of string arguments to pass to the function identified by the fcn value
        chaincodeArgs: chaincodeArgs,

        // EndorsementPolicy object for this chaincode
        endorsement: endorsement,

        // Object with String property names and Buffer property values
        chaincodeTransient: chaincodeTransient,

        // send upgrade chaincode proposal
        upgrade: upgrade
    };

    // params for install and instantiate a smartcontract
    let chaincodeInstallInstantiateParams = {
        // Organization ID
        orgs: orgs,

        // Channel Name, channel for executing the Request
        channel: channel,

        //Chaincode identification
        chaincodeId: chaincodeId,

        //Version string of the chaincode, such as 'v1'
        chaincodeVersion: chaincodeVersion,

        // The path to the location of the source code of the chaincode
        chaincodePath: chaincodePath,

        // tar file with the source code of the chaincode
        chaincodeTar: chaincodeTar,

        // Type of chaincode. One of 'golang', 'car', 'node' or 'java'. Default is 'golang'
        chaincodeType: chaincodeType,

        // The path to the top-level directory containing metadata descriptors
        metadataPath: chaincodeMeta,

        // The function name to be returned when calling stub.GetFunctionAndParameters() in the target chaincode
        fcn: chaincodeFcn,

        //  Array of string arguments to pass to the function identified by the fcn value
        args: chaincodeArgs,

        // EndorsementPolicy object for this chaincode
        endorsement: endorsement,

        // Object with String property names and Buffer property values
        transientMap: chaincodeTransient,

        // bump up the version number. values: MAYOR, MINOR, REVISION
        bumpType: bumpType
    };

    //Es un submensaje utilizado para enviar credenciales de autenticación para la solicitud.
    let user = {
        // Unique user ID
        identity: identity,

        // MSP ID of the User
        mspId: mspId,

        // PEM formatted binary private key
        privateKey: privateKey,

        // CER formatted binary public key
        certificate: certificate
    }

    //A network definition path, an Object with a Fabric network definition or a previously parsed file as a Buffer
    let {Buffer | String | Object } network;

```

**Métodos**

**createChannel**

```
const createChannel = async (channelEditParams) => {return result};
```

El método createChannel realiza una llamada al _orderer_ para comenzar a construir el nuevo canal. Un canal típicamente tiene más de una organización participante.

Una vez que el _orderer_ crea con éxito el canal, el siguiente paso es hacer que los peer de cada organización se unan al _channel_, enviando la configuración del canal a cada uno de los _peer_. El paso se completa llamando al método joinChannel.


**updateChannel**

```
const updateChannel = async (channelEditParams) => {return result};
```

El método updateChannel realiza una llamada al _orderer_ para actualizar un canal existente.

Después de que el _orderer_ procesa con éxito las actualizaciones del canal, el _orderer_ corta un nuevo bloque que contiene la nueva configuración del canal y lo entrega a todos los _peer_ participantes en el canal.


**joinChannel**

```
const joinChannel = async (channelParams) => { return result};
```

El método joinChannel realiza una llamada para unirse al canal a uno o más _peer_


**channelCurrentConfig**

```
const channelCurrentConfig = async (channelParams) => { return result};
```

El método ChannelCurrentConfig realiza una llamada para obtener el bloque de configuración actual (más reciente) para el canal consultado


**installedChaincode**

```
const installedChaincode = async (installedChaincodeParams) => { return result};
```

El método installedChaincode consulta los smartcontract instalados en un _peer_


**latestChaincodeVersion**

```
const latestChaincodeVersion = async (versionChaincodeParams) => { return result};
```

El método latestChaincodeVersion obtiene la última versión instalada de un smartcontract


**installChaincode**

```
const installChaincode = async (chaincodeInstallParams) => { return result};
```

El método installChaincode instala un smartcontract


**instantiateChaincode**

```
const instantiateChaincode = async (chaincodeInstantiateParams) => { return result};
```

El método instantiateChaincode instancia un smartcontract instalado previamente


**fullInstallChaincode**

```
const fullInstallChaincode = async (chaincodeInstallInstantiateParams) => { return result};
```

El método fullInstallChaincode es una combinación de los métodos installChaincode y instantiateChaincode, obtiene la versión actual del smartcontract (si existe) y sube el número de versión


**processUser**

```
const processUser = async (user) => {return User}
```

El método const processUser carga de manera asíncrona un usuario Fabric y sus certificados

**processNetwork**

```
const processNetwork = (network) => {return Buffer}
```

El método processNetwork carga de manera asíncrona una definición de una red Fabric en un Buffer y devuelve este último

#### Librería de servicios

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

###### Servicio de Administración de Reportes

El servicio de Administración de Reportes permite configurar, crear y consultar reportes en formato PDF.

Los reportes PDF se generan usando una plantilla JRXML (JasperReport template).

**Definición del Servicio**

Se disponibiliza un servicio gRPC ReportAdminSevice para la gestión de reportes:

```
service ReportAdminSevice {

// Create a Report Template

rpc CreateTemplate (CreateTemplateRequest) returns (RequestResult);

// Create a Report

rpc CreateReport (CreateReportRequest) returns (RequestResult);

// Query data Report

rpc GetDataReport (GetDataReportRequest) returns (RequestResult);

// Get a Report by ID

rpc GetReport (GetReportRequest) returns (ReportResult);

// Get report checks by Checksum

rpc GetReportByCheckSum (GetReportByCheckSumRequest) returns (ReportResult);

// Get report checksum

rpc GetReportCheckSum (GetReportCheckSumRequest) returns (RequestResult);

}
```

**Tipos de Mensajes**

_Respuestas:_

- **RequestResult** : Respuesta estándar para llamadas al servicio.
- **ReportResult** : Respuesta que contiene un reporte en formato binario.

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

// String output payload from the Service

string output = 3;

}

message ReportResult {

enum Status {

ERROR = 0;

SUCCESS = 1;

}

// Contains the Success/Error result status

Status status = 1;

// Description of the result and additional error messages

string message = 2;

// Binary output payload from the Service

binary output = 3;

}
```

**Solicitudes** _:_

- **User** : Submensaje utilizado para enviar credenciales de autenticación en la solicitud.
- **CreateTemplateRequest** : Solicitud utilizada para crear una plantilla de reporte.
- **CreateReportRequest** : Solicitud utilizada para crear un reporte.
- **GetDataReportRequest** : Solicitud utilizada para obtener los datos reporte a través de su identificador.
- **GetReportRequest** : Solicitud utilizada para obtener un reporte a través de su identificador.
- **GetReportByCheckSumRequest** : Solicitud utilizada para obtener un reporte a través de su checksum.
- **GetReportCheckSumRequest** : Solicitud utilizada para obtener el checksum de un reporte.

```
message User {

// Unique user ID

string userid = 1;

}

message CreateTemplateRequest {

// User for authentication

User user = 1;

// Nombre de la plantila

string name = 2;

// Plantilla de reporte

string jrxml = 3;

// Configuración de datasource necesario para obtener los datos de los reportes

string datasource = 4;

}

message CreateReportRequest {

// User for authentication

User user = 1;

// Parámetros de llamada al datasource que pemite obtener los datos para la creación del reporte

string params = 2;

// Id de plantilla de reporte

string idtemplate = 3;

}

message GetDataReportRequest {

// User for authentication

User user = 1;

// Id del reporte

string id = 2;

}

message GetReportRequest {

// User for authentication

User user = 1;

// Id del reporte

string id = 2;

}

message GetReportByCheckSumRequest {

// User for authentication

User user = 1;

// Checksum del reporte

string checksum = 2;

}

message GetReportCheckSumRequest {

// User for authentication

User user = 1;

// Id del reporte

string id = 2;

}
```

**Métodos**

**CreateTemplate**

```
rpc CreateTemplate (CreateTemplateRequest) returns (RequestResult);
```

El método CreateTemplate permite crear una plantilla de reporte. Debe proporcionar el archivo JRXML y la configiración del datasource.

**CreateReport**

```
rpc CreateReport (CreateReportRequest) returns (RequestResult);
```

El método CreateReport permite crear un reporte. Se deben proporcionar los parámetros de llamada al datasource para obtener los datos del reporte e indicar cual plantilla de reporte se debe utilizar.

**GetDataReport**

```
rpc GetDataReport (GetDataReportRequest) returns (RequestResult);
```

El método GetDataReport permite obtener los datos con los cuales se ha construido un reporte específico.

**GetReport**

```
rpc GetReport (GetReportRequest) returns (ReportResult);
```

El método GetReport permite obtener un reporte a través de su identificador.

**GetReportByCheckSum**

```
rpc GetReportByCheckSum (GetReportByCheckSumRequest) returns (ReportResult);
```

El método GetReportByCheckSum permite obtener un reporte a través de su checksum.

**GetReportCheckSum**

```
rpc GetReportCheckSum (GetReportCheckSumRequest) returns (RequestResult);
```

El método GetReportCheckSum permite obtener el checksum de un reporte.

###### Servicio de Visualización de Reportes

El  **servicio de Visualización de Reportes** , permite visualizar reportes en formato PDF.

**Definición del Servicio**

Se disponibiliza un servicio gRPC  **ReportViewSevice**  para poder utilizar el servicio de reportes:

```
service ReportViewSevice {

// Get a Report by ID

rpc GetReport (GetReportRequest) returns (ReportResult);

// Get report checks by Checksum

rpc GetReportByCheckSum (GetReportByCheckSumRequest) returns (ReportResult);

// Get report checksum

rpc GetReportCheckSum (GetReportCheckSumRequest) returns (RequestResult);

}
```

**Tipos de Mensajes**

_Respuestas:_

- **RequestResult** : Respuesta estándar para llamadas al servicio.
- **ReportResult** : Respuesta que contiene un reporte en formato binario.

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

// String output payload from the Service

string output = 3;

}

message ReportResult {

enum Status {

ERROR = 0;

SUCCESS = 1;

}

// Contains the Success/Error result status

Status status = 1;

// Description of the result and additional error messages

string message = 2;

// Binary output payload from the Service

binary output = 3;

}
```

**Solicitudes:**

- **User** : Submensaje utilizado para enviar credenciales de autenticación en la solicitud.
- **GetReportRequest** : Solicitud utilizada para obtener un reporte a través de su identificador.
- **GetReportByCheckSumRequest** : Solicitud utilizada para obtener un reporte a través de su checksum.
- **GetReportCheckSumRequest** : Solicitud utilizada para obtener el checksum de un reporte.

```
message User {

// Unique user ID

string userid = 1;

}

message GetReportRequest {

// User for authentication

User user = 1;

// Id del reporte

string id = 2;

}

message GetReportByCheckSumRequest {

// User for authentication

User user = 1;

// Checksum del reporte

string checksum = 2;

}

message GetReportCheckSumRequest {

// User for authentication

User user = 1;

// Id del reporte

string id = 2;
```

**Métodos**

**GetReport**

```
rpc GetReport (GetReportRequest) returns (ReportResult);
```

El método GetReport permite obtener un reporte a través de su identificador.

**GetReportByCheckSum**

```
rpc GetReportByCheckSum (GetReportByCheckSumRequest) returns (ReportResult);
```

El método GetReportByCheckSum permite obtener un reporte a través de su checksum.

**GetReportCheckSum**

```
rpc GetReportCheckSum (GetReportCheckSumRequest) returns (RequestResult);
```

El método GetReportCheckSum permite obtener el checksum de un reporte.

###### Servicio de Correo

El  **Servicio de Correo**  permite enviar correos a los usuarios finales de las aplicaciones.

**Definición del Servicio**

Se disponibiliza un servicio gRPC  **MailSevice**  el cual permite el envío de correos:

```
service MailSevice {

// Create a email

rpc SendMail (SendMailRequest) returns (RequestResult);

}
```

**Tipos de Mensajes**

Respuestas:

- **RequestResult** : Respuesta estándar para llamadas al Servicio

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

string output = 3

}
```

Solicitudes:

- **User** : Submensaje utilizado para enviar credenciales de autenticación en la solicitud.
- **SendMailRequest** : Solicitud utilizada para enviar un correo.

```
message User {

// Unique user ID

string userid = 1;

}

message SendMailRequest {

// User for authentication

User user = 1;

// Subject field

string subject = 2;

// from field

string from = 3;

// to field

string to = 4;

// Content email

string content= 5;

// content type text/html

string contenttype = 6;

}
```

**Métodos**

**SendMail**

```
rpc SendMail (SendMailRequest) returns (RequestResult);
```

El método SendMail permite enviar un correo electrónico en formato texto o html.

###### Servicio para Conexión a Interfaces Externas

El  **Servicio para Conexión a Interfaces Externas**  permite realizar llamadas a una API&#39;s Externas.

**Definición del Servicio**

Se disponibiliza un servicio gRPC de nombre  **GatewayService**  :

```
service GatewayService {

rpc Call ( DefaultRequest ) returns( CallResponse );

rpc Get ( NormalRequest ) returns( CallResponse );

rpc Delete ( NormalRequest ) returns( CallResponse );

rpc Head ( NormalRequest ) returns( CallResponse );

rpc Options ( NormalRequest ) returns( CallResponse );

rpc Post ( DataRequest ) returns( CallResponse );

rpc Put ( DataRequest ) returns( CallResponse );

rpc Patch ( DataRequest ) returns( CallResponse );

}
```

**Tipos de Mensajes**

**Solicitudes:**

- **DefaultRequest** : Request por defecto para una llamada a una API externa.
- **NormalRequest** : Request que pide por obligación una URL, utiliza una configuración especificada por el usuario.
- **DataRequest** : Request que envía data en la llamada a una API externa.

```
message Config {

bytes Data = 1;

}

message DefaultRequest {

Config conf = 1;

}

message NormalRequest {

string url = 1;

Config conf = 2;

}

message DataRequest {

string url = 1;

Config conf = 2;

bytes Data = 3;

}
```

**Request Config**

A continuación, se muestran los parámetros que se pueden enviar en la configuración de la llamada a una API externa, valores de variables solo de ejemplo:

```
Config conf
{

    // "url" is the server URL that will be used for the request
    url: "/user",

    // "method" is the request method to be used when making the request
    method: "get", // default

    // "baseURL" will be prepended to "url" unless "url" is absolute.
    // It can be convenient to set "baseURL" for an instance of axios to pass relative URLs
    // to methods of that instance.
    baseURL: "https://some-domain.com/api/",

    // "headers" are custom headers to be sent
    headers: {"X-Requested-With": "XMLHttpRequest"},

    // "params" are the URL parameters to be sent with the request
    // Must be a plain object or a URLSearchParams object
    params: {
        ID: 12345
    },

    // "data" is the data to be sent as the request body
    // Only applicable for request methods "PUT", "POST", "DELETE , and "PATCH"
    data: {
        firstName: "Joffrey"
    },

    // syntax alternative to send data into the body
    // method post
    // only the value is sent, not the key
    data: "Country=Brasil&City=Belo Horizonte",

    // "timeout" specifies the number of milliseconds before the request times out.
    // If the request takes longer than "timeout", the request will be aborted.
    timeout: 1000, // default is "0" (no timeout)

    // "withCredentials" indicates whether or not cross-site Access-Control requests
    // should be made using credentials
    withCredentials: false, // default

    // "auth" indicates that HTTP Basic auth should be used, and supplies credentials.
    // This will set an "Authorization" header, overwriting any existing
    // "Authorization" custom headers you have set using "headers".
    // Please note that only HTTP Basic auth is configurable through this parameter.
    // For Bearer tokens and such, use "Authorization" custom headers instead.
    auth: {
        username: "johnwick",
        password: "s3cr3t0001"
    },

    // "responseType" indicates the type of data that the server will respond with
    // options are: "arraybuffer", "document", "json", "text", "stream"
    responseType: "json", // default

    // "responseEncoding" indicates encoding to use for decoding responses (Node.js only)
    // Note: Ignored for "responseType" of "stream" or client-side requests
    responseEncoding: "utf8", // default

    // "xsrfCookieName" is the name of the cookie to use as a value for xsrf token
    xsrfCookieName: "XSRF-TOKEN", // default

    // "xsrfHeaderName" is the name of the http header that carries the xsrf token value
    xsrfHeaderName: "X-XSRF-TOKEN", // default

    // "maxContentLength" defines the max size of the http response content in bytes allowed in node.js
    maxContentLength: 2000,

    // "maxBodyLength" (Node only option) defines the max size of the http request content in bytes allowed
    maxBodyLength: 2000,

    // "maxRedirects" defines the maximum number of redirects to follow in node.js.
    // If set to 0, no redirects will be followed.
    maxRedirects: 5, // default

    // "socketPath" defines a UNIX Socket to be used in node.js.
    // e.g. "/var/run/docker.sock" to send requests to the docker daemon.
    // Only either "socketPath" or "proxy" can be specified.
    // If both are specified, "socketPath" is used.
    socketPath: null, // default

    // "proxy" defines the hostname and port of the proxy server.
    // Use "false" to disable proxies, ignoring environment variables.
    // "auth" indicates that HTTP Basic auth should be used to connect to the proxy, and
    // supplies credentials.
    // This will set an "Proxy-Authorization" header, overwriting any existing
    // "Proxy-Authorization" custom headers you have set using "headers".
    proxy: {
        host: "127.0.0.1",
        port: 8000,
        auth: {
        username: "hermes",
        password: "p4r4c3lsus"
        }
    },

    // "decompress" indicates whether or not the response body should be decompressed 
    // automatically. If set to "true" will also remove the "content-encoding" header 
    // from the responses objects of all decompressed responses
    // - Node only (XHR cannot turn off decompression)
    decompress: false // default

    }

```

**Respuestas:**

- **CallResponse** : Respuesta de una llamada a una API externa.

```
message CallResponse {

	enum Status {
		ERROR = 0;
		SUCCESS = 1;
	}

	// "status" is the HTTP status code from the server response
	Status status = 1;

	// "data" is the response that was provided by the server
	bytes data

	// "statusText" is the HTTP status message from the server response
	string statusText 

	// "headers" the HTTP headers that the server responded with
	// All header names are lower cased and can be accessed using the bracket notation.
	// Example: "response.headers["content-type"]"
	bytes headers 

	// "config" is the config that was provided to "GatewayService" for the request
	bytes config

	// "request" is the request that generated this response
	// It is the last Request instance
	// and an XMLHttpRequest instance in the browser
	bytes request

}

```

**Métodos**

**Call**

```
rpc Call ( DefaultRequest ) returns( CallResponse );
```

El método Call permite realizar llamadas a una API externa.

**Get**

```
rpc Get ( NormalRequest ) returns( CallResponse );
```

El método Get permite realizar solicitudes a una API externa utilizando el método GET.

**Delete**

```
rpc Delete ( NormalRequest ) returns( CallResponse );
```

El método Delete permite realizar solicitudes a una API externa utilizando el método DEL.

**Head**

```
rpc Head ( NormalRequest ) returns( CallResponse );
```

El método Head permite realizar solicitudes a una API externa utilizando un head especificado por el usuario.

**Options**

```
rpc Options ( NormalRequest ) returns( CallResponse );
```

El método Options permite realizar solicitudes a una API externa utilizando opciones específicas.

**Post**

```
rpc Post ( DataRequest ) returns( CallResponse );
```

El método Post permite realizar solicitudes a una API externa utilizando el método POST.

**Put**

```
rpc Put ( DataRequest ) returns( CallResponse );
```

El método Put permite realizar solicitudes a una API externa utilizando el método PUT.

**Patch**

```
rpc Patch ( DataRequest ) returns( CallResponse );
```

El método Patch permite realizar solicitudes a una API externa utilizando el método PATCH.

**Ejemplo de Uso**

Ejemplo de una solicitud GET

```
const externalAPI = grpc.loadPackageDefinition(packageDefinition).baas.externalApi.gatewayService;
const baseURL = 'localhost' + ':' + '9000';

var NormalRequest = {
	"conf": {
		"Data": {
			"baseURL": "https://some-domain.com/api/",
			"headers": "{'X-Requested-With': 'XMLHttpRequest'}",
			"data": "Country=Brasil&City=Belo Horizonte",
			"withCredentials": false, 
			"responseType": "json", 
			"responseEncoding": "utf8", 
			"xsrfCookieName": "XSRF-TOKEN", 
			"xsrfHeaderName": "X-XSRF-TOKEN", 
			"maxContentLength": 2000,
			"maxBodyLength": 2000,
			"decompress": true 
		}
	}
	"url":"/user"
}

var stub = new externalAPI.GatewayService(baseURL, grpc.credentials.createInsecure());

stub.Get(NormalRequest, (err, CallResponse) => {
	if (err) {
		console.log(err)
	}
	console.log(CallResponse);
});

```

##### Librerías de Smartcontracts

###### Golang (Go)

Las librerías comunes de smartcontracts disponibles para Go son las siguientes:

- Business Day Chaincode (bd)
- Brokerage Houses Chaincode (bh)
- Pention Fund (pf)
- Scheduler Chaincode (scheduler)
- Valid Securities (vs)

_Funciones comunes de Smartcontracts_

Business Day Chaincode

**getNextBusinessDay**

Devuelve el siguiente día hábil para una fecha determinada y el SettlementType toma el código auxiliar y una cadena con formato JSON que contiene los datos. Devuelve un objeto Success con el resultado en el payload.

```
func (c \*BDChaincode) getSettlementDay(stub shim.ChaincodeStubInterface, jsonSnip string) pb.Response {}
```

**lookup**

Se usa para encontrar un registro específico basado en su clave única, toma una cadena de identificación para buscar la fecha de proceso enviar &quot;PROCESS\_DATE&quot; como argumentos para buscar una fecha, envía la fecha en formato &quot;aaaa-mm-dd&quot; como argumentos y devuelve un &quot;success&quot; con todo el registro en el payload.

```
func (c \*BDChaincode) lookup(stub shim.ChaincodeStubInterface, id string) pb.Response {}
```

**returnAll**

Devuelve una lista filtrada de todos los días festivos en la red. No admite entradas. Devuelve un objeto Success con el resultado en el payload.

```
func (c \*BDChaincode) returnAll(stub shim.ChaincodeStubInterface) pb.Response {}
```

Brokerage Houses Chaincode

**find**

Se utiliza para realizar una búsqueda de consulta enriquecida, lo que significa que puede buscar con cualquier término permitido por la base de datos Couch subyacente. Esto se usa principalmente para buscar por un campo determinado o un conjunto de campos. Actualmente admite operaciones AND y OR, y potencialmente más. Coincidencias exactas. Toma una consulta Couch con formato JSON y genera un objeto Success con el resultado de la consulta en el payload.

```
func (c \*BHChaincode) find(stub shim.ChaincodeStubInterface, jsonSnip string) pb.Response {}
```

**lookup**

Utilizada para encontrar un registro específico basado en su clave única (BrokerageID).

```
func (c \*BHChaincode) lookup(stub shim.ChaincodeStubInterface, key string) pb.Response {}
```

**returnAll**

Actualmente devuelve TODAS las casas de corretaje en la red, incluso las que tienen fecha de finalización. Si desea devolver todos los BrokeageHouses válidos, utilice una búsqueda enriquecida en su lugar. No tiene entrada. Devuelve un objeto de éxito.

```
func (c \*BHChaincode) returnAll(stub shim.ChaincodeStubInterface) pb.Response {}
```

**returnRUT**

Obtiene el RUT de una brokerage house utilizando el BrokerageID como criterio de búsqueda.

```
func (c \*BHChaincode) returnRUT(stub shim.ChaincodeStubInterface, brokerageID string) pb.Response {}
```

Pention Fund

**find**

Se utiliza para realizar una búsqueda de consulta enriquecida, lo que significa que puede buscar con cualquier término permitido por la base de datos Couch subyacente. Esto se usa principalmente para buscar por un campo determinado o un conjunto de campos. Actualmente admite operaciones AND y OR, y potencialmente más. Coincidencias exactas. Toma una consulta Couch con formato JSON y genera un objeto Success con el resultado de la consulta en el payload.

```
func (c \*PFChaincode) find(stub shim.ChaincodeStubInterface, jsonSnip string) pb.Response {}
```

**lookup**

Utilizada para encontrar un registro específico basado en su clave única (MSAID).

```
func (c \*ScheduleChaincode) lookup(stub shim.ChaincodeStubInterface, id string) pb.Response {}
```

**returnAll**

Devuelve una lista filtrada de fondos de pensiones en la red. No admite entradas. Devuelve un objeto Success con el resultado en el payload.

```
func (c \*PFChaincode) returnAll(stub shim.ChaincodeStubInterface) pb.Response {}
```

Scheduler Chaincode

**lookup**

Utilizada para encontrar un registro específico basado en su clave única.

```
func (c \*ScheduleChaincode) lookup(stub shim.ChaincodeStubInterface, id string) pb.Response {}
```

**returnSchedule**

```
func (c \*ScheduleChaincode) returnSchedule(stub shim.ChaincodeStubInterface) pb.Response {}
```

Valid Securities

**find**

Se utiliza para realizar una búsqueda de consulta enriquecida, lo que significa que puede buscar con cualquier término permitido por la base de datos Couch subyacente. Esto se usa principalmente para buscar por un campo determinado o un conjunto de campos. Actualmente admite operaciones AND y OR, y potencialmente más. Coincidencias exactas. Toma una consulta Couch con formato JSON y genera un objeto Success con el resultado de la consulta como payload.

```
func (c \*VSChaincode) find(stub shim.ChaincodeStubInterface, jsonSnip string) pb.Response {}
```

**getByDate**

Se usa para hacer una búsqueda de consulta histórica por el registro KEY (Symbol).

```
func (c \*VSChaincode) getByDate(stub shim.ChaincodeStubInterface, jsonSnip string) pb.Response {}
```

**getHistory**

Se usa para hacer una búsqueda de consulta histórica por el registro KEY (Symbol).

```
func (c \*VSChaincode) getHistory(stub shim.ChaincodeStubInterface, jsonSnip string) pb.Response {}
```

**lookup**

Utilizada para encontrar un registro específico basado en su clave única.

```
func (c \*VSChaincode) lookup(stub shim.ChaincodeStubInterface, key string) pb.Response {}
```

**returnAll**

Actualmente devuelve todos los valores válidos en la red. No admite entradas. Devuelve un objeto de éxito con una cadena de todos los valores o un error.

```
func (c \*VSChaincode) returnAll(stub shim.ChaincodeStubInterface) pb.Response {}
```

_Librería común entre Smartcontracts_

Las siguientes funciones están bajo la librería &quot;commons&quot;, librería común dentro de los Smartcontracts anteriormente mencionados:

Funciones comunes de transformación de datos

- **stringToMap**

Toma una cadena y devuelve un objeto map.

```
func stringToMap(jsonString string) map[string]string {}
```

- **makeMap**

Crea un objeto de map a partir de un string JSON.

```
func makeMap(jsonSnip string) map[string]string {}
```

Funciones comunes shim

- **query**

Ejecuta una consulta en la Worldstate DB.

```
func query(stub shim.ChaincodeStubInterface, jsonSnip string) ([]string, error) {}
```

- **iterateThroughQuery**

Toma un objeto iterador y devuelve una cadena de todos los registros del conjunto.

```
func iterateThroughQuery(iter shim.StateQueryIteratorInterface) ([]byte, error) {}
```

- **iterateThroughQueryKeys**

Toma un objeto iterador y devuelve una cadena de todas las claves del conjunto.

```
func iterateThroughQueryKeys(iter shim.StateQueryIteratorInterface) ([]string, error) {}
```

Funciones comunes de validación

- **validateRUT**

Usado para verificar que un valor dado es un RUT chileno legal. Toma un valor de cadena para un RUT y devuelve una cadena que define si el RUT es válido o no.

```
func validateRUT(strRut string) string {}
```

Métodos de validacion comunes para chaincode calls

- **validateBH**

Comprueba la lista almacenada de Casas de corretaje para asegurarse de que al menos una entrada tiene el valor dado en el campo seleccionado. Los valores de datos de corretaje para un MSA determinado coinciden con el mismo BH. req no se puede corregir siempre que la función de validación esté tomando un campo a la vez. Toma dos cadenas para el campo y el valor que devuelve es booleano.

```
func validateBH(stub shim.ChaincodeStubInterface, bhID string) bool {}
```

- **validateSymbol**

Comprueba la lista almacenada de valores para asegurarse de que el símbolo existe y es válido para el tipo de lenging. Devuelve un booleano si se encuentra y es válido.

```
func validateSymbol(stub shim.ChaincodeStubInterface, symbol string, laType string) bool {}
```

##### Programador de tareas

Biblioteca para el repositorio de Cron-Tasks del Programador de tareas.

**Definición del Servicio**

Se disponibiliza un servicio gRPC  **TaskRepoService** para poder utilizar el servicio de programador de tareas:

```
service TaskRepoService {

rpc CreateTask ( ModifyRepoRequest ) returns ( ConfirmResponse );

rpc UpdateTask ( ModifyTaskRepoRequest ) returns ( ConfirmResponse );

rpc UpdateCron ( ModifyCronRepoRequest ) returns ( ConfirmResponse );

rpc GetTask ( GetTaskRepoRequest ) returns ( TaskRepoResponse );

}
```

**Tipos de Mensajes**

_Respuestas:_

- **ConfirmResponse** : Respuesta estándar para llamadas al servicio.
- **TaskRepoResponse** : Respuesta que contiene la data, configuración y status del request enviado al programador de tareas.

```
message ConfirmResponse {
   // Valid resource access. True if authorzed, false otherwise
   bool Valid = 1;
   // Return Zero when no internal errors 
   int32 InternalError = 2;
   // Return Error Message
   string ErrorMessage = 3;
 }

message TaskRepoResponse {
 
  enum Status {
    ERROR = 0;
    SUCCESS = 1;
}

// "status" is the ConfigRepoService status code from the repository response
Status StatusResult = 1;

// "data" is the response that was provided by the repository
string Data = 2;

// "Config" is the Config that was provided to "ConfigRepoService" for the request
string Config = 3;

}
```

**Solicitudes**

- **ModifyRepoRequest:** solicitud utilizada para enviar los datos necesarios para la creación de una tarea programada
- **ModifyTaskRepoRequest:** solicitud utilizada para modificar una tarea tarea programada
- **ModifyCronRepoRequest:** solicitud utilizada para modificar el tiempo de una tarea programada
- **GetTaskRepoRequest:** solicitud utilizada para obtener los datos de una tarea programada

```
message ModifyRepoRequest {

string IdIsv = 1;

string IdApp = 2;

string TaskTag = 3;

string Tasks = 4;

string Description = 5;

string Cronjob = 6;

}

message ModifyTaskRepoRequest {

string IdIsv = 1;

string IdApp = 2;

string TaskTag = 3;

string Tasks = 4;

}

message ModifyCronRepoRequest {

string IdIsv = 1;

string IdApp = 2;

string TaskTag = 3;

string Cronjob = 6;

}

message GetTaskRepoRequest {

string IdIsv = 1;

string IdApp = 2;

string TaskTag = 3;

bool GetAllTasks = 4;

}
```

**Métodos**

**CreateTask**

```
rpc CreateTask ( ModifyRepoRequest ) returns ( ConfirmResponse );
```

Crear configuraciones en el repositorio

**UpdateTask**

```
rpc UpdateTask ( ModifyTaskRepoRequest ) returns ( ConfirmResponse );
```

actualizar configuraciones en el repositorio

**UpdateCron**

```
rpc UpdateCron ( ModifyCronRepoRequest ) returns ( ConfirmResponse );
```

actualiza un cron de una tarea en el repositorio

**GetTask**

```
rpc GetTask ( GetTaskRepoRequest ) returns ( TaskRepoResponse );
```

obtener tarea desde el repositorio

##### Sistema de alertas

###### Alertas para tareas programadas

Cuando las tareas programadas que ha agendado terminen con error, se registrará una alerta en el repositorio central de alertas. Un sistema de procesamiento de alertas tomará las alertas pertenecientes a cada ISV y les enviará una notificación por el canal que el ISV haya definido.


##### Auna Packer

Auna Packer es una librería Node que valida la estructura de archivos y directorios de una D-App, finalmente la empaqueta para que sea publicada. Esta librería puede ser usada como dependencia de desarrollo en proyectos Typescript o a través de Shell (requiere instalación de forma global).

_https://npm.aunablockchain.com/-/web/detail/@bcs/auna-packer_.

### Servicios mockup

##### Servicio mockup de Reportes

Para el desarrollo de reportes existen servicios que son accesibles sólo desde la plataforma, es por ello que se han creado servicios mockup para que los desarrolladores puedan simular las diferentes llamadas que se puedan realizar. Para esto se han disponibilizado las siguientes imágenes en el [Registro de Imágenes](http://registry.aunablockchain.com/) de docker para AUNA.

_Para revisar este acceso puedes abrir en una navegador web con la siguiente dirección_
 (Registro de imágenes)[http://registry.aunablockchain.com/]

##### Servicio mockup de templates para reportes

Para interactuar con el repositorio de templates existe un servicio mockup que simula el almacenamiento y obtención de las plantillas de reportes y se puede obtener mediante el siguiente comando:

```
docker pull registry.aunablockchain.com/sdk/auna-report-template-mockup:v1.0.0-node14
```

y puedes correr el servicio mediante:

```
docker run --name auna-report-template-api -p 3070:3070 registry.aunablockchain.com/sdk/auna-report-template-mockup:v1.0.0-node14
```

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

##### Servicios mockup de Correos

AUNA ofrece un servicio de correos que permite consultar plantillas de correos y enviar correos. Para los desarrollos que necesiten la utilización de correos existen servicios que son accesibles sólo desde la plataforma, es por ello que se han creado servicios mockup para que los desarrolladores puedan simular las diferentes llamadas que se puedan realizar. Para esto se han disponibilizado las siguientes imágenes en el [Registro de Imágenes](http://registry.aunablockchain.com/) de docker para AUNA.

_Para revisar este acceso puedes abrir en una navegador web con la siguiente dirección_
 (Registro de imagenes)[http://registry.aunablockchain.com/]

##### Servicio mockup de templates para correos

Para interactuar con el repositorio de templates existe un servicio mockup que simula el almacenamiento y obtención de las plantillas de correos y se puede obtener mediante el siguiente comando:

```
docker pull registry.aunablockchain.com/sdk/auna-mail-template-mockup:v1.0.0-node14
```

y puedes correr el servicio mediante:

```
docker run --name auna-mail-template-api -p 3051:3051 registry.aunablockchain.com/sdk/auna-mail-template-mockup:v1.0.0-node14
```

##### Servicio mockup para el envío de correos

Para simular el envío de correo se creó el servicio mockup respectivo que simula el envío del correo y la imagen se puede obtener mediante el comando:

```
docker pull registry.aunablockchain.com/sdk/auna-mail-service-mockup:v1.0.0-node14
```

y el servicio se puede correr mediante:

```
docker run --name auna-mail-service-api -p 3101:3101 registry.aunablockchain.com/sdk/auna-mail-service-mockup:v1.0.0-node14
```