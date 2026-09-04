# Brechas de la API para el módulo Cliente

Auditoría realizada contra Swagger `v1` y los Controllers/DTO de la API ASP.NET Core.

## Matriz funcional

| Funcionalidad | Endpoint real | Estado | Decisión en Flutter |
|---|---|---|---|
| Consultar catálogo | `GET /api/catalogo` y `GET /api/catalogo/{id}` | Disponible, público | Implementado |
| Registro e inicio de sesión | `POST /api/auth/registro`, `POST /api/auth/login` | Disponible, público | Implementado; el JWT y `idCliente` se conservan en memoria |
| Solicitar vehículo | `POST /api/solicitudes` | Disponible para Cliente | Implementado |
| Consultar solicitudes | `GET /api/solicitudes` y `GET /api/solicitudes/{id}` | Disponible; la API filtra por el `cliente_id` del JWT | Implementado |
| Solicitar cotización | `POST /api/cotizaciones/solicitudes` | Disponible para Cliente | Implementado; admite una solicitud propia o un vehículo publicado |
| Consultar solicitudes de cotización | `GET /api/cotizaciones/solicitudes` y `GET /api/cotizaciones/solicitudes/{id}` | Disponible; la API filtra por JWT | Implementado |
| Consultar cotizaciones | `GET /api/cotizaciones` y `GET /api/cotizaciones/{id}` | Disponible; la API filtra por JWT | Implementado |
| Solicitar adquisición | No existe endpoint de reserva/solicitud para Cliente | Falta | Pantalla preparada, sin enviar datos |
| Consultar seguimiento | `GET /api/importaciones` y `GET /api/importaciones/{id}` | Disponible; la API filtra por JWT | Implementado en modo solo lectura |
| Consultar perfil | `GET /api/clientes/{id}` | Disponible para el propio Cliente | Implementado |

## CORS para Flutter Web

La API actual no registra `AddCors` ni ejecuta `UseCors`. Las compilaciones Android y Windows pueden consumir la API directamente, pero un navegador bloqueará las solicitudes de Flutter Web cuando la aplicación y la API tengan orígenes distintos.

El backend debe agregar una política CORS con los orígenes exactos usados en desarrollo y producción. No se desactiva la seguridad del navegador desde Flutter y no se agregó un proxy ficticio al cliente.

## Solicitud de cotización resuelta

Se agregó `POST /api/cotizaciones/solicitudes` para registrar la intención del Cliente sin permitirle definir precios. El `idCliente` se obtiene del JWT y la API valida propiedad de la solicitud, publicación/disponibilidad del vehículo y duplicados activos.

También se agregaron:

```text
GET /api/cotizaciones/solicitudes
GET /api/cotizaciones/solicitudes/{id}
PUT /api/cotizaciones/solicitudes/{id}/estado
```

La actualización de estado corresponde únicamente a Empleado/Administrador. `POST /api/cotizaciones` conserva la creación de la cotización final con precios y detalles y ahora está restringido explícitamente a esos roles.

## Solicitud de adquisición

`POST /api/ventas` pertenece exclusivamente a los roles `Empleado,Administrador` y registra una asignación/venta final. No debe invocarse desde Flutter.

Endpoint requerido sugerido para backend:

```text
POST /api/adquisiciones/solicitudes
```

Debe tomar el cliente desde el JWT, validar que el vehículo esté disponible y registrar únicamente la intención/reserva, no una venta completada.
