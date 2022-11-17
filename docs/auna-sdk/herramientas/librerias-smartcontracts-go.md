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
