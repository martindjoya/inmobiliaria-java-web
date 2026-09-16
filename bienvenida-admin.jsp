<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("idUsuario") == null || !"Administrador".equals(session.getAttribute("rolUsuario"))) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel Administrador - Dream House S.A.</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <section class="seccion-registro py-5">
        <div class="container text-center">
            <h2 class="titulo-seccion mb-3">Hola, <%= session.getAttribute("nombreUsuario") %></h2>
            <p class="subtitulo-registro mb-4">Panel de administración de Dream House S.A.</p>
            <a href="index.jsp" class="btn-explorar me-2">Ir al inicio</a>
            <a href="logout.jsp" class="btn-explorar">Cerrar sesión</a>
        </div>
    </section>
</body>
</html>