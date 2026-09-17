# Modelo de datos de Dream House S.A.

## Alcance

Este documento describe el modelo relacional implementado en `database/dream_house.sql` y las relaciones que deben explicarse durante la sustentacion.

## Relaciones principales

### Relacion 1:1

- `usuario` -> `perfil`.
- Se implementa con `perfil.id_usuario` como llave foranea y restriccion `UNIQUE`.
- Un usuario puede tener como maximo un perfil.

Tambien existe una relacion 1:1 entre `usuario` e `inmobiliaria` mediante `inmobiliaria.id_usuario UNIQUE`.

### Relacion 1:N

- `inmobiliaria` -> `propiedad` mediante `propiedad.id_inmobiliaria`.
- `propiedad` -> `imagen_propiedad` mediante `imagen_propiedad.id_propiedad`.
- `usuario` -> `cita` mediante `cita.id_usuario`.
- `usuario` -> `solicitud` mediante `solicitud.id_usuario`.
- `solicitud` -> `documento_solicitud` mediante `documento_solicitud.id_solicitud`.

La llave foranea se ubica en la tabla del lado muchos. Las relaciones que dependen de su entidad padre usan `ON DELETE CASCADE` cuando la eliminacion de los hijos es segura para la integridad del negocio.

### Relacion N:M

- `usuario` <-> `rol` mediante `usuario_rol`.
- `propiedad` <-> `caracteristica` mediante `propiedad_caracteristica`.

Las tablas intermedias usan llaves primarias compuestas para impedir duplicar la misma asociacion.

## Restricciones UNIQUE

- `usuario.email` identifica de forma unica la credencial.
- `rol.nombre` evita roles repetidos.
- `perfil.id_usuario` garantiza la relacion 1:1.
- `inmobiliaria.id_usuario` garantiza una agencia por usuario.
- `tipo_propiedad.nombre` y `caracteristica.nombre` evitan duplicados de catalogo.
- `propiedad.matricula_inmobiliaria` identifica un inmueble sin duplicados.
- `favorito(id_usuario, id_propiedad)` evita repetir favoritos.
- `usuario_rol(id_usuario, id_rol)` y `propiedad_caracteristica(id_propiedad, id_caracteristica)` evitan repetir asociaciones.

## Entidades y proposito

| Tabla | Proposito | Llave primaria | Relaciones o restricciones destacadas |
|---|---|---|---|
| `rol` | Catalogo de permisos | `id_rol` | `nombre UNIQUE` |
| `usuario` | Credenciales y estado | `id_usuario` | `email UNIQUE` |
| `usuario_rol` | Asignacion de roles | `(id_usuario, id_rol)` | N:M |
| `perfil` | Datos personales | `id_perfil` | `id_usuario UNIQUE`, 1:1 |
| `inmobiliaria` | Datos de agencia | `id_inmobiliaria` | `id_usuario UNIQUE` |
| `ciudad` | Catalogo geografico | `id_ciudad` | Referenciada por propiedades |
| `tipo_propiedad` | Catalogo de tipos | `id_tipo` | `nombre UNIQUE` |
| `propiedad` | Inmuebles publicados | `id_propiedad` | Matricula `UNIQUE`, FKs a ciudad, tipo y agencia |
| `imagen_propiedad` | Imagenes del inmueble | `id_imagen` | FK a propiedad, borrado en cascada |
| `caracteristica` | Servicios o atributos | `id_caracteristica` | `nombre UNIQUE` |
| `propiedad_caracteristica` | Atributos por inmueble | `(id_propiedad, id_caracteristica)` | N:M |
| `cita` | Visitas agendadas | `id_cita` | FKs a propiedad y usuario |
| `solicitud` | Tramites de compra/arriendo | `id_solicitud` | FKs a propiedad y usuario |
| `documento_solicitud` | Archivos de una solicitud | `id_documento` | FK a solicitud, borrado en cascada |
| `favorito` | Propiedades guardadas | `id_favorito` | `(id_usuario, id_propiedad) UNIQUE` |
| `auditoria` | Trazabilidad de acciones | `id_auditoria` | FK opcional a usuario, `ON DELETE SET NULL` |

## Integridad de negocio

- Las propiedades nuevas reciben una matricula obligatoria y unica.
- Una solicitud solo puede crearse para una propiedad disponible.
- Una cita solo puede crearse para una propiedad disponible y con fecha futura.
- Las transiciones de citas y solicitudes se controlan en servidor.
- Los documentos se almacenan fuera del acceso publico y se validan por pertenencia de la solicitud.
