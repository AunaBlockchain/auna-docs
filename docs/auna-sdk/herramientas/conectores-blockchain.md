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
