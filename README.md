# Wells Import Cars App

Aplicación Flutter del módulo **Visitante y Cliente** de Wells Import Cars.

```text
Flutter App
    ↓ HTTP / JSON / Bearer JWT
API REST ASP.NET Core
    ↓
SQL Server
```

Flutter nunca se conecta directamente a SQL Server, no crea una base local y no simula respuestas. La API .NET es la única fuente de datos y reglas de negocio.

## Funciones

Visitante:

- consultar catálogo y detalle de vehículos;
- registrarse;
- iniciar sesión.

Cliente:

- catálogo y detalle;
- crear y consultar solicitudes de vehículos;
- consultar cotizaciones y sus detalles;
- consultar seguimiento e historial de estados;
- consultar perfil y cerrar sesión;
- solicitar cotizaciones desde una solicitud propia o un vehículo del catálogo y consultar el estado de esas peticiones;
- visualizar el flujo preparado de adquisición. Esta escritura no se envía porque aún falta un endpoint adecuado; ver [API_GAPS.md](API_GAPS.md).

## Estructura

```text
lib/
├── config/      URL y timeout
├── models/      modelos tipados y fromJson/toJson
├── services/    HTTP, JWT y responsabilidades por módulo
├── screens/     navegación y estados de cada caso de uso
└── widgets/     loading, error, empty, tarjetas y timeline
```

La app usa Material 3, `StatefulWidget`, `setState`, `Future`, `async/await`, `Navigator`, `ListView`, `GridView.builder`, `LayoutBuilder` y `MediaQuery` implícito en los componentes Material. No usa Bloc, Riverpod, GetX, Redux ni base de datos local.

## Estados y errores

`ViewState` diferencia `initial`, `loading`, `success`, `error` y `empty`. Todas las peticiones tienen timeout de 10 segundos. Se manejan conexión rechazada, timeout, errores HTTP 400/401/403/404/409/500 y JSON inválido. Las pantallas de consulta ofrecen Reintentar.

## Endpoints utilizados

- `GET /api/catalogo`, `GET /api/catalogo/{id}`
- `POST /api/auth/registro`, `POST /api/auth/login`
- `GET /api/clientes/{id}`
- `GET /api/solicitudes`, `POST /api/solicitudes`
- `GET /api/cotizaciones`, `GET /api/cotizaciones/{id}`
- `GET /api/cotizaciones/solicitudes`, `GET /api/cotizaciones/solicitudes/{id}`
- `POST /api/cotizaciones/solicitudes`
- `GET /api/importaciones`, `GET /api/importaciones/{id}`

El token devuelto por login/registro se mantiene solamente en memoria y se envía como `Authorization: Bearer <JWT>` en operaciones privadas. `idCliente` se obtiene de `LoginResponse`; nunca está hardcodeado.

## Ejecutar

Primero levante SQL Server y la API .NET en el puerto esperado.

### 1. Levantar la API y dejar esa terminal abierta

```powershell
cd "C:\Users\serra\source\repos\ApiWellsImportCars\ApiWellsImportCars"
dotnet run --project ApiWellsImportCars.csproj --launch-profile http
```

Espere el mensaje `Now listening on: http://localhost:5142` y compruebe `http://localhost:5142/swagger`. Cerrar esa terminal apaga la API.

### 2. Entrar a la carpeta Flutter

```powershell
cd "C:\Users\serra\Documents\Codex\2026-08-31\files-pasted-by-the-user-necesito\WellsImportCarsApp"
```

### URL seleccionada automáticamente

La app ahora elige una dirección válida según el destino:

- Windows, Chrome y Edge: `http://localhost:5142`
- Emulador Android: `http://10.0.2.2:5142`
- Teléfono físico: requiere `--dart-define` con la IP Wi-Fi del PC

En esta computadora el SDK está instalado en:

```text
C:\Users\serra\flutter\3.38.7\bin\flutter.bat
```

Si `flutter` no es reconocido, use temporalmente la ruta completa mostrada en los comandos siguientes o agregue `C:\Users\serra\flutter\3.38.7\bin` al `PATH` de Windows.

### Android Emulator

El valor predeterminado es:

```text
http://10.0.2.2:5142
```

```powershell
& "C:\Users\serra\flutter\3.38.7\bin\flutter.bat" pub get
& "C:\Users\serra\flutter\3.38.7\bin\flutter.bat" run
```

Android tiene permiso de Internet. El tráfico HTTP local está habilitado solamente en el manifest `debug`; para producción debe utilizar HTTPS.

### Windows

```powershell
& "C:\Users\serra\flutter\3.38.7\bin\flutter.bat" run -d windows
```

### Chrome

La API debe permitir el origen del servidor de desarrollo Flutter mediante CORS:

```powershell
& "C:\Users\serra\flutter\3.38.7\bin\flutter.bat" run -d chrome
```

### Teléfono físico

En una terminal exclusiva para la API, ejecútela escuchando en la red local:

```powershell
cd "C:\Users\serra\source\repos\ApiWellsImportCars\ApiWellsImportCars"
$env:ASPNETCORE_URLS="http://0.0.0.0:5142"
dotnet run --project ApiWellsImportCars.csproj --no-launch-profile
```

Después sustituya `192.168.X.X` por la IP Wi-Fi del PC (actualmente `192.168.1.9`, pero puede cambiar):

```powershell
& "C:\Users\serra\flutter\3.38.7\bin\flutter.bat" run -d ID_DEL_TELEFONO --dart-define=API_BASE_URL=http://192.168.X.X:5142
```

El teléfono y el PC deben estar en la misma red y el firewall debe permitir el puerto. Nunca use `localhost` en el teléfono: apuntaría al propio teléfono.

## Cuenta para iniciar sesión

Flutter es el portal de clientes. Acepta únicamente una respuesta de login con `rol = Cliente` e `idCliente` válido. Una cuenta Administrador puede autenticarse correctamente en la API, pero Flutter la rechazará con el mensaje de que la aplicación es exclusiva para clientes. Cree la cuenta desde **Registrarse** en la app o use una cuenta Cliente existente.

## Verificación

```powershell
flutter pub get
dart format lib test
flutter analyze
flutter test
```
