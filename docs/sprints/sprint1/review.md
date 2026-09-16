# Sprint Review 1

## 1. Objetivo del review

Revisar qué se logró en el Sprint 1 y verificar si la entrega cumple con el alcance definido para un MVP de autenticación y acceso, teniendo en cuenta que el trabajo se desarrolló en un tiempo real de 2 horas.

---

## 2. Alcance planteado para el sprint

El sprint se enfocó en la base del sistema de acceso:

- registro de usuarios;
- login;
- validación de credenciales;
- diferenciación por roles;
- redirección según perfil;
- cierre de sesión.

Este enfoque se ajustó a la guía del parcial y a la disponibilidad real del tiempo de trabajo.

---

## 3. Resultado entregado

### Logrado

- Se revisó la estructura base del proyecto.
- Se validó la conexión a la base de datos mediante JDBC.
- Se identificó la existencia de la base `dream_house` y el esquema de usuarios/roles.
- Se implementó el registro de usuarios con validación de campos, correo duplicado y contraseña cifrada.
- Se implementó el inicio de sesión con validación de credenciales y cuenta activa.
- Se implementó la redirección por rol hacia las bienvenidas de administrador, agente y cliente.
- Se implementó el cierre de sesión mediante invalidación de la sesión y redirección al login.
- Se protegieron las páginas de bienvenida contra usuarios no autenticados o con un rol incorrecto.
- Se añadió el fallback de conexión para los puertos `3306` y `3307`, y para `root` con contraseña `1234` o vacía.
- Se corrigió la compatibilidad del bytecode con Tomcat recompilando para Java 8.

### Criterios cumplidos

- Un usuario puede registrarse correctamente y queda asociado al rol `Cliente`.
- Las credenciales válidas permiten iniciar sesión.
- Las credenciales inválidas producen mensajes de error.
- La aplicación redirige al usuario según su rol.
- Las páginas protegidas rechazan el acceso sin sesión o con un rol no autorizado.
- El usuario puede cerrar sesión desde las pantallas de bienvenida.
- La conexión JDBC funciona con la configuración activa de MariaDB.

### Pruebas realizadas

- `test-conexion.jsp`: conexión exitosa con la base de datos.
- `logout.jsp`: respuesta HTTP `302` hacia `login.jsp`.
- `login.jsp`: respuesta HTTP `200`.
- `bienvenida-cliente.jsp` sin sesión: respuesta HTTP `302` hacia `login.jsp`.
- Compilación de `ConexionBD.java` con `javac --release 8` y bytecode `major version: 52`.

---

## 4. Lo que no se entregó en este sprint

No corresponde considerar completado el proyecto integral del parcial, porque este sprint no incluye:

- gestión completa de propiedades;
- flujo completo de citas;
- solicitudes avanzadas;
- paneles completos por rol;
- seguridad avanzada de autenticación;
- documentación completa del MER y del diccionario de datos.

Esto se debe a que se priorizó la funcionalidad mínima viable dentro del tiempo disponible.

---

## 5. Validación del alcance

El sprint cumple con su objetivo realista si se entiende como una primera capa funcional del sistema. En ese sentido, sí se logra una base de acceso útil para continuar con el desarrollo del proyecto inmobiliario.

Sin embargo, no se puede presentar como una entrega completa del parcial, porque la guía exige un alcance más amplio de negocio, documentación y diseño.

---

## 6. Conclusión del review

El Sprint 1 se considera terminado como MVP de autenticación y acceso. La entrega cubre registro, login, roles, protección de páginas y cierre de sesión, y deja el proyecto preparado para continuar con las funcionalidades inmobiliarias.

No se considera terminado el proyecto integral del parcial, porque las propiedades, citas, solicitudes, favoritos, reportes y la seguridad avanzada pertenecen a los siguientes sprints o están fuera del alcance actual.

La recomendación es mantener esta línea para no sobreestimar el alcance y para evitar presentar una solución que no esté respaldada por la funcionalidad real implementada.
