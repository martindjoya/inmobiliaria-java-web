# Documentación — Preparación del entorno de desarrollo

## 1. Objetivo

Preparar y verificar el entorno local necesario para el desarrollo de la aplicación web **Dream House S.A.**, utilizando las herramientas definidas para el proyecto.

El objetivo de esta etapa fue comprobar que los componentes principales se encuentran instalados y que los servicios necesarios pueden ejecutarse localmente antes de integrar el código del proyecto.

---

## 2. Entorno del equipo

### Sistema operativo

* Windows Home 64 bits.
* XAMPP instalado en:

```text
C:\xampp\
```

### Editor de código

**Visual Studio Code**

Versión:

```text
1.137.0
```

Arquitectura:

```text
x64
```

---

## 3. Java / JDK

Se verificó la instalación del JDK mediante:

```powershell
java -version
javac -version
```

Resultados:

```text
openjdk version "25.0.2" 2026-01-20
javac 25.0.2
```

Por lo tanto, el sistema tiene disponible:

```text
JDK: OpenJDK 25.0.2
```

La ubicación encontrada mediante `where.exe` fue:

```text
C:\Program Files\Java\jdk-25.0.2\bin\java.exe
C:\Program Files\Java\jdk-25.0.2\bin\javac.exe
```

### Observación

Se detectó que la variable de entorno `JAVA_HOME` apunta actualmente a:

```text
C:\Users\Martinus\AppData\Local\Programs\Eclipse Adoptium\jdk-25.0.4.101-hotspot\
```

Esta ruta no existe actualmente.

Sin embargo, el comando `java` funciona correctamente mediante el `PATH`, utilizando JDK 25.0.2.

**Estado:** ⚠️ Pendiente de revisar posteriormente.

No se modificó la configuración para evitar introducir cambios innecesarios antes de conocer la configuración requerida por el proyecto.

---

# 4. Git

Se verificó Git mediante:

```powershell
git --version
```

Resultado:

```text
git version 2.54.0.windows.1
```

También se verificó la configuración global:

```text
user.name  → martindjoya
user.email → martindjoya@outlook.com
```

**Estado:** ✅ Funcionando.

---

# 5. XAMPP

Se verificó el panel de XAMPP.

Versión:

```text
XAMPP 8.2.12
```

Directorio:

```text
C:\xampp\
```

El panel indicó que los prerrequisitos estaban disponibles:

```text
All prerequisites found
```

Los siguientes componentes se encontraban ejecutándose:

```text
Apache
Tomcat
```

Además, MariaDB se encontraba disponible mediante la instalación de base de datos incluida con XAMPP.

**Estado:** ✅ Funcionando.

---

# 6. Apache

Se verificó la versión mediante:

```powershell
C:\xampp\apache\bin\httpd.exe -v
```

Resultado:

```text
Server version: Apache/2.4.58 (Win64)
Apache Lounge VS17 Server
```

El servicio estaba ejecutándose en:

```text
Puerto HTTP: 80
Puerto HTTPS: 443
```

**Estado:** ✅ Funcionando.

> Apache HTTP Server y Apache Tomcat se mantienen diferenciados. Para las páginas JSP del proyecto, Tomcat será el componente relevante.

---

# 7. Base de datos

Durante la revisión se encontraron **dos instalaciones de servidores de bases de datos**.

### MySQL instalado independientemente

Ubicación:

```text
C:\Program Files\MySQL\MySQL Server 8.0\
```

Versión:

```text
MySQL Community Server 8.0.44
```

Verificado mediante:

```powershell
mysql --version
```

### MariaDB incluido en XAMPP

Ubicación:

```text
C:\xampp\mysql\
```

Versión:

```text
MariaDB 10.4.32
```

Verificado mediante:

```powershell
C:\xampp\mysql\bin\mysql.exe --version
```

---

## 8. Puerto de la base de datos

Se verificó mediante:

```powershell
netstat -ano | findstr :3307
```

Resultado:

```text
TCP    0.0.0.0:3307    ...    LISTENING    6356
TCP    [::]:3307       ...    LISTENING    6356
```

El proceso correspondiente al PID `6356` fue identificado como:

```text
mysqld.exe
```

También se comprobó que no había un proceso escuchando en el puerto `3306`.

Por lo tanto, el servidor activo utilizado durante la prueba responde mediante:

```text
Host: localhost
Puerto: 3307
```

---

# 9. Prueba de conexión con MariaDB

Se realizó una conexión real mediante:

```powershell
C:\xampp\mysql\bin\mysql.exe -u root -P 3307
```

La conexión fue exitosa y el servidor respondió:

```text
Server version: 10.4.32-MariaDB
```

Posteriormente se salió correctamente mediante:

```sql
exit
```

### Resultado

**Conexión local con MariaDB comprobada exitosamente.** ✅

Este dato será especialmente importante posteriormente para la configuración de JDBC.

---

# 10. Apache Tomcat

Se comprobó la instalación ubicada en:

```text
C:\xampp\tomcat\
```

La estructura contiene, entre otros:

```text
bin\
conf\
lib\
logs\
temp\
webapps\
work\
```

La documentación incluida en la instalación identifica el servidor como:

```text
Apache Tomcat 8.5 Servlet/JSP Container
```

Por lo tanto:

```text
Tomcat: 8.5.x
```

El panel de XAMPP indicó que Tomcat estaba ejecutándose en:

```text
Puerto: 8080
```

---

# 11. Prueba funcional de Tomcat

Se accedió desde el navegador a:

```text
http://localhost:8080
```

Se obtuvo correctamente la **página de bienvenida de Apache Tomcat**.

### Resultado

**Tomcat está funcionando localmente y acepta conexiones HTTP en el puerto 8080.** ✅

---

# 12. Incidencia con `CATALINA_HOME`

Al ejecutar:

```powershell
C:\xampp\tomcat\bin\version.bat
```

se obtuvo:

```text
The CATALINA_HOME environment variable is not defined correctly
This environment variable is needed to run this program
```

Posteriormente se comprobó:

```powershell
echo $env:CATALINA_HOME
```

sin obtener un valor configurado.

Sin embargo, esto **no impidió que Tomcat funcionara mediante XAMPP**, ya que:

* `tomcat8.exe` estaba ejecutándose.
* XAMPP indicaba Tomcat como activo.
* `http://localhost:8080` mostraba correctamente la página de Tomcat.

**Estado:** ⚠️ Pendiente de configuración/revisión.

No se modificó la variable durante esta etapa.

---

# 13. Resumen de verificación

| Elemento             | Versión / configuración | Resultado |
| -------------------- | ----------------------- | --------- |
| Windows              | Home 64 bits            | ✅         |
| VS Code              | 1.137.0 x64             | ✅         |
| JDK                  | OpenJDK 25.0.2          | ✅         |
| `javac`              | 25.0.2                  | ✅         |
| Git                  | 2.54.0                  | ✅         |
| XAMPP                | 8.2.12                  | ✅         |
| Apache               | 2.4.58                  | ✅         |
| MariaDB XAMPP        | 10.4.32                 | ✅         |
| MariaDB activo       | Puerto 3307             | ✅         |
| Conexión BD          | `localhost:3307`        | ✅         |
| Tomcat               | 8.5.x                   | ✅         |
| Tomcat HTTP          | Puerto 8080             | ✅         |
| Página de Tomcat     | `localhost:8080`        | ✅         |
| `JAVA_HOME`          | Ruta inexistente        | ⚠️        |
| `CATALINA_HOME`      | No configurada          | ⚠️        |
| Proyecto Dream House | Aún no integrado        | ⏳         |

---

# 14. Pendientes

Antes de comenzar el desarrollo propiamente dicho quedan por verificar:

1. **Recibir la carpeta/proyecto entregado por la compañera.**
2. Revisar su estructura de carpetas.
3. Identificar la versión de Java/Tomcat que utiliza el proyecto.
4. Revisar las librerías `.jar`, especialmente el conector JDBC.
5. Revisar la configuración de conexión a la base de datos.
6. Ejecutar el proyecto **sin modificarlo inicialmente**.
7. Comparar la estructura implementada con los requisitos del proyecto.
8. Determinar si `JAVA_HOME` y/o `CATALINA_HOME` necesitan ser corregidas.

---

## Registro de estado

**Fecha:** 15 de septiembre de 2026
**Etapa:** Preparación/verificación del entorno
**Resultado:** **Entorno base funcional**

La conclusión técnica por ahora sería:

> **El equipo cuenta con un entorno funcional para comenzar las pruebas del proyecto Java/JSP: JDK, Git, VS Code, XAMPP, Apache, MariaDB y Tomcat están instalados; además, se comprobó funcionalmente la conexión con MariaDB en el puerto 3307 y el acceso a Tomcat mediante el puerto 8080. Se identificaron configuraciones pendientes relacionadas con `JAVA_HOME` y `CATALINA_HOME`, las cuales no impiden actualmente la ejecución de los servicios.**