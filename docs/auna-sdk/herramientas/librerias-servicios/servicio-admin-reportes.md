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

