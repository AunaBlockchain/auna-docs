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
