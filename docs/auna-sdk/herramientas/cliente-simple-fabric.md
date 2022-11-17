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

