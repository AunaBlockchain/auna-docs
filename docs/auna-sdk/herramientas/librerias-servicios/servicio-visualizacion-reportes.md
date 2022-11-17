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
