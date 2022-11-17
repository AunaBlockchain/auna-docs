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
