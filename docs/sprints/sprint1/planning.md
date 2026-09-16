# Sprint Planning 1

## 1. Contexto del sprint

Durante la revisión de la guía del proyecto, se confirma que el objetivo general del curso es desarrollar una aplicación web Java/JSP para la administración de una inmobiliaria, con:

- página de aterrizaje;
- autenticación con contraseñas cifradas;
- control de acceso por roles diferenciados;
- gestión de propiedades;
- citas y solicitudes;
- base de datos relacional con relaciones y restricciones.

La guía además indica que el proyecto se trabaja en tres sprints, cada uno con duración aproximada de 7 días. Sin embargo, para este día concreto solo se dispone de 2 horas para trabajar en el Sprint 1. Por tanto, el alcance debe limitarse a la parte mínima viable del inicio del sistema: autenticación y acceso por roles.

---

## 2. Objetivo del Sprint 1 (alcance realista para 2 horas)

Implementar la base funcional del sistema de acceso para que un usuario pueda:

- registrarse;
- iniciar sesión;
- autenticarse con su email y contraseña;
- ser redirigido según su rol;
- cerrar sesión.

Este sprint no busca entregar la gestión completa de propiedades ni la funcionalidad de citas/solicitudes. La meta es dejar preparada la base de acceso del sistema para que en el siguiente sprint se continúe con el resto del negocio inmobiliario.

---

## 3. Alcance real del sprint

### Incluye

- revisión del proyecto actual y de la estructura existente;
- validación de la conexión JDBC a la base de datos;
- comprobación de tablas `usuario`, `rol` y `usuario_rol`;
- registro de usuarios básicos;
- login de usuarios;
- validación de credenciales;
- redirección por rol;
- cierre de sesión;
- mensajes básicos de error/éxito.

### No incluye

- gestión completa de propiedades;
- CRUD de ventas, alquileres o inmuebles;
- citas complejas;
- solicitudes con documentos;
- paneles avanzados por perfil;
- seguridad avanzada (hash fuerte, sesiones complejas, JWT, roles por permisos). 

---

## 4. Historias de usuario del sprint

### HU-01: Registro de usuario

Como visitante,
quiero crear una cuenta,
para poder acceder al sistema.

Criterios de aceptación:
- El usuario puede ingresar nombre, email y contraseña.
- El sistema valida que el email no esté duplicado.
- El registro genera un usuario activo en la base de datos.
- Si el registro falla, se muestra un mensaje claro.

### HU-02: Inicio de sesión

Como usuario registrado,
quiero iniciar sesión,
para acceder a la aplicación.

Criterios de aceptación:
- El usuario puede ingresar email y contraseña.
- El sistema valida las credenciales.
- Si los datos son correctos, inicia sesión.
- Si son incorrectos, muestra un mensaje de error.

### HU-03: Acceso según rol

Como sistema,
quiero identificar el rol del usuario,
para redirigirlo a la vista correcta.

Criterios de aceptación:
- El usuario tiene asociado un rol.
- Tras iniciar sesión, la aplicación redirige según el perfil.
- Si no tiene rol válido, se informa que no tiene acceso.

### HU-04: Cierre de sesión

Como usuario autenticado,
quiero cerrar sesión,
para salir del sistema de forma segura.

Criterios de aceptación:
- Se invalida la sesión actual.
- El usuario vuelve a la pantalla de login.

---

## 5. Backlog de trabajo y tiempos estimados

### 5.1 Preparación y revisión (15 min)

- Revisar estructura del proyecto actual.
- Confirmar archivos JSP existentes.
- Revisar conexión a base de datos.
- Comprobar si existen tablas de usuarios, roles y relación.

### 5.2 Base de datos y roles (20 min)

- Validar esquema de `usuario`, `rol`, `usuario_rol`.
- Ajustar SQL si hace falta.
- Confirmar que el usuario pueda guardar un registro válido.

### 5.3 Registro (20 min)

- Implementar lógica en `procesar-registro.jsp`.
- Validar campos obligatorios.
- Insertar nuevo usuario y relación con rol.
- Mostrar mensajes de éxito o error.

### 5.4 Login (20 min)

- Implementar lógica en `procesar-login.jsp`.
- Consultar usuario por email.
- Validar contraseña.
- Iniciar sesión y guardar la información del usuario.

### 5.5 Redirección por rol y sesión (20 min)

- Identificar rol del usuario autenticado.
- Redirigir a `bienvenida-admin.jsp`, `bienvenida-agente.jsp` o `bienvenida-cliente.jsp`.
- Validar sesión para páginas protegidas.

### 5.6 Cierre de sesión y pruebas (15 min)

- Implementar `logout.jsp`.
- Probar registro e inicio de sesión manualmente.
- Corregir errores rápidos.

### Total estimado

120 minutos = 2 horas.

---

## 6. Definición de terminado (DoD)

El Sprint 1 se considera terminado si:

- un usuario puede registrarse correctamente;
- un usuario puede iniciar sesión correctamente;
- el sistema valida credenciales y muestra errores entendibles;
- el sistema redirige según el rol del usuario;
- la sesión se cierra correctamente;
- la funcionalidad principal ha sido probada manualmente.

---

## 7. Riesgos y limitaciones del sprint

- La base de datos puede requerir ajustes mínimos para cumplir con el modelo de roles.
- La conexión JDBC puede fallar si el driver no está bien configurado.
- El tiempo disponible es muy limitado, así que se prioriza autenticación sobre funcionalidad de negocio.
- La seguridad no será completa; solo se hará una versión funcional y básica.

---

## 8. Plan de entrega hoy

Este sprint debe entregarse como una primera versión funcional del módulo de autenticación y acceso. El objetivo no es terminar el sistema completo, sino dejar una base operativa para continuar con los siguientes módulos del proyecto inmobiliario.

En términos prácticos, la entrega mínima hoy es:

1. registro funcional;
2. login funcional;
3. roles y redirección;
4. cierre de sesión.

Si se logra esto, el proyecto queda en una base sólida para continuar con el siguiente sprint.

---

## 9. Resumen ejecutivo

El Sprint 1 debe centrarse en la capa de autenticación del sistema, porque la guía del curso lo define como una base indispensable para la aplicación inmobiliaria. Dado que hoy solo hay 2 horas, el alcance debe reducirse a un MVP de acceso: registrar, autenticar, identificar el rol y redirigir. Eso cumple con la intención del proyecto y deja preparado el camino para la gestión de inmuebles, citas y solicitudes.
