# Resultados de pruebas

Fecha de validación: 3 de septiembre de 2026.

## Validación automatizada

- `flutter analyze`: sin problemas.
- `flutter test`: 5 pruebas aprobadas; modelos de login, catálogo y solicitud de cotización validados, envío del POST con JWT comprobado y recuperación después de una falla de conexión.
- Compilación Windows, Web y APK Android debug completada.
- `flutter run -d windows --dart-define=API_BASE_URL=http://localhost:5142`: la aplicación inició y se conectó al servicio de depuración correctamente.

## Integración con la API real

La API se ejecutó en `http://localhost:5142` y se probaron respuestas reales, sin mocks ni acceso directo a SQL Server.

| Caso | Resultado |
|---|---|
| Catálogo público | `200 OK`; actualmente vacío, por lo que la app muestra estado EMPTY |
| Registro correcto | `201 Created`; devuelve rol Cliente, JWT e `idCliente` |
| Registro duplicado | `409 Conflict`; mensaje tratado por la interfaz |
| Login correcto | `200 OK`; sesión autenticada en memoria |
| Login incorrecto | `401 Unauthorized`; mensaje tratado por la interfaz |
| Crear solicitud de vehículo | `201 Created` |
| Consultar mis solicitudes | `200 OK`; la solicitud creada fue devuelta para el JWT del cliente |
| Consultar cotizaciones | `200 OK`; colección vacía para el cliente de prueba |
| Crear solicitud de cotización | `201 Created`; estado inicial `Pendiente` |
| Repetir solicitud activa | `409 Conflict` |
| Solicitud de cotización sin origen | `400 Bad Request` |
| Consultar solicitudes de cotización propias | `200 OK`; la petición creada fue devuelta |
| Cliente intenta generar cotización final | `403 Forbidden` |
| Consultar seguimiento | `200 OK`; colección vacía para el cliente de prueba |
| Consultar perfil propio | `200 OK` |
| Crear solicitud de cotización | `201 Created`; estado inicial `Pendiente` |
| Repetir una solicitud de cotización activa | `409 Conflict` |
| Solicitud de cotización sin solicitud ni vehículo | `400 Bad Request` |
| Consultar solicitudes de cotización propias y detalle | `200 OK` |
| Cliente intenta generar la cotización final | `403 Forbidden` |

Para estas pruebas se creó el cliente `flutter.0903194542@wellsimportcars.local`, una solicitud de vehículo y una solicitud de cotización asociada. Permanecen en la base de desarrollo porque la API no expone endpoints de eliminación para Cliente.

## Casos condicionados por datos o contrato del backend

- Selección y detalle: navegación implementada y conectada a `GET /api/catalogo/{id}`; no pudo recorrerse con un registro real porque el catálogo estaba vacío.
- Detalle de cotización e historial: pantallas y endpoints GET implementados; la cuenta de prueba no tiene cotizaciones ni importaciones.
- Solicitar cotización: implementado de extremo a extremo contra `POST /api/cotizaciones/solicitudes`.
- Solicitar adquisición: pantalla preparada, pero no se transmite porque `POST /api/ventas` es una operación de Empleado/Administrador.
- Flutter Web: compila correctamente, pero la API debe habilitar CORS antes de que el navegador permita las llamadas entre orígenes.
- Logout: implementado; elimina el JWT y los datos de sesión mantenidos en memoria.

Las brechas exactas y los endpoints sugeridos están documentados en `API_GAPS.md`.
