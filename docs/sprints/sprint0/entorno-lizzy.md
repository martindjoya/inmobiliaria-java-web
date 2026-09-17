# Inventario del entorno de desarrollo - Lizzy

> Plantilla para registrar la configuracion local utilizada por Lizzy al ejecutar Dream House S.A.
>
> Completar los campos entre corchetes y conservar los resultados reales de las pruebas. No modificar el codigo de la aplicacion desde este documento.

## 1. Datos del entorno

- Nombre: Lizzy
- Fecha del inventario: [AAAA-MM-DD]
- Sistema operativo: [Windows / otro]
- Arquitectura: [x64 / x86]
- Usuario del equipo: [usuario]
- Ruta del proyecto: `[ruta completa]`
- Observaciones: [diferencias relevantes]

## 2. Editor y herramientas

### Visual Studio Code

- Version: `[version]`
- Arquitectura: `[x64 / x86]`
- Extensiones relevantes: [Java, JSP, Git, otras]

### Git

Comandos ejecutados:

```powershell
git --version
git config --get user.name
git config --get user.email
```

Resultados:

```text
[pegar resultados]
```

## 3. Java

Comandos ejecutados:

```powershell
java -version
javac -version
where.exe java
where.exe javac
```

Resultados:

```text
[pegar resultados]
```

- JDK utilizado: `[version]`
- `JAVA_HOME`: `[ruta o no configurado]`
- `PATH` contiene el JDK correcto: `[si / no]`
- Observaciones: [compatibilidad o problemas encontrados]

## 4. XAMPP, Apache y Tomcat

- Version de XAMPP: `[version]`
- Ruta de XAMPP: `[ruta]`
- Apache activo: `[si / no]`
- Puerto Apache HTTP: `[puerto]`
- Tomcat activo: `[si / no]`
- Puerto Tomcat: `[puerto]`
- Ruta de Tomcat: `[ruta]`
- Contexto de la aplicacion: `[nombre del contexto]`

Comandos de comprobacion:

```powershell
Get-Service | Where-Object { $_.Name -match 'apache|mysql|maria|tomcat' }
Get-NetTCPConnection -State Listen | Where-Object { $_.LocalPort -in [puerto-tomcat],3306,3307 }
```

Resultados:

```text
[pegar resultados]
```

## 5. Servidor de base de datos

- Motor: `[MySQL / MariaDB]`
- Version: `[version]`
- Ejecutable utilizado: `[ruta al mysql.exe]`
- Servicio: `[nombre]`
- Estado del servicio: `[Running / Stopped]`
- Base de datos: `dream_house`
- Host: `[localhost / 127.0.0.1]`
- Puerto activo: `[3306 / 3307 / otro]`
- Usuario: `[usuario]`
- Contraseña: `[configurada / vacia / no registrar aqui]`

Comandos de comprobacion:

```powershell
mysql --version
Get-NetTCPConnection -State Listen | Where-Object { $_.LocalPort -in 3306,3307 }
mysql --host=[host] --port=[puerto] --user=[usuario] -e "SELECT @@port; SHOW DATABASES LIKE 'dream_house';"
```

Resultado de conexion:

```text
[pegar resultado sin incluir contraseñas]
```

## 6. Comparacion de configuraciones JSP y Java

Registrar por separado cada configuracion encontrada. Esto permite distinguir el entorno de Lizzy de otras configuraciones del equipo.

### Configuracion A: JSP

Archivo revisado: `WEB-INF/jspf/conexion.jspf`

```text
URL JDBC: [jdbc:mysql://...]
Host: [host]
Puerto: [puerto]
Base de datos: [nombre]
Usuario: [usuario]
Contraseña: [configurada / vacia / no registrar]
Parámetros JDBC: [useSSL, serverTimezone, allowPublicKeyRetrieval, etc.]
```

### Configuracion B: Java

Archivo revisado: `src/conexion/ConexionBD.java`

```text
URL principal: [jdbc:mysql://...]
URL alternativa: [jdbc:mysql://...]
Puertos configurados: [lista]
Contraseñas probadas por la aplicacion: [vacia / configurada / no registrar]
Clase del driver: [com.mysql.cj.jdbc.Driver]
```

### Diferencias identificadas

- Puerto usado por la JSP: `[3306 / 3307 / otro]`
- Puerto principal usado por Java: `[3306 / 3307 / otro]`
- Puerto alternativo usado por Java: `[3306 / 3307 / otro / ninguno]`
- Diferencia de usuario: `[si / no]`
- Diferencia de contraseña: `[si / no]`
- Diferencia de parámetros JDBC: `[si / no]`
- Accion recomendada: [alinear configuraciones / conservar fallback / documentar diferencia]

## 7. Librerias y clases desplegadas

Revisar el contenido de `WEB-INF/lib` y `WEB-INF/classes`.

- `WEB-INF/lib/mysql-connector-*.jar`: `[nombre y version]`
- `WEB-INF/lib/jbcrypt-*.jar`: `[nombre y version]`
- `WEB-INF/classes/conexion/ConexionBD.class`: `[presente / ausente]`
- Otras librerias: `[lista]`
- Fecha de compilacion de las clases: `[fecha]`

Comando sugerido:

```powershell
Get-ChildItem .\WEB-INF\lib
Get-ChildItem .\WEB-INF\classes -Recurse
```

## 8. Base de datos e inventario minimo

Confirmar que existan las tablas necesarias:

```text
[usuario]
[rol]
[usuario_rol]
[perfil]
[inmobiliaria]
[ciudad]
[tipo_propiedad]
[propiedad]
[imagen_propiedad]
[caracteristica]
[propiedad_caracteristica]
[cita]
[solicitud]
[documento_solicitud]
[favorito]
[auditoria]
```

Cantidad aproximada de registros, si se desea documentar:

```text
usuarios: [cantidad]
roles: [cantidad]
propiedades: [cantidad]
ciudades: [cantidad]
```

## 9. Pruebas del entorno

Registrar fecha, URL, resultado y observaciones. No marcar una prueba como exitosa si no se ejecuto.

| Prueba | URL o comando | Resultado | Observaciones |
|---|---|---|---|
| Conexion JDBC | `test-conexion.jsp` | [pendiente / OK / error] | [detalle] |
| Portada | `/index.jsp` | [pendiente / OK / error] | [detalle] |
| Login | `/login.jsp` | [pendiente / OK / error] | [detalle] |
| Registro | `/registro.jsp` | [pendiente / OK / error] | [detalle] |
| Propiedades | `/propiedades.jsp` | [pendiente / OK / error] | [detalle] |
| Cierre de sesion | `/logout.jsp` | [pendiente / OK / error] | [detalle] |

## 10. Problemas encontrados

1. [Problema]
   - Evidencia: [log, comando o pantalla]
   - Impacto: [descripcion]
   - Solucion aplicada: [descripcion]
   - Estado: [pendiente / resuelto]

2. [Problema]
   - Evidencia: [log, comando o pantalla]
   - Impacto: [descripcion]
   - Solucion aplicada: [descripcion]
   - Estado: [pendiente / resuelto]

## 11. Resumen y recomendaciones

- Estado general del entorno: `[listo / requiere ajustes]`
- Configuracion recomendada para este equipo: `[resumen de host, puerto, usuario y contexto]`
- Diferencias que deben comunicarse al equipo: `[lista]`
- Acciones pendientes: `[lista]`
- Responsable de completar este inventario: `Lizzy`
- Fecha de cierre: `[AAAA-MM-DD]`
