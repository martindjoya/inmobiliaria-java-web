<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="conexion.ConexionBD" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Prueba de conexión - Dream House S.A.</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body style="padding:2rem; font-family:sans-serif;">
<%
    Connection con = null;
    try {
        con = ConexionBD.obtenerConexion();
%>
        <h2 style="color:green;">Conexión exitosa con la base de datos Dream House S.A.</h2>
<%
    } catch (SQLException e) {
%>
        <h2 style="color:red;">Error al conectar con la base de datos</h2>
        <p><%= e.getMessage() %></p>
<%
    } finally {
        if (con != null) {
            try { con.close(); } catch (SQLException ex) { }
        }
    }
%>
</body>
</html>