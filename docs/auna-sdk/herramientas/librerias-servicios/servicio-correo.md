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
