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

