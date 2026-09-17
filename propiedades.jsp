Necesito que generes un archivo/documento de documentación correspondiente al:

SPRINT 3 – DREAM HOUSE S.A.

IMPORTANTE:
NO necesitas revisar ningún otro archivo del proyecto.
NO necesitas modificar código.
NO necesitas crear código.
NO necesitas pedirme que suba archivos.
Toda la información necesaria para redactar este documento está en este prompt.

El archivo debe quedar redactado como documentación académica de un Sprint de un proyecto universitario de desarrollo de software.

==================================================
INFORMACIÓN DEL PROYECTO
==================================================

Nombre:
Dream House S.A.

Tipo:
Aplicación web para una inmobiliaria.

Tecnologías utilizadas:

- Java
- JSP
- JSPF
- JDBC
- HTML5
- CSS3
- JavaScript
- Bootstrap
- MySQL
- Apache Tomcat
- XAMPP
- Visual Studio Code
- Git/GitHub

MySQL y Tomcat se ejecutan mediante XAMPP.

La aplicación permite gestionar usuarios, roles, propiedades inmobiliarias, citas, solicitudes, documentos, favoritos y auditoría.

Los roles principales del sistema son:

- Cliente
- Inmobiliaria
- Administrador
- Visitante

==================================================
ESTADO DEL PROYECTO AL INICIO DEL SPRINT 3
==================================================

Al llegar al Sprint 3, el proyecto ya tenía implementada la estructura principal de la aplicación y las funcionalidades principales.

Durante el desarrollo se habían presentado problemas relacionados principalmente con:

- conexión entre la aplicación y MySQL
- configuración de XAMPP
- registro de usuarios
- existencia de roles en la base de datos
- validación del teléfono
- compilación/carga de la clase de conexión en Tomcat
- funcionamiento del login y sus componentes

Estos problemas fueron corregidos durante el desarrollo.

==================================================
CAMBIOS REALIZADOS
==================================================

1. CONEXIÓN A MYSQL

Se ajustó la conexión de la aplicación a la configuración real utilizada en XAMPP.

Configuración final:

- usuario MySQL: root
- contraseña: vacía
- puerto: 3306

También se añadió:

allowPublicKeyRetrieval=true

a la configuración de conexión JDBC.

La clase utilizada para la conexión es:

ConexionBD.java

==================================================
2. REGISTRO DE USUARIOS

Se corrigió el flujo de registro en:

procesar-registro.jsp

Anteriormente el registro exigía que el rol "Cliente" ya existiera en la base de datos y esto provocaba errores cuando el rol no estaba creado.

La solución implementada permite crear automáticamente el rol "Cliente" si no existe mediante:

INSERT IGNORE

Posteriormente se realiza la asignación del rol al usuario.

El registro permite almacenar:

- nombre
- correo electrónico
- teléfono
- dirección
- contraseña

La información del usuario se almacena en las tablas correspondientes de la base de datos.

==================================================
3. ROLES INICIALES

También se preparó el archivo:

dream_house.sql

para incluir los roles iniciales:

- Cliente
- Inmobiliaria
- Administrador

Esto permite que el sistema pueda trabajar correctamente con los diferentes perfiles de usuario.

==================================================
4. CONTRASEÑAS

Las contraseñas de los usuarios NO se almacenan directamente como texto plano.

El sistema utiliza hash seguro para almacenar las contraseñas y posteriormente verificar las credenciales durante el inicio de sesión.

==================================================
5. VALIDACIÓN DEL TELÉFONO

Se corrigió la validación HTML del teléfono en:

registro.jsp

El patrón utilizado anteriormente estaba escrito incorrectamente y provocaba errores de validación en el navegador.

La validación fue corregida para permitir que el formulario de registro funcione correctamente.

==================================================
6. TOMCAT

Se recompiló la clase Java de conexión para que Tomcat utilizara la versión corregida de:

ConexionBD.java

Esto permitió solucionar problemas relacionados con la versión anterior de la clase de conexión.

==================================================
FUNCIONAMIENTO GENERAL DEL SISTEMA
==================================================

El flujo principal de la aplicación es:

VISITANTE
↓
index.jsp
↓
consulta propiedades
↓
detalle de propiedad
↓
registro o login
↓
autenticación
↓
identificación del rol
↓
panel correspondiente

Los usuarios autenticados pueden acceder a funcionalidades según su rol.

==================================================
MÓDULO CLIENTE
==================================================

El cliente puede:

- consultar propiedades
- consultar detalles de propiedades
- gestionar favoritos
- gestionar citas
- consultar solicitudes
- consultar documentos relacionados
- actualizar su perfil

La carpeta correspondiente es:

cliente/

con páginas como:

- inicio.jsp
- favoritos.jsp
- mis-citas.jsp
- mis-solicitudes.jsp
- perfil.jsp

==================================================
MÓDULO INMOBILIARIA
==================================================

El usuario con rol Inmobiliaria puede trabajar con:

- propiedades
- publicación de propiedades
- edición de propiedades
- imágenes
- características
- citas
- solicitudes
- información relacionada con sus operaciones

La carpeta correspondiente es:

inmobiliaria/

==================================================
MÓDULO ADMINISTRADOR
==================================================

El administrador tiene funciones relacionadas con:

- usuarios
- roles
- propiedades
- supervisión del sistema
- auditoría
- información general

La carpeta correspondiente es:

admin/

==================================================
BASE DE DATOS
==================================================

La base de datos se llama:

dream_house

Contiene las siguientes tablas:

- usuario
- rol
- usuario_rol
- perfil
- inmobiliaria
- ciudad
- tipo_propiedad
- propiedad
- imagen_propiedad
- caracteristica
- propiedad_caracteristica
- cita
- solicitud
- documento_solicitud
- favorito
- auditoria

El modelo permite trabajar con relaciones:

- 1:1
- 1:N
- N:M

==================================================
ESTRUCTURA GENERAL
==================================================

La aplicación está organizada siguiendo una estructura basada en los ejercicios/simulacros trabajados en clase.

En la raíz se encuentran páginas públicas y de autenticación como:

- index.jsp
- login.jsp
- registro.jsp
- acceso.jsp
- procesar-login.jsp
- procesar-registro.jsp
- logout.jsp
- propiedades.jsp
- detalle-propiedad.jsp

Además existen carpetas independientes por rol:

- cliente/
- inmobiliaria/
- admin/

Y elementos comunes:

- css/
- js/
- WEB-INF/

Dentro de WEB-INF se utilizan fragmentos JSPF y librerías necesarias para el funcionamiento de la aplicación.

==================================================
OBJETIVO DEL SPRINT 3
==================================================

El Sprint 3 corresponde a la etapa de cierre y consolidación del proyecto.

Sus objetivos fueron:

- corregir errores encontrados durante las pruebas
- estabilizar la conexión con MySQL
- completar y verificar el registro
- asegurar la existencia de los roles necesarios
- corregir validaciones del formulario
- verificar el funcionamiento de autenticación y sesiones
- integrar los módulos de los diferentes roles
- comprobar el funcionamiento general de la aplicación
- preparar el proyecto para su prueba final
- dejar la aplicación lista para ser probada por otro integrante del equipo

==================================================
RESULTADOS DEL SPRINT 3
==================================================

Como resultado del Sprint 3:

- Se corrigió la conexión JDBC con MySQL.
- Se adaptó la conexión a la configuración real de XAMPP.
- Se corrigió el registro de usuarios.
- Se solucionó el problema relacionado con la inexistencia del rol Cliente.
- Se prepararon los roles iniciales en la base de datos.
- Se corrigió la validación del teléfono.
- Se recompiló la clase de conexión para Tomcat.
- El registro de usuarios logró completar correctamente el alta.
- La aplicación quedó preparada para continuar con las pruebas de integración.
- Se consolidó la estructura de módulos por rol.

==================================================
PRUEBAS DEL SPRINT
==================================================

Documenta las siguientes pruebas como pruebas realizadas o previstas dentro del cierre del Sprint:

1. Comprobar conexión entre la aplicación y MySQL mediante XAMPP.

2. Registrar un usuario nuevo.

3. Intentar registrar un correo electrónico existente.

4. Verificar que la contraseña se almacene mediante hash.

5. Verificar que el usuario quede asociado al rol Cliente.

6. Iniciar sesión con un usuario registrado.

7. Verificar que el usuario activo pueda acceder a su área correspondiente.

8. Comprobar el cierre de sesión.

9. Comprobar que un usuario no pueda acceder a funciones correspondientes a otro rol.

10. Probar las funcionalidades principales de Cliente.

11. Probar las funcionalidades principales de Inmobiliaria.

12. Probar las funcionalidades principales de Administrador.

13. Comprobar las operaciones principales relacionadas con propiedades.

14. Comprobar citas, solicitudes, favoritos y demás funciones implementadas.

==================================================
REDACCIÓN
==================================================

Quiero que el archivo tenga tono:

- académico
- claro
- profesional
- natural
- conciso

NO quiero que parezca escrito por una IA.

NO utilices frases exageradas como:

"se logró un éxito rotundo"
"se revolucionó el sistema"
"excelente implementación"
"solución innovadora"

Debe sonar como un informe real de estudiantes universitarios.

NO inventes resultados, porcentajes, tiempos, métricas, errores específicos o pruebas que no estén mencionadas en este prompt.

Si una prueba no tiene un resultado específico indicado, redacta el apartado de manera general sin inventar el resultado.

==================================================
ESTRUCTURA DEL DOCUMENTO
==================================================

El archivo debe contener:

1. SPRINT 3 – DREAM HOUSE S.A.

2. Objetivo del Sprint

3. Estado inicial

4. Actividades realizadas

5. Correcciones y soluciones implementadas

6. Integración de los módulos

7. Base de datos y conexión

8. Autenticación y roles

9. Pruebas realizadas

10. Resultados del Sprint

11. Dificultades encontradas y soluciones

12. Estado final del proyecto

13. Conclusiones del Sprint 3

14. Pendientes o recomendaciones finales, únicamente si realmente corresponden.

No agregues una sección de "pendientes" que haga parecer que el proyecto está incompleto si la información proporcionada indica que el proyecto fue terminado.

==================================================
FORMATO
==================================================

Quiero que generes un archivo independiente llamado:

SPRINT_3_DREAM_HOUSE_SA

Preferiblemente en formato .docx.

Debe tener:

- título principal
- subtítulos numerados
- párrafos claros
- listas cuando sean apropiadas
- tablas solamente cuando realmente aporten
- formato limpio y académico

NO incluy código fuente extenso dentro del documento.

El documento debe funcionar como evidencia/documentación del trabajo realizado durante el Sprint 3, no como manual de programación.

Antes de generar el archivo, utiliza exclusivamente la información proporcionada en este prompt y no inventes información adicional.
