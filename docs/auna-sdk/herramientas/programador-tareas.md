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

