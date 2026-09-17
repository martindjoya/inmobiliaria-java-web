# Sprint Review 3

## 1. Objetivo

Revisar el incremento final de Dream House S.A. frente al alcance del Sprint 3 y comprobar que las operaciones principales del sistema funcionan con control de acceso, validaciones de negocio, auditoria, reportes y documentacion tecnica.

## 2. Incremento entregado

### Seguridad y acceso

- Se incorporo `ControlAccesoFilter` para proteger las rutas de Cliente, Inmobiliaria y Administrador.
- Se agrego una pantalla de acceso denegado.
- Se conservaron las validaciones de sesion y rol en las JSP.

### Operacion inmobiliaria

- Las propiedades validan valores numericos, estados y pertenencia a la inmobiliaria.
- La matricula inmobiliaria es obligatoria y unica.
- Las citas validan fecha futura, propiedad disponible y conflictos de horario.
- Las solicitudes validan propiedad disponible, tipo permitido y duplicados activos.
- Las transiciones de citas y solicitudes no permiten regresar a estados anteriores.

### Documentos

- Se reemplazo el registro simulado por carga multipart real.
- Los archivos se limitan a PDF, JPG, JPEG y PNG, con maximo de 5 MB.
- Los archivos se almacenan bajo `WEB-INF/uploads` y se valida la pertenencia de la solicitud.

### Auditoria y reportes

- Los cambios de estado efectivos de citas y solicitudes quedan registrados en `auditoria`.
- El panel administrativo incluye reportes de propiedades, citas, solicitudes y propiedades sin citas.
- Se documentaron las cinco consultas SQL obligatorias.

### Modelo y documentacion

- Se documento el modelo de datos y sus relaciones 1:1, 1:N y N:M.
- Se agrego la migracion de matricula y el DDL actualizado.
- Se preparo una matriz de pruebas reproducible.

## 3. Validacion del alcance

El incremento cumple el alcance funcional priorizado del Sprint 3 y fue probado manualmente por flujo. Las consultas SQL obligatorias se ejecutaron en MariaDB `3307`.

La entrega local esta verificada. El despliegue en linea, las capturas, el tablero externo y la sustentacion individual deben adjuntarse como evidencia academica cuando corresponda.

## 4. Decision

El Sprint 3 se considera funcionalmente aceptado para el entorno local probado. La entrega queda preparada para cierre documental y sustentacion, con las evidencias externas identificadas como pendientes de adjuntar.
