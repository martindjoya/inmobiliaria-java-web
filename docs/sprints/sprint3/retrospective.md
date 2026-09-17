# Sprint Retrospective 3

## 1. Que salio bien

- El trabajo se dividio por caracteristicas y cada incremento tuvo una prueba manual antes de continuar.
- Se corrigio el despliegue de Tomcat cuando el filtro servlet provoco un contexto detenido por falta de compilacion.
- Las validaciones se aplicaron en servidor, no solo en la interfaz.
- La carga de documentos paso de simulacion a archivo multipart real.
- La migracion de matricula se aplico y comprobo en la base MariaDB activa.
- Las consultas obligatorias se ejecutaron contra datos reales.
- El historial de commits permite rastrear cada caracteristica.

## 2. Que fue dificil

- La configuracion global `JAVA_HOME` apuntaba a una ruta inexistente y dificulto reiniciar Tomcat.
- La diferencia entre los puertos 3306 y 3307 produjo confusiones al preparar el usuario Administrador.
- Los archivos JSP mezclan presentacion y acceso a datos, por lo que los cambios requieren cuidado con el alcance de variables y el cierre de conexiones.
- Las primeras pruebas del filtro devolvieron 404 porque el contexto habia fallado al recargar.
- El entorno actual no tenia inicialmente un usuario Administrador demo.

## 3. Que aprendimos

- Cada caracteristica debe compilarse y probarse antes de crear el commit.
- Los cambios de base de datos necesitan una migracion reproducible, no solo una modificacion manual.
- Las reglas de estado deben validarse en servidor y reflejarse en los controles de la interfaz.
- Los scripts SQL deben ejecutarse indicando explicitamente host, puerto y base.
- La evidencia de la rubrica debe planificarse junto con el desarrollo.

## 4. Acciones de mejora

| Accion | Responsable | Momento |
|---|---|---|
| Mantener una configuracion documentada de Java y Tomcat | Equipo | Antes de cada despliegue |
| Ejecutar scripts SQL con el puerto explicitamente indicado | Equipo | En cada entorno |
| Separar acceso a datos en controladores o servicios | Equipo | Proximo ciclo |
| Agregar pruebas automatizadas para transiciones y permisos | Equipo | Proximo ciclo |
| Conservar capturas y enlaces del tablero junto al review | Equipo | Antes de la sustentacion |
| Revisar el esquema en una base limpia | Equipo | Antes de entregar |

## 5. Conclusion

El Sprint 3 logro cerrar los flujos funcionales prioritarios y dejo identificadas las evidencias externas que aun deben adjuntarse. La principal mejora para el siguiente ciclo es separar la logica JDBC de las JSP y automatizar las pruebas de seguridad y transiciones.
