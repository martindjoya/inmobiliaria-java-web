# Sprint 2 - Trabajo realizado hoy

## 1. Contexto

El Sprint 2 inicia la transicion desde el MVP de autenticacion hacia la funcionalidad del negocio inmobiliario. La jornada se concentro en estabilizar el entorno, corregir errores de ejecucion y dejar disponible el catalogo de propiedades para continuar con las pruebas de Cliente.

Fecha de la jornada: 2026-09-16.

## 2. Objetivo de la jornada

- Mantener funcionando la aplicacion en Apache Tomcat.
- Corregir la conexion con MySQL/MariaDB del entorno local.
- Permitir que las clases Java se compilen para el bytecode esperado por Tomcat.
- Corregir errores que impedian cargar paginas JSP.
- Recuperar la pagina publica de propiedades.
- Documentar las diferencias de configuracion entre entornos del equipo.

## 3. Actividades realizadas

### 3.1 Conexion a la base de datos

Se verifico que el servidor local de MySQL/MariaDB del entorno activo escucha en el puerto `3307`. Se ajustaron los puntos de conexion utilizados por la aplicacion para que las JSP utilicen:

- Host: `localhost`.
- Puerto: `3307`.
- Base de datos: `dream_house`.
- Usuario: `root`.
- Contrasena: vacia en el entorno probado.

La clase Java mantiene un puerto alternativo `3306` y una alternativa de contrasena para facilitar la ejecucion en otros entornos del equipo. Estas diferencias deben confirmarse antes de una entrega final.

Archivos relacionados:

- `WEB-INF/jspf/conexion.jspf`.
- `src/conexion/ConexionBD.java`.
- `test-conexion.jsp`.

### 3.2 Compilacion Java y Tomcat

Se recompilaron las clases Java para Java 8, que corresponde al bytecode compatible con la configuracion de Tomcat utilizada:

```powershell
javac --release 8 -Xlint:-options -cp ".\\WEB-INF\\lib\\jbcrypt-0.4.jar;.\\WEB-INF\\lib\\mysql-connector-j-9.7.0.jar" -d .\\WEB-INF\\classes .\\src\\seguridad\\HashContrasenas.java .\\src\\conexion\\ConexionBD.java
```

Las clases compiladas se guardaron en `WEB-INF/classes`. La compilacion termino correctamente con codigo de salida `0`.

Tambien se reinicio Tomcat para que recargara las librerias y las clases compiladas.

### 3.3 Hash de contrasenas

Se creo la clase `seguridad.HashContrasenas` para encapsular el uso de BCrypt desde las JSP. Esto permite que el registro y el login utilicen una clase Java propia sin cambiar el formato de los hashes existentes.

Funciones disponibles:

- `generar`: crea un hash BCrypt.
- `coincide`: verifica una contrasena contra un hash almacenado.

La dependencia utilizada es `WEB-INF/lib/jbcrypt-0.4.jar`.

### 3.4 Correccion de JSPF

Se corrigio una declaracion JSP anidada en `WEB-INF/jspf/utilidades.jspf` que impedia compilar las paginas que incluian ese fragmento. Las paginas de panel de inmobiliaria volvieron a compilar despues de limpiar la cache JSP y reiniciar Tomcat.

### 3.5 Navegacion de usuarios autenticados

La portada tenia un segundo boton de inicio de sesion dentro del llamado a la accion inferior, que se mostraba incluso cuando el usuario ya habia iniciado sesion.

Se ajusto la portada para que:

- un visitante vea `Iniciar sesion`;
- un administrador vea un acceso a su panel;
- una inmobiliaria vea un acceso a su panel;
- un cliente vea un acceso a su panel.

### 3.6 Catalogo de propiedades

`propiedades.jsp` contenia accidentalmente texto de documentacion en lugar de una pagina funcional. Se reconstruyo como catalogo publico con consulta JDBC.

El catalogo:

- consulta propiedades con estado `disponible`;
- muestra titulo, ciudad, tipo, operacion, precio, habitaciones, banos y area;
- utiliza la primera imagen registrada cuando existe;
- muestra una imagen de respaldo cuando no existe imagen;
- enlaza cada propiedad con `detalle-propiedad.jsp`;
- muestra un estado vacio cuando no hay propiedades disponibles;
- muestra un mensaje controlado si ocurre un error de consulta.

Tambien se corrigio la conexion compartida de las JSP para que el catalogo pueda consultar la base de datos en el puerto activo.

## 4. Plantilla de inventario de entorno

Se agrego la plantilla `docs/sprints/sprint0/entorno-lizzy.md` para que otro integrante registre su configuracion local.

La plantilla solicita informacion sobre:

- sistema operativo y herramientas;
- Java y variables de entorno;
- XAMPP, Apache y Tomcat;
- MySQL/MariaDB, host y puerto;
- diferencias entre `conexion.jspf` y `ConexionBD.java`;
- librerias desplegadas;
- tablas de la base de datos;
- pruebas del entorno;
- problemas y soluciones.

Su proposito es documentar las diferencias entre el entorno que usa el puerto `3306` y el que usa el puerto `3307`.

## 5. Validaciones realizadas

Se comprobaron las siguientes rutas con Tomcat activo:

| Ruta | Resultado |
|---|---|
| `/` | HTTP 200 |
| `/test-conexion.jsp` | HTTP 200 |
| `/login.jsp` | HTTP 200 |
| `/registro.jsp` | HTTP 200 |
| `/propiedades.jsp` | HTTP 200 |
| `/cliente/inicio.jsp` sin sesion | Redireccion a `login.jsp` |
| `/admin/inicio.jsp` sin sesion | Redireccion a `login.jsp` |

Tambien se verifico que no quedaran errores nuevos de `JasperException`, `NoClassDefFoundError` o `ExceptionInInitializerError` despues del reinicio de Tomcat.

## 6. Alcance alcanzado

La jornada deja estable la base tecnica para continuar el Sprint 2 y permite probar el catalogo publico. No se considera que con estas actividades quede terminado el Sprint 2 ni el parcial completo.

Continuan pendientes para cumplir integralmente la guia del parcial:

- buscador con filtros reales;
- CRUD completo de propiedades con baja logica;
- filtro de servlet para proteger rutas privadas;
- carga real de documentos;
- validacion de disponibilidad y cruces de citas;
- reportes con `GROUP BY` y `HAVING`;
- datos de prueba suficientes;
- matricula inmobiliaria con restriccion `UNIQUE`;
- MER, modelo relacional, diccionario de datos y casos de uso;
- documentacion completa de los tres sprints y tablero de seguimiento.

## 7. Conclusion

El trabajo de hoy resolvio bloqueos de configuracion y ejecucion que afectaban la prueba de la aplicacion. La conexion JDBC, las clases Java, las JSP compartidas y el catalogo publico quedaron disponibles para continuar el desarrollo del Sprint 2 con una base verificable.

## 8. Incremento posterior: buscador de propiedades

Se completo el primer incremento funcional del Sprint 2 sobre el catalogo publico. El formulario de busqueda de `propiedades.jsp` ahora consulta y aplica filtros reales mediante `PreparedStatement`.

Filtros implementados:

- ciudad;
- tipo de propiedad;
- operacion de venta o alquiler;
- precio minimo;
- precio maximo;
- caracteristica asociada mediante la relacion `propiedad_caracteristica`.

El formulario conserva los valores seleccionados, permite limpiar los filtros y muestra un estado vacio cuando la combinacion no encuentra propiedades.

### Pruebas del incremento

Se probaron estas solicitudes en Tomcat:

| Escenario | Resultado |
|---|---|
| Catalogo sin filtros | HTTP 200 |
| Filtro por operacion | HTTP 200 |
| Filtro por rango de precio | HTTP 200 |
| Filtros sin coincidencias | HTTP 200, estado vacio |

No se generaron errores nuevos de compilacion JSP ni de consulta SQL durante estas pruebas.

## 9. Datos demo para pruebas manuales

Se agrego el script `database/querys/datos-prueba-sprint2.sql`. El script es idempotente para los registros demo principales y permite preparar el entorno local con:

- un usuario con rol `Inmobiliaria`;
- una inmobiliaria demo;
- tres ciudades;
- tres tipos de propiedad;
- cuatro caracteristicas;
- tres propiedades disponibles;
- tres imagenes principales.

Credenciales del usuario demo:

- Correo: `agente.demo@dreamhouse.local`
- Contrasena: `Prueba123!`

El script no reemplaza datos existentes y debe ejecutarse solo en un entorno de pruebas.

### Pruebas realizadas con datos demo

| Escenario | Resultado |
|---|---|
| Catalogo completo | 3 propiedades |
| Filtro `operacion=venta` | 2 propiedades |
| Filtro `operacion=alquiler` | 1 propiedad |
| Filtro por ciudad Bucaramanga | 1 propiedad |
