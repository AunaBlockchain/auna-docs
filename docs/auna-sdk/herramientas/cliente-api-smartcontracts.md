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
