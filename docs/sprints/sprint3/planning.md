# Sprint Planning 3

## 1. Contexto

El Sprint 2 dejo disponible una base funcional del flujo inmobiliario: catalogo publico con filtros, detalle de propiedades, favoritos, agendamiento de citas, solicitudes y paneles diferenciados por rol. Tambien se estabilizaron la conexion JDBC, la compilacion compatible con Tomcat y los datos demo.

El Sprint 3 sera el sprint de cierre funcional y validacion final. Su objetivo es convertir los flujos parciales en una entrega demostrable, corregir los riesgos que pueden producir datos invalidos o accesos indebidos y completar la documentacion exigida por el proyecto.

**Fecha de inicio:** 2026-09-17  
**Jornada de trabajo planificada:** 10:00 a 12:00 (120 minutos)  
**Producto:** Dream House S.A.

## 2. Objetivo del sprint

Entregar una version estable de Dream House S.A. en la que los roles Cliente, Inmobiliaria y Administrador puedan completar sus operaciones principales con validaciones de negocio, control de acceso consistente, trazabilidad basica y un conjunto de pruebas reproducibles.

## 3. Alcance priorizado

### Incluye

- Cierre y validacion del CRUD de propiedades, incluyendo estados y propiedad de los registros.
- Validacion de citas para impedir fechas pasadas y cruces de agenda cuando corresponda.
- Gestion completa del ciclo de solicitudes: creacion, consulta, cambio de estado y visualizacion de documentos.
- Sustitucion del registro simulado de documentos por una carga controlada o, si el entorno no lo permite, una alternativa documentada y validada.
- Proteccion consistente de las rutas privadas y comprobacion de permisos por rol y por propietario.
- Registro de acciones relevantes en auditoria.
- Reportes administrativos con consultas agregadas usando `GROUP BY` y `HAVING` cuando aplique.
- Pruebas de regresion con los datos demo y documentacion final del sistema.

### No incluye

- Aplicacion movil o API REST.
- Notificaciones por correo o mensajeria externa.
- Integracion con pasarelas de pago.
- Rediseño visual completo no relacionado con los flujos del sprint.
- Funcionalidades nuevas que no sean necesarias para cerrar el alcance del parcial.

## 4. Historias de usuario

### HU-301: Gestionar propiedades

Como usuario de una inmobiliaria, quiero crear, editar y cambiar el estado de mis propiedades para mantener actualizado el catalogo.

**Criterios de aceptacion:**

- Solo una inmobiliaria autenticada puede gestionar sus propiedades.
- El formulario valida campos obligatorios, valores numericos y relaciones validas de ciudad y tipo.
- Una inmobiliaria no puede editar propiedades pertenecientes a otra inmobiliaria.
- El cambio de estado se refleja en el catalogo publico.
- Las operaciones invalidas muestran un mensaje controlado y no dejan datos parciales.

### HU-302: Gestionar citas sin conflictos

Como cliente, quiero agendar una visita disponible para recibir una confirmacion coherente.

**Criterios de aceptacion:**

- No se pueden agendar citas con fecha pasada.
- No se puede crear una cita duplicada o que choque con otra cita activa para la misma propiedad.
- La inmobiliaria puede cambiar el estado de las citas de sus propiedades.
- Un cliente solo puede consultar sus propias citas.

### HU-303: Tramitar solicitudes y documentos

Como cliente, quiero enviar una solicitud y asociar mis documentos para que la inmobiliaria pueda revisarla.

**Criterios de aceptacion:**

- El cliente solo puede ver y modificar sus propias solicitudes y documentos.
- La solicitud conserva la propiedad, el usuario, el tipo y el estado.
- La inmobiliaria solo puede cambiar solicitudes de sus propiedades.
- Los documentos aceptan una extension y un tamano dentro de los limites definidos.
- La ruta o referencia almacenada no permite acceder a documentos de otra solicitud.

### HU-304: Administrar usuarios y permisos

Como administrador, quiero gestionar usuarios y consultar las acciones del sistema para mantener el control de la plataforma.

**Criterios de aceptacion:**

- Las rutas administrativas rechazan usuarios sin rol Administrador.
- El administrador puede consultar y actualizar el estado de un usuario sin alterar sus credenciales accidentalmente.
- Las acciones administrativas relevantes generan un registro de auditoria.
- Los mensajes de error no exponen credenciales, consultas SQL ni rutas internas.

### HU-305: Consultar reportes

Como administrador, quiero consultar indicadores agrupados para supervisar la actividad de la inmobiliaria.

**Criterios de aceptacion:**

- Existe al menos un reporte de propiedades por estado o tipo.
- Existe al menos un reporte de solicitudes o citas por estado.
- Los resultados se calculan desde la base de datos y no desde valores fijos en la JSP.
- Los reportes funcionan con base vacia y con los datos demo.

### HU-306: Validar la entrega

Como equipo, queremos ejecutar una matriz de pruebas reproducible para comprobar que el incremento funciona en un entorno limpio.

**Criterios de aceptacion:**

- Se prueban los flujos principales de Visitante, Cliente, Inmobiliaria y Administrador.
- Se prueban accesos permitidos y denegados.
- Se registran resultado, ruta, datos utilizados y evidencia de cada prueba.
- Se documentan las diferencias de puerto, credenciales y versiones del entorno.

## 5. Backlog del sprint

| Prioridad | Actividad | Historia | Resultado esperado |
|---|---|---|---|
| P0 | Revisar permisos y rutas privadas | HU-301, HU-303, HU-304 | Ningun usuario accede a datos de otro rol o propietario |
| P0 | Validar citas y solicitudes | HU-302, HU-303 | Reglas de negocio aplicadas antes de insertar o actualizar |
| P0 | Cerrar CRUD de propiedades | HU-301 | Alta, edicion y estados comprobables desde la interfaz |
| P1 | Implementar o cerrar carga de documentos | HU-303 | Flujo real o limitacion documentada con validaciones |
| P1 | Completar auditoria de operaciones | HU-304 | Acciones relevantes trazables |
| P1 | Crear reportes administrativos | HU-305 | Consultas agregadas con resultados verificables |
| P1 | Ejecutar pruebas de regresion | HU-306 | Matriz de pruebas con evidencias |
| P2 | Completar MER, modelo relacional y diccionario | HU-306 | Documentacion tecnica alineada con la base real |
| P2 | Revisar consistencia visual y mensajes | HU-306 | Flujos principales claros y sin errores visibles |

## 6. Plan de trabajo de la jornada

La jornada se limita a 120 minutos. Se priorizan los tres elementos P0 del backlog y una validacion rapida del incremento. Los elementos P1 y P2 se mantienen como trabajo posterior del Sprint 3.

| Hora | Actividad | Resultado esperado |
|---|---|---|
| 10:00-10:10 | Preparacion del entorno y datos demo | Tomcat, base de datos y credenciales de prueba confirmados |
| 10:10-10:30 | Revisar permisos, sesiones y propietarios | Rutas privadas y consultas principales verificadas por rol |
| 10:30-10:55 | Validar citas y solicitudes | Fechas invalidas, duplicados y cambios de estado controlados |
| 10:55-11:25 | Cerrar el CRUD de propiedades | Alta, edicion y estados comprobables para la inmobiliaria autenticada |
| 11:25-11:40 | Ejecutar casos negativos prioritarios | Accesos indebidos y parametros invalidos rechazados |
| 11:40-11:55 | Ejecutar regresion rapida | Flujos de Visitante, Cliente, Inmobiliaria y Administrador revisados |
| 11:55-12:00 | Registrar resultados y pendientes | Evidencia de pruebas y tareas P1/P2 documentadas |

### Criterio de priorizacion durante la jornada

1. Resolver primero cualquier bloqueo de conexion, compilacion o autenticacion.
2. Completar solo cambios necesarios para las historias HU-301, HU-302 y HU-303.
3. Detener la incorporacion de funcionalidades nuevas a las 11:40 para reservar tiempo a la regresion.
4. Registrar como pendiente cualquier tarea que no pueda validarse antes de las 12:00.

## 7. Definicion de terminado (DoD)

El Sprint 3 se considera terminado cuando:

- Los cuatro perfiles previstos pueden completar sus flujos principales.
- Las operaciones de propiedades, citas y solicitudes tienen validaciones de negocio.
- No se puede consultar ni modificar informacion de otro usuario o inmobiliaria mediante parametros manipulados.
- La carga o registro de documentos tiene limites y control de pertenencia.
- Las acciones administrativas importantes quedan auditadas.
- Los reportes muestran datos calculados desde la base de datos.
- La aplicacion compila y carga en Tomcat sin errores nuevos de JSP o JDBC.
- La matriz de pruebas incluye resultados para casos exitosos y fallidos.
- La documentacion tecnica y funcional refleja el estado entregado.

## 8. Riesgos y mitigaciones

| Riesgo | Impacto | Mitigacion |
|---|---|---|
| Diferencias entre puertos 3306 y 3307 | Alto | Mantener la configuracion documentada y validar conexion antes de probar |
| Carga de archivos limitada por el despliegue actual | Alto | Verificar soporte del contenedor y definir una alternativa trazable |
| Validaciones repartidas entre varias JSP | Alto | Centralizar helpers reutilizables donde sea posible y probar cada entrada |
| Datos demo insuficientes para reportes y estados | Medio | Preparar datos para todos los estados y documentar el script |
| Tiempo limitado para corregir defectos | Alto | Resolver primero P0 y congelar funcionalidades nuevas en la fase de regresion |

## 9. Entregables

- Aplicacion desplegable y verificada en Tomcat.
- Script de datos demo actualizado.
- Matriz de pruebas de regresion.
- MER y modelo relacional.
- Diccionario de datos.
- Casos de uso o historias actualizadas.
- Sprint Review 3.
- Retrospective 3.

## 10. Preguntas de control para la primera reunion

1. ¿El equipo dispone de un entorno donde Tomcat permita carga real de archivos?
2. ¿Que estados y transiciones de citas y solicitudes se aceptaran como regla definitiva?
3. ¿Que reportes son obligatorios para la evaluacion y quien los validara?
4. ¿Que integrante ejecutara la prueba final en un entorno diferente?
5. ¿Que evidencia se conservara para demostrar cada criterio de aceptacion?
