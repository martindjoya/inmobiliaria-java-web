# Matriz de pruebas del Sprint 3

## Entorno

- Aplicacion: Dream House S.A.
- Servidor: Apache Tomcat 8.5.96.
- Java de Tomcat: JDK 8.
- Base de datos: MariaDB en `localhost:3307`.
- Base: `dream_house`.
- Datos demo: `database/querys/datos-prueba-sprint2.sql`.
- Administrador demo: `admin.demo@dreamhouse.local`.

## Resultados registrados

| ID | Rol | Escenario | Resultado esperado | Resultado registrado | Estado |
|---|---|---|---|---|---|
| T01 | Visitante | Abrir landing y catalogo | HTTP 200, filtros y detalle visibles | Funcionando | Aprobada |
| T02 | Visitante | Abrir panel privado | Redireccion a acceso denegado | Funcionando | Aprobada |
| T03 | Cliente | Login con credenciales validas | Sesion y panel de Cliente | Funcionando | Aprobada |
| T04 | Cliente | Login con credenciales invalidas | Mensaje controlado | Funcionando | Aprobada |
| T05 | Inmobiliaria | Crear propiedad con precio negativo | No guarda y muestra error | Funcionando | Aprobada |
| T06 | Inmobiliaria | Repetir matricula inmobiliaria | Rechaza duplicado con mensaje claro | Funcionando | Aprobada |
| T07 | Inmobiliaria | Agendar cita con fecha pasada | Rechaza la fecha | Funcionando | Aprobada |
| T08 | Cliente | Cargar `id_propiedad` inexistente en citas | Error y formulario oculto | Funcionando | Aprobada |
| T09 | Cliente | Crear solicitud duplicada activa | Rechaza el duplicado | Funcionando | Aprobada |
| T10 | Cliente | Subir PDF valido | Guarda archivo y registro en BD | Funcionando | Aprobada |
| T11 | Cliente | Subir extension no permitida | Rechaza archivo | Funcionando | Aprobada |
| T12 | Inmobiliaria | Cambiar estado de cita | Mensaje de confirmacion y auditoria | Funcionando | Aprobada |
| T13 | Inmobiliaria | Regresar cita a estado anterior | Rechaza transicion | Funcionando | Aprobada |
| T14 | Inmobiliaria | Aprobar o rechazar solicitud | Transicion valida y mensaje | Funcionando | Aprobada |
| T15 | Inmobiliaria | Regresar solicitud finalizada | Rechaza transicion | Funcionando | Aprobada |
| T16 | Administrador | Consultar auditoria | Muestra cambios realizados | Funcionando | Aprobada |
| T17 | Administrador | Consultar reportes | Cuatro reportes con datos reales | Funcionando | Aprobada |
| T18 | Administrador | Acceder como otro rol | Acceso denegado | Funcionando | Aprobada |

## Pruebas tecnicas

- Compilacion de clases Java con `javac --release 8`.
- Compilacion del filtro servlet y del servlet multipart.
- Validacion de `WEB-INF/web.xml`.
- Ejecucion de las cinco consultas obligatorias en MariaDB `3307`.
- Verificacion de `matricula_inmobiliaria` y `uq_propiedad_matricula` en la base activa.
- Validacion de archivos modificados sin errores del analizador.

## Evidencia pendiente de adjuntar

- Capturas de pantalla de los flujos principales.
- Enlace o captura del tablero Scrum.
- Historial de commits del repositorio.
- Evidencia de sustentacion individual del modelo y consultas.
