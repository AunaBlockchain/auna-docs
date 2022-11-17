###### Servicio para Conexión a Interfaces Externas

El  **Servicio para Conexión a Interfaces Externas**  permite realizar llamadas a una API&#39;s Externas.

**Definición del Servicio**

Se disponibiliza un servicio gRPC de nombre  **GatewayService**  :

```
service GatewayService {

rpc Call ( DefaultRequest ) returns( CallResponse );

rpc Get ( NormalRequest ) returns( CallResponse );

rpc Delete ( NormalRequest ) returns( CallResponse );

rpc Head ( NormalRequest ) returns( CallResponse );

rpc Options ( NormalRequest ) returns( CallResponse );

rpc Post ( DataRequest ) returns( CallResponse );

rpc Put ( DataRequest ) returns( CallResponse );

rpc Patch ( DataRequest ) returns( CallResponse );

}
```

**Tipos de Mensajes**

**Solicitudes:**

- **DefaultRequest** : Request por defecto para una llamada a una API externa.
- **NormalRequest** : Request que pide por obligación una URL, utiliza una configuración especificada por el usuario.
- **DataRequest** : Request que envía data en la llamada a una API externa.

```
message Config {

bytes Data = 1;

}

message DefaultRequest {

Config conf = 1;

}

message NormalRequest {

string url = 1;

Config conf = 2;

}

message DataRequest {

string url = 1;

Config conf = 2;

bytes Data = 3;

}
```

**Request Config**

A continuación, se muestran los parámetros que se pueden enviar en la configuración de la llamada a una API externa, valores de variables solo de ejemplo:

```
Config conf
{

    // "url" is the server URL that will be used for the request
    url: "/user",

    // "method" is the request method to be used when making the request
    method: "get", // default

    // "baseURL" will be prepended to "url" unless "url" is absolute.
    // It can be convenient to set "baseURL" for an instance of axios to pass relative URLs
    // to methods of that instance.
    baseURL: "https://some-domain.com/api/",

    // "headers" are custom headers to be sent
    headers: {"X-Requested-With": "XMLHttpRequest"},

    // "params" are the URL parameters to be sent with the request
    // Must be a plain object or a URLSearchParams object
    params: {
        ID: 12345
    },

    // "data" is the data to be sent as the request body
    // Only applicable for request methods "PUT", "POST", "DELETE , and "PATCH"
    data: {
        firstName: "Joffrey"
    },

    // syntax alternative to send data into the body
    // method post
    // only the value is sent, not the key
    data: "Country=Brasil&City=Belo Horizonte",

    // "timeout" specifies the number of milliseconds before the request times out.
    // If the request takes longer than "timeout", the request will be aborted.
    timeout: 1000, // default is "0" (no timeout)

    // "withCredentials" indicates whether or not cross-site Access-Control requests
    // should be made using credentials
    withCredentials: false, // default

    // "auth" indicates that HTTP Basic auth should be used, and supplies credentials.
    // This will set an "Authorization" header, overwriting any existing
    // "Authorization" custom headers you have set using "headers".
    // Please note that only HTTP Basic auth is configurable through this parameter.
    // For Bearer tokens and such, use "Authorization" custom headers instead.
    auth: {
        username: "johnwick",
        password: "s3cr3t0001"
    },

    // "responseType" indicates the type of data that the server will respond with
    // options are: "arraybuffer", "document", "json", "text", "stream"
    responseType: "json", // default

    // "responseEncoding" indicates encoding to use for decoding responses (Node.js only)
    // Note: Ignored for "responseType" of "stream" or client-side requests
    responseEncoding: "utf8", // default

    // "xsrfCookieName" is the name of the cookie to use as a value for xsrf token
    xsrfCookieName: "XSRF-TOKEN", // default

    // "xsrfHeaderName" is the name of the http header that carries the xsrf token value
    xsrfHeaderName: "X-XSRF-TOKEN", // default

    // "maxContentLength" defines the max size of the http response content in bytes allowed in node.js
    maxContentLength: 2000,

    // "maxBodyLength" (Node only option) defines the max size of the http request content in bytes allowed
    maxBodyLength: 2000,

    // "maxRedirects" defines the maximum number of redirects to follow in node.js.
    // If set to 0, no redirects will be followed.
    maxRedirects: 5, // default

    // "socketPath" defines a UNIX Socket to be used in node.js.
    // e.g. "/var/run/docker.sock" to send requests to the docker daemon.
    // Only either "socketPath" or "proxy" can be specified.
    // If both are specified, "socketPath" is used.
    socketPath: null, // default

    // "proxy" defines the hostname and port of the proxy server.
    // Use "false" to disable proxies, ignoring environment variables.
    // "auth" indicates that HTTP Basic auth should be used to connect to the proxy, and
    // supplies credentials.
    // This will set an "Proxy-Authorization" header, overwriting any existing
    // "Proxy-Authorization" custom headers you have set using "headers".
    proxy: {
        host: "127.0.0.1",
        port: 8000,
        auth: {
        username: "hermes",
        password: "p4r4c3lsus"
        }
    },

    // "decompress" indicates whether or not the response body should be decompressed 
    // automatically. If set to "true" will also remove the "content-encoding" header 
    // from the responses objects of all decompressed responses
    // - Node only (XHR cannot turn off decompression)
    decompress: false // default

    }

```

**Respuestas:**

- **CallResponse** : Respuesta de una llamada a una API externa.

```
message CallResponse {

	enum Status {
		ERROR = 0;
		SUCCESS = 1;
	}

	// "status" is the HTTP status code from the server response
	Status status = 1;

	// "data" is the response that was provided by the server
	bytes data

	// "statusText" is the HTTP status message from the server response
	string statusText 

	// "headers" the HTTP headers that the server responded with
	// All header names are lower cased and can be accessed using the bracket notation.
	// Example: "response.headers["content-type"]"
	bytes headers 

	// "config" is the config that was provided to "GatewayService" for the request
	bytes config

	// "request" is the request that generated this response
	// It is the last Request instance
	// and an XMLHttpRequest instance in the browser
	bytes request

}

```

**Métodos**

**Call**

```
rpc Call ( DefaultRequest ) returns( CallResponse );
```

El método Call permite realizar llamadas a una API externa.

**Get**

```
rpc Get ( NormalRequest ) returns( CallResponse );
```

El método Get permite realizar solicitudes a una API externa utilizando el método GET.

**Delete**

```
rpc Delete ( NormalRequest ) returns( CallResponse );
```

El método Delete permite realizar solicitudes a una API externa utilizando el método DEL.

**Head**

```
rpc Head ( NormalRequest ) returns( CallResponse );
```

El método Head permite realizar solicitudes a una API externa utilizando un head especificado por el usuario.

**Options**

```
rpc Options ( NormalRequest ) returns( CallResponse );
```

El método Options permite realizar solicitudes a una API externa utilizando opciones específicas.

**Post**

```
rpc Post ( DataRequest ) returns( CallResponse );
```

El método Post permite realizar solicitudes a una API externa utilizando el método POST.

**Put**

```
rpc Put ( DataRequest ) returns( CallResponse );
```

El método Put permite realizar solicitudes a una API externa utilizando el método PUT.

**Patch**

```
rpc Patch ( DataRequest ) returns( CallResponse );
```

El método Patch permite realizar solicitudes a una API externa utilizando el método PATCH.

**Ejemplo de Uso**

Ejemplo de una solicitud GET

```
const externalAPI = grpc.loadPackageDefinition(packageDefinition).baas.externalApi.gatewayService;
const baseURL = 'localhost' + ':' + '9000';

var NormalRequest = {
	"conf": {
		"Data": {
			"baseURL": "https://some-domain.com/api/",
			"headers": "{'X-Requested-With': 'XMLHttpRequest'}",
			"data": "Country=Brasil&City=Belo Horizonte",
			"withCredentials": false, 
			"responseType": "json", 
			"responseEncoding": "utf8", 
			"xsrfCookieName": "XSRF-TOKEN", 
			"xsrfHeaderName": "X-XSRF-TOKEN", 
			"maxContentLength": 2000,
			"maxBodyLength": 2000,
			"decompress": true 
		}
	}
	"url":"/user"
}

var stub = new externalAPI.GatewayService(baseURL, grpc.credentials.createInsecure());

stub.Get(NormalRequest, (err, CallResponse) => {
	if (err) {
		console.log(err)
	}
	console.log(CallResponse);
});

```
