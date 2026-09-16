# Inventario inicial del proyecto Dream House S.A.

## 1. Información general

- Nombre del proyecto: Dream House S.A.
- Tipo de aplicación: sistema web de gestión inmobiliaria.
- Tecnologías principales: Java, JSP, JDBC, MySQL/MariaDB, HTML, CSS, JavaScript, Tomcat.
- Entorno de despliegue local: Apache Tomcat + XAMPP.
- Estado inicial: proyecto en fase de estructura base y documentación de entorno.

---

## 2. Objetivo del sistema

El proyecto está orientado a gestionar una inmobiliaria con flujo de usuarios y propiedades, permitiendo:

- registro e inicio de sesión de usuarios;
- diferenciación de roles (cliente, agente, administrador);
- gestión de propiedades y su información comercial;
- registro de citas, solicitudes y favoritos;
- administración de datos asociados a inmobiliarias, ciudades y tipos de propiedad.

---

## 3. Inventario de archivos y carpetas

### 3.1 Raíz del proyecto

- `index.jsp` — página principal de entrada.
- `login.jsp` — formulario de acceso al sistema.
- `registro.jsp` — formulario de registro de usuario.
- `procesar-login.jsp` — lógica de autenticación.
- `procesar-registro.jsp` — lógica de registro.
- `logout.jsp` — cierre de sesión.
- `bienvenida-admin.jsp` — panel o bienvenida para administradores.
- `bienvenida-agente.jsp` — panel o bienvenida para agentes.
- `bienvenida-cliente.jsp` — panel o bienvenida para clientes.
- `test-conexion.jsp` — comprobación de conexión a la base de datos.

### 3.2 Carpeta `css`

- `css/estilos.css` — hoja de estilos principal del proyecto.

### 3.3 Carpeta `database`

- `database/dream_house.sql` — script de creación de base de datos y tablas del sistema.

### 3.4 Carpeta `src`

- `src/conexion/ConexionBD.java` — clase encargada de conectar la aplicación a la base de datos MySQL usando JDBC.

### 3.5 Carpeta `WEB-INF`

- `WEB-INF/classes/` — clases compiladas o archivos Java generados para la aplicación web.
- `WEB-INF/lib/` — librerías externas del proyecto (dependencias Java/servlet/JDBC).

### 3.6 Carpeta `WebContent`

- `WebContent/recursos/img/` — recursos gráficos e imágenes del proyecto.

### 3.7 Carpeta `docs`

- `docs/README.md` — resumen general del repositorio y tecnologías.
- `docs/sprints/sprint0/` — documentación del sprint inicial y preparación del entorno.
- `docs/sprints/sprint1/` — documentación del primer sprint.
- `docs/sprints/sprint2/` — documentación del segundo sprint.
- `docs/sprints/sprint3/` — documentación del tercer sprint.

---

## 4. Componentes funcionales del sistema

### 4.1 Autenticación y acceso

Se observa un flujo base de login y registro con páginas JSP separadas para:

- ingreso de credenciales;
- procesamiento del login;
- alta de nuevos usuarios;
- cierre de sesión;
- redirección según tipo de perfil.

### 4.2 Roles de usuario

El sistema contempla perfiles para:

- Administrador;
- Agente inmobiliario;
- Cliente.

Esto se refleja en las páginas de bienvenida y en la lógica de roles prevista en la base de datos.

### 4.3 Gestión inmobiliaria

Los datos principales del negocio están centrados en:

- inmobiliaria;
- ciudad;
- tipo de propiedad;
- propiedad;
- imágenes de propiedad;
- características de la propiedad.

### 4.4 Interacción con clientes

El modelo de datos incluye funcionalidades como:

- citas para visitas;
- solicitudes de compra/alquiler;
- documentos adjuntos asociados a solicitudes;
- favoritos por usuario.

### 4.5 Auditoría

El esquema contempla una tabla de auditoría para registrar acciones del sistema y cambios relevantes.

---

## 5. Inventario de base de datos

La base de datos principal es `dream_house`, con las siguientes entidades principales:

- `rol` — roles del sistema.
- `usuario` — usuarios registrados.
- `usuario_rol` — relación entre usuarios y roles.
- `perfil` — datos complementarios del usuario.
- `inmobiliaria` — información de la agencia/inmobiliaria.
- `ciudad` — ciudades y departamentos.
- `tipo_propiedad` — tipo de inmueble.
- `propiedad` — inmuebles disponibles o gestionados.
- `imagen_propiedad` — fotos asociadas a una propiedad.
- `caracteristica` — atributos de la propiedad.
- `propiedad_caracteristica` — relación entre propiedades y características.
- `cita` — visitas agendadas.
- `solicitud` — peticiones de compra o alquiler.
- `documento_solicitud` — archivos adjuntos a una solicitud.
- `favorito` — propiedades marcadas como favoritas.
- `auditoria` — registro de eventos del sistema.

### Configuración relevante

- Motor: MySQL / MariaDB compatible.
- Charset: `utf8mb4`.
- Motor de almacenamiento: InnoDB.
- Conexión principal: `jdbc:mysql://localhost:3306/dream_house?useSSL=false&serverTimezone=UTC`.
- Usuario de acceso: `root`.
- Contraseña de conexión configurada en código: `1234`.

---

## 6. Tecnologías y dependencias

### Backend

- Java SE / Java EE con JSP.
- JDBC para acceso a base de datos.
- Tomcat como contenedor de aplicaciones web.

### Base de datos

- MariaDB/MySQL.
- Script SQL definido en `database/dream_house.sql`.

### Frontend

- HTML5
- CSS3
- JavaScript
- Estilos personalizados en `css/estilos.css`

---

## 7. Estado inicial del proyecto

Actualmente el repositorio presenta una base funcional y organizada para continuar con desarrollo:

- estructura web principal definida;
- formularios básicos de autenticación;
- conexión de base de datos implementada;
- esquema SQL con entidades del dominio inmobiliario;
- documentación inicial del entorno y del sprint.

### Pendientes de validación

- verificar que los JSP se despliegan correctamente en Tomcat;
- confirmar que el driver JDBC esté disponible en el classpath;
- comprobar la versión real del servidor MySQL/MariaDB y la base de datos `dream_house`;
- revisar rutas de archivos y despliegue final en entorno local.

---

## 8. Resumen ejecutivo

Dream House S.A. es un proyecto web de gestión inmobiliaria con arquitectura Java/JSP y conexión a MySQL/MariaDB. El inventario inicial indica una base sólida de estructura, formularios, base de datos y documentación, con el siguiente foco inmediato: consolidar la configuración del entorno, verificar la conexión y continuar con el desarrollo funcional del sistema.
