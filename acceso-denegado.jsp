<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso denegado | Dream House S.A.</title>
    <link href="<%= request.getContextPath() %>/css/estilos.css" rel="stylesheet">
</head>
<body>
    <main class="container py-5">
        <h1>Acceso denegado</h1>
        <p>No tienes una sesión activa o tu rol no permite acceder a esta sección.</p>
        <a href="<%= request.getContextPath() %>/login.jsp" class="btn-explorar">Ir al inicio de sesión</a>
    </main>
</body>
</html>