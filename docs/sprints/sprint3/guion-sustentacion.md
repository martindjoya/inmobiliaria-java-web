# Guion de sustentacion - Dream House S.A.

## 1. Objetivo de la sustentacion

Demostrar que el equipo comprende y puede explicar individualmente:

- El funcionamiento de la aplicacion web.
- El control de acceso por roles.
- El modelo relacional y sus restricciones.
- Las consultas SQL principales.
- Las decisiones tecnicas y las validaciones implementadas.

## 2. Preparacion antes de iniciar

Verificar:

- Tomcat activo.
- MariaDB activo en `localhost:3307`.
- Base `dream_house` disponible.
- Aplicacion desplegada en:

```text
http://localhost:8080/inmobiliaria-java-web/
```

- Datos demo cargados.
- Usuario Administrador disponible:

```text
Correo: admin.demo@dreamhouse.local
Contrasena: Prueba123!
```

- Usuario Inmobiliaria disponible:

```text
Correo: agente.demo@dreamhouse.local
Contrasena: Prueba123!
```

- Usuario Cliente disponible:

```text
Correo: cliente.demo@dreamhouse.local
Contrasena: Prueba123!
```

## 3. Presentacion inicial - 1 minuto

### Texto sugerido

> Dream House S.A. es una aplicacion web para la gestion de una inmobiliaria. Fue desarrollada con Java, JSP, JDBC, MariaDB y Tomcat. El sistema diferencia los roles Visitante, Cliente, Inmobiliaria y Administrador. Permite consultar propiedades, gestionar citas y solicitudes, cargar documentos, consultar reportes y registrar auditoria.

> El proyecto se desarrollo mediante tres sprints. En el Sprint 3 se priorizo el cierre funcional, la seguridad, las validaciones de negocio, la carga real de documentos, los reportes y la documentacion tecnica.

## 4. Recorrido funcional - 4 minutos

### 4.1 Visitante

Abrir la landing page y explicar:

- El catalogo publico.
- El buscador por ciudad, tipo, operacion, precio y caracteristicas.
- El detalle de una propiedad.
- Las acciones que requieren iniciar sesion.

### 4.2 Cliente

Iniciar sesion con `cliente.demo@dreamhouse.local` y mostrar:

1. Panel de Cliente.
2. Favoritos.
3. Detalle de una propiedad.
4. Agendamiento de una cita futura.
5. Rechazo de una fecha pasada.
6. Creacion de una solicitud.
7. Rechazo de una solicitud duplicada activa.
8. Carga de un documento PDF.
9. Rechazo de una extension no permitida.
10. Consulta del estado de sus tramites.

### 4.3 Inmobiliaria

Cerrar sesion e iniciar con `agente.demo@dreamhouse.local`. Mostrar:

1. Listado de propiedades propias.
2. Alta o edicion de propiedad.
3. Validacion de precio negativo.
4. Validacion de matricula inmobiliaria duplicada.
5. Gestion de citas de sus propiedades.
6. Cambio valido de estado de una cita.
7. Intento de regresar una cita a un estado anterior.
8. Gestion de solicitudes.
9. Cambio valido de estado de una solicitud.
10. Consulta de documentos de una solicitud.
11. Mensaje de confirmacion despues de guardar cambios.

### 4.4 Administrador

Cerrar sesion e iniciar con `admin.demo@dreamhouse.local`. Mostrar:

1. Gestion de usuarios.
2. Activar o desactivar una cuenta.
3. Catalogos de ciudades, tipos y caracteristicas.
4. Consulta de auditoria.
5. Reportes administrativos.
6. Intento de acceder a una ruta de otro rol, mostrando acceso denegado.

## 5. Explicacion de seguridad - 2 minutos

### Puntos que se deben explicar

- Las contrasenas no se almacenan en texto plano; se validan con BCrypt mediante `HashContrasenas`.
- La sesion conserva `idUsuario`, `nombreUsuario` y `rolUsuario`.
- `ControlAccesoFilter` protege `/admin/*`, `/inmobiliaria/*` y `/cliente/*`.
- `seguridad.jspf` mantiene una validacion adicional dentro de las paginas.
- Las consultas usan `PreparedStatement` para evitar inyeccion SQL.
- Las operaciones de Cliente e Inmobiliaria verifican la pertenencia del registro antes de modificarlo.
- Los documentos se almacenan bajo `WEB-INF/uploads` y no quedan expuestos como recursos publicos.

### Pregunta probable

**¿Por que no basta con ocultar botones?**

Respuesta:

> Ocultar botones solo controla la interfaz. El filtro servlet y las validaciones de propietario controlan el acceso en el servidor, incluso si alguien escribe directamente una URL o manipula un parametro.

## 6. Explicacion del modelo de datos - 2 minutos

Abrir `docs/modelo-datos.md` y explicar:

### Relacion 1:1

`usuario` y `perfil`. La restriccion `UNIQUE` en `perfil.id_usuario` impide que un usuario tenga dos perfiles.

### Relacion 1:N

Una inmobiliaria tiene muchas propiedades; una propiedad puede tener muchas imagenes; un usuario puede tener muchas citas y solicitudes. La llave foranea esta en la tabla del lado muchos.

### Relacion N:M

- `usuario` y `rol` se resuelven con `usuario_rol`.
- `propiedad` y `caracteristica` se resuelven con `propiedad_caracteristica`.

Las tablas puente usan llaves primarias compuestas.

### Restricciones UNIQUE

Mencionar al menos estas tres:

- `usuario.email`.
- `perfil.id_usuario`.
- `propiedad.matricula_inmobiliaria`.

Tambien existen restricciones en catalogos, favoritos y tablas puente.

## 7. Explicacion de consultas SQL - 1 minuto

Abrir `database/querys/consultas-obligatorias-parcial.sql` y explicar:

1. `INNER JOIN` de propiedades con ciudad, tipo e inmobiliaria.
2. `INNER JOIN` de solicitudes con cliente, propiedad e inmobiliaria.
3. Relacion N:M entre propiedades y caracteristicas.
4. `LEFT JOIN` para encontrar propiedades sin citas.
5. `GROUP BY` y `HAVING` para agrupar propiedades disponibles por ciudad.

### Pregunta probable

**¿Para que sirve `HAVING`?**

Respuesta:

> `WHERE` filtra filas antes de agrupar. `HAVING` filtra los grupos después de aplicar la agregación, por ejemplo ciudades con al menos dos propiedades disponibles.

## 8. Explicacion de Scrum - 1 minuto

Mencionar:

- Sprint 1: autenticacion y acceso por roles.
- Sprint 2: catalogo, filtros y flujo inicial de Cliente.
- Sprint 3: validaciones, documentos, auditoria, reportes, modelo y cierre.
- Cada sprint tiene planning, review y retrospective.
- El trabajo del Sprint 3 se dividio por caracteristicas y commits separados.
- La matriz de pruebas registra 18 escenarios funcionales.

## 9. Preguntas tecnicas probables

### ¿Por que usar JSPF?

> Los JSPF permiten reutilizar conexion, seguridad, cabecera, pie y funciones comunes sin duplicar codigo en todas las paginas.

### ¿Por que usar JDBC?

> JDBC conecta la aplicacion Java con MariaDB y permite ejecutar consultas parametrizadas mediante `PreparedStatement`.

### ¿Como se controla una transicion invalida?

> El servidor consulta el estado actual y solo ejecuta transiciones permitidas. Aunque se manipule el formulario, una regresion de estado no se actualiza y no genera auditoria.

### ¿Como funciona la matricula inmobiliaria?

> Es obligatoria, se almacena en `propiedad.matricula_inmobiliaria` y tiene un indice `UNIQUE`. La aplicacion captura el error y muestra un mensaje claro.

### ¿Donde se guardan los documentos?

> Se guardan fuera del acceso publico, dentro de `WEB-INF/uploads/documentos`, y la base conserva el nombre y la ruta interna.

### ¿Que pasa si se elimina un usuario?

> Las relaciones configuradas con `ON DELETE CASCADE` eliminan los datos dependientes cuando corresponde. En auditoria se usa `ON DELETE SET NULL` para conservar el registro historico.

## 10. Cierre - 30 segundos

### Texto sugerido

> El resultado es una aplicacion funcional para el entorno local, con control de acceso por servidor, validaciones de negocio, modelo relacional normalizado, consultas SQL obligatorias, carga real de documentos, auditoria y reportes. Las evidencias externas que deben adjuntarse son las capturas, el tablero Scrum y la sustentacion individual del modelo y las consultas.

## 11. Archivos clave para mostrar

- `index.jsp`
- `WEB-INF/web.xml`
- `src/seguridad/ControlAccesoFilter.java`
- `src/seguridad/HashContrasenas.java`
- `src/documentos/SubirDocumentoServlet.java`
- `database/dream_house.sql`
- `database/querys/consultas-obligatorias-parcial.sql`
- `docs/modelo-datos.md`
- `docs/sprints/sprint3/matriz-pruebas.md`

## 12. Regla de oro

No afirmar que una funcionalidad existe solo porque aparece en una pantalla. Explicar siempre:

1. Qué hace la interfaz.
2. Qué valida el servidor.
3. Qué tabla o consulta respalda la operación.
4. Qué prueba demuestra que funciona.
