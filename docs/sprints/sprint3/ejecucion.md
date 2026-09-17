# Ejecucion del Sprint 3

## Objetivo

Completar el Sprint 3 por incrementos pequeños, verificables y separados en commits. Cada característica debe tener una prueba antes de pasar a la siguiente.

## Regla de trabajo

- El asistente modifica solo la característica acordada.
- El asistente ejecuta una validación enfocada.
- El usuario revisa el diff y realiza el commit.
- No se inicia la siguiente característica hasta confirmar que el commit anterior quedó creado.
- No se mezclan cambios funcionales, documentación y limpieza no relacionada en un mismo commit.

## Estado inicial

- Rama de trabajo: `develop`.
- Estado Git al iniciar: limpio.
- Jornada disponible: 10:00 a 12:00.
- Referencia de requisitos: [guía Markdown del parcial](../guide/PARCIAL_JAVA_1_CORTE_PRACTICO_V2.md).
- Plan del sprint: [Sprint Planning 3](planning.md).

## Secuencia de características

| Orden | Característica | Prioridad | Estado | Commit sugerido |
|---|---|---|---|---|
| 0 | Registro de ejecución del sprint | P0 | Completada | `docs: iniciar ejecucion sprint 3` |
| 1 | Filtro de servlet y acceso denegado | P0 | Validada por el usuario | `feat: proteger rutas privadas con filtro` |
| 2 | Validaciones de propiedad y baja lógica | P0 | Validada por el usuario | `feat: validar gestion de propiedades` |
| 3 | Validaciones de citas | P0 | Validada por el usuario | `feat: validar agenda de citas` |
| 4 | Validaciones de solicitudes | P0 | Validada por el usuario | `feat: validar solicitudes de clientes` |
| 5 | Documentos con control de pertenencia | P1 | Validada por el usuario | `feat: controlar documentos de solicitudes` |
| 6 | Auditoría y transiciones de estados | P1 | Validada por el usuario | `feat: registrar auditoria` |
| 7 | Reportes y consultas SQL obligatorias | P1 | Validada por el usuario | `feat: agregar reportes administrativos` |
| 8 | Modelo, DDL/DML y restricciones faltantes | P1 | Pendiente | `docs: completar modelo y scripts de datos` |
| 9 | Pruebas, evidencias y cierre Scrum | P1 | Pendiente | `test: documentar regresion del sprint 3` |

## Característica 0: inicio de ejecución

### Alcance

Registrar este documento como bitácora del Sprint 3 y establecer una secuencia de trabajo por característica. No modifica la aplicación ni la base de datos.

### Validación

- Confirmar que el archivo existe.
- Revisar que Git muestre únicamente este archivo como cambio del incremento.
- Revisar el diff antes de confirmar.

### Acción del usuario

Ejecutar desde la raíz del proyecto:

```powershell
git diff --check
git diff -- docs/sprints/sprint3/ejecucion.md
git add docs/sprints/sprint3/ejecucion.md
git commit -m "docs: iniciar ejecucion sprint 3"
git status --short
```

Después de crear el commit, avisar para comenzar la Característica 1.

## Característica 1: filtro de servlet y acceso denegado

Será el siguiente incremento funcional. Se revisará primero el descriptor de despliegue y las dependencias disponibles para proteger las rutas privadas en el servidor, manteniendo la validación de rol existente como respaldo durante la transición.

## Plantilla para cada incremento

### Característica N: nombre

- Alcance:
- Archivos modificados:
- Criterios de aceptación:
- Prueba ejecutada:
- Resultado:
- Commit del usuario:
- Estado:

## Registro de avance

| Característica | Prueba | Resultado | Commit confirmado |
|---|---|---|---|
| 0. Inicio de ejecución | Bitácora validada | Completada | `96244c1` |
| 1. Filtro de servlet | Rutas privadas sin sesión y acceso por rol probado manualmente | Validada por el usuario | `0f1496b` |
| 2. Validaciones de propiedades | Valores negativos e inválidos rechazados; flujo probado manualmente | Validada por el usuario | `7da8f5d` |
| 3. Validaciones de citas | `id_propiedad` válido muestra formulario; inválido o no disponible muestra error | Validada por el usuario | Pendiente de commit |
| 4. Validaciones de solicitudes | Propiedad inválida, tipo inválido y solicitudes activas duplicadas rechazados | Validada por el usuario | Pendiente de commit |
| 5. Carga real de documentos | Archivo multipart válido guardado y registrado; extensión, tamaño y duplicados rechazados | Validada por el usuario | Pendiente de commit |
| 6. Auditoría y transiciones | Cambios auditados, mensajes visibles y regresiones de estado rechazadas | Validada por el usuario | Pendiente de commit |
| 7. Reportes administrativos | Propiedades, citas, solicitudes y propiedades sin citas consultados correctamente | Validada por el usuario | Pendiente de commit |
