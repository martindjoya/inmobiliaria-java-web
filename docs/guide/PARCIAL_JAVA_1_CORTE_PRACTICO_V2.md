# Parcial Java 1 - Corte practico

**Institucion:** Unidades Tecnologicas de Santander  
**Asignatura:** Programacion Java  
**Fecha del documento fuente:** 2026-08-26  
**Proyecto:** Aplicacion web para la administracion de una inmobiliaria

> Esta copia Markdown fue generada a partir de `PARCIAL_JAVA_1_CORTE_PRACTICO_V2.pdf` para facilitar la consulta y vincular los requisitos con el Sprint Planning 3.

## 1. Competencias evaluadas

### Desarrollo de aplicaciones web dinamicas con Java y JSP - 40%

Diseñar e implementar una aplicacion web completa para la administracion de una inmobiliaria, con pagina de aterrizaje, autenticacion mediante contrasenas cifradas, control de acceso por roles diferenciados (administrador, inmobiliaria, cliente y visitante), gestion de propiedades, citas y solicitudes, funcionalidad integral y manejo seguro de sesiones.

### Metodologia de desarrollo - 30%

Planificar y ejecutar un proyecto en tres sprints de siete dias, documentando `planning`, `review` y `retrospective`, gestionando un product backlog con historias priorizadas y utilizando Git y un tablero de seguimiento, simulando los roles Scrum.

### Bases de datos y documentacion - 30%

Diseñar un modelo normalizado con relaciones 1:1, 1:N y N:M, llaves primarias y foraneas y restricciones `UNIQUE`; integrarlo con JDBC y producir MER, modelo relacional, diccionario de datos, consultas, pruebas unitarias y sustentacion individual.

## 2. Objetivo general

Construir una aplicacion web dinamica para una inmobiliaria ficticia usando Java EE, JSP y JDBC sobre una base de datos relacional normalizada. El sistema debe separar los privilegios por rol, evidenciar las relaciones del modelo de datos y desarrollarse mediante Scrum en tres sprints de siete dias.

El despliegue de la aplicacion y de la base de datos en linea otorga puntos adicionales.

## 3. Modulos minimos

- **Landing page:** pagina publica, responsiva, presentacion de la inmobiliaria, buscador rapido, publicaciones destacadas y accesos a registro e inicio de sesion.
- **Autenticacion:** registro, inicio y cierre de sesion, con redireccion al panel correspondiente.
- **Paneles:** vistas diferenciadas y datos limitados segun el rol.
- **Propiedades:** listado con filtros, detalle con galeria y caracteristicas, creacion, edicion y baja logica.
- **Visitas y solicitudes:** citas, radicacion de documentos y aprobacion o rechazo por la inmobiliaria.
- **Reportes:** propiedades disponibles por ciudad, citas por estado y solicitudes por inmobiliaria mediante consultas SQL con varias tablas.

## 4. Roles del sistema

### Visitante

Puede navegar la landing page, consultar el catalogo y el detalle de propiedades. No puede acceder a paneles internos ni a datos de contacto completos.

### Cliente

Puede buscar y filtrar propiedades, guardar favoritos, solicitar citas, radicar documentos, consultar el estado de sus tramites y actualizar su perfil.

### Inmobiliaria o agente

Puede publicar, editar y dar de baja sus propiedades, administrar imagenes y caracteristicas, atender citas, revisar y aprobar o rechazar documentos y generar reportes de ventas y arriendos.

### Administrador

Tiene acceso total: gestiona usuarios y roles, activa o inactiva cuentas, parametriza tipos de propiedad, ciudades y caracteristicas y consulta la auditoria.

Los permisos deben controlarse tanto en la interfaz como en el servidor.

## 5. Autenticacion, sesiones y seguridad

- Las contrasenas deben almacenarse con hash seguro, como BCrypt, PBKDF2 o SHA-256 con salt. No se permite texto plano.
- Las credenciales deben validarse contra la base de datos.
- `HttpSession` debe conservar el identificador del usuario y sus roles.
- Un filtro de servlet debe proteger las rutas privadas y redirigir a acceso denegado cuando falte autenticacion o rol.
- Los menus y botones deben construirse segun el rol, pero ocultar una opcion no reemplaza la validacion en el servidor.
- Son valores agregados opcionales el bloqueo temporal, recuperacion de contrasena y auditoria de actividad.

## 6. Modelo de datos obligatorio

La entrega debe incluir:

- Modelo entidad-relacion (MER).
- Modelo relacional normalizado hasta tercera forma normal (3FN).
- Diccionario de datos.
- Script DDL con llaves primarias, foraneas y restricciones.
- Script DML con datos de prueba, minimo diez registros por tabla principal.

### Relaciones requeridas

- **1:1:** `usuario` con `perfil`, garantizada por `perfil.id_usuario UNIQUE`.
- **1:N:** una inmobiliaria publica muchas propiedades; una propiedad tiene muchas imagenes; un cliente genera muchas citas. La llave foranea va en el lado muchos y debe justificar sus acciones referenciales.
- **N:M:** `usuario` y `rol` mediante `usuario_rol`; `propiedad` y `caracteristica` mediante `propiedad_caracteristica`. Las tablas intermedias deben tener llave primaria compuesta.

### Restricciones UNIQUE

El modelo debe demostrar al menos tres restricciones `UNIQUE` y la aplicacion debe capturar sus errores con mensajes claros:

- `usuario.correo` o `usuario.email`.
- `propiedad.matricula_inmobiliaria`.
- `perfil.id_usuario`.
- La llave compuesta `usuario_rol(id_usuario, id_rol)`.
- Se recomienda `UNIQUE(id_propiedad, fecha_hora)` en citas.

## 7. Consultas obligatorias

Se deben implementar y documentar al menos cinco consultas que demuestren el dominio del modelo:

1. Dos consultas con `INNER JOIN` entre tres o mas tablas.
2. Una consulta que resuelva una relacion N:M.
3. Una consulta con `LEFT JOIN`.
4. Una consulta de agregacion con `GROUP BY` y `HAVING` que alimente un reporte.

## 8. Requisitos tecnicos

- Java EE, JSP, JDBC, HTML5, CSS3, JavaScript, Bootstrap y Apache Tomcat.
- Una instancia local y, cuando sea posible, una instancia en linea de la base de datos.
- Cadena de conexion centralizada y configurable, sin repetirla en cada clase.
- Arquitectura separada por capas siguiendo MVC, con controladores por entidad y JSPF reutilizables.
- Diseno responsivo para computador, tableta y celular mediante Bootstrap o media queries.
- Validaciones de campos obligatorios, correo, telefono, precio y fechas.
- Manejo de excepciones SQL con mensajes comprensibles.
- Diagramas MER, modelo relacional y casos de uso, junto con la documentacion Scrum.

## 9. Estructura Scrum

El proyecto se divide en tres sprints de siete dias:

- **Sprint 1 - Cimientos y acceso:** MER, modelo relacional, datos de prueba, JDBC, landing page, registro, login y control de acceso.
- **Sprint 2 - Nucleo del negocio:** CRUD de propiedades, imagenes, caracteristicas, buscador, perfil y paneles por rol.
- **Sprint 3 - Operacion y cierre:** citas, solicitudes, documentos, favoritos, reportes, pruebas unitarias, despliegue y documentacion final.

Para cada sprint se debe documentar:

- Sprint Planning con historias, criterios de aceptacion y estimacion.
- Sprint Review con demostracion funcional y resultado.
- Sprint Retrospective con mejoras identificadas.

Tambien se requiere un tablero de seguimiento y un repositorio Git con commits frecuentes y mensajes descriptivos.

## 10. Product backlog inicial

1. Visitante: landing page y busqueda rapida.
2. Usuario: registro con correo unico y validado.
3. Usuario registrado: inicio y cierre de sesion seguros.
4. Administrador: asignar y revocar roles.
5. Cliente: completar perfil con documento, telefono y direccion.
6. Agente: registrar y editar propiedades con fotos, caracteristicas y precio.
7. Cliente: filtrar por ciudad, tipo, precio y caracteristicas.
8. Cliente: guardar favoritos.
9. Cliente: solicitar citas sin cruces de agenda.
10. Cliente: radicar documentos y consultar su solicitud.
11. Agente: aprobar o rechazar solicitudes y documentos.
12. Administrador: reporte de propiedades por ciudad y estado.
13. Administrador: consultar auditoria.
14. Historias adicionales propuestas por el equipo.

Cada historia debe tener criterios de aceptacion y cumplir la Definition of Done.

## 11. Entregables

- Repositorio Git publico con el codigo y la evidencia de los tres sprints.
- Scripts `.sql`.
- Modelos MER y relacional exportados como imagen o PDF.
- Evidencia del tablero de seguimiento.
- Aplicacion funcionando en ambiente local.
- Despliegue en linea de aplicacion y base de datos como opcion para puntos adicionales.
- Sustentacion grupal o individual.

## 12. Criterios de evaluacion

| Criterio | Evidencia | Puntaje |
|---|---|---:|
| Aplicacion funcional y control por rol | Login cifrado, filtro de rutas, paneles, CRUD, citas y solicitudes | 40 |
| Metodologia | Tres sprints, tablero y repositorio Git con historial | 30 |
| Modelo y documentacion | MER, modelo 3FN, relaciones, UNIQUE, DDL/DML, consultas y sustentacion | 30 |
| **Total** |  | **100** |

> Un proyecto funcional no obtiene el puntaje completo si el autor no puede explicar su modelo de datos y su control de acceso. La sustentacion es obligatoria.
