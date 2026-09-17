<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%
    String emailIngresado = request.getParameter("email");
    String contrasenaIngresada = request.getParameter("contrasena");
    String contextoApp = request.getContextPath();

    Connection conexionAcceso = null;
    try {
        conexionAcceso = obtenerConexion();

        PreparedStatement psUsuario = conexionAcceso.prepareStatement(
            "SELECT id_usuario, nombre, contrasena, activo FROM usuario WHERE email = ?");
        psUsuario.setString(1, emailIngresado);
        ResultSet rsUsuario = psUsuario.executeQuery();

        if (!rsUsuario.next()) {
            response.sendRedirect(contextoApp + "/login.jsp?error=credenciales");
            return;
        }

        int idUsuarioEncontrado = rsUsuario.getInt("id_usuario");
        String nombreEncontrado = rsUsuario.getString("nombre");
        String hashAlmacenado = rsUsuario.getString("contrasena");
        boolean estaActivo = rsUsuario.getInt("activo") == 1;
        rsUsuario.close(); psUsuario.close();

        if (!estaActivo) {
            response.sendRedirect(contextoApp + "/login.jsp?error=inactivo");
            return;
        }

        if (!verificarContrasena(contrasenaIngresada, hashAlmacenado)) {
            response.sendRedirect(contextoApp + "/login.jsp?error=credenciales");
            return;
        }

        PreparedStatement psRol = conexionAcceso.prepareStatement(
            "SELECT r.nombre FROM usuario_rol ur JOIN rol r ON ur.id_rol = r.id_rol WHERE ur.id_usuario = ?");
        psRol.setInt(1, idUsuarioEncontrado);
        ResultSet rsRol = psRol.executeQuery();

        String rolPrincipal = "CLIENTE";
        java.util.List<String> rolesDelUsuario = new java.util.ArrayList<>();
        while (rsRol.next()) {
            rolesDelUsuario.add(rsRol.getString("nombre").toUpperCase());
        }
        rsRol.close(); psRol.close();

        if (rolesDelUsuario.contains("ADMINISTRADOR")) {
            rolPrincipal = "ADMINISTRADOR";
        } else if (rolesDelUsuario.contains("INMOBILIARIA")) {
            rolPrincipal = "INMOBILIARIA";
        } else if (rolesDelUsuario.contains("CLIENTE")) {
            rolPrincipal = "CLIENTE";
        }

        HttpSession nuevaSesion = request.getSession(true);
        nuevaSesion.setAttribute("idUsuario", idUsuarioEncontrado);
        nuevaSesion.setAttribute("nombreUsuario", nombreEncontrado);
        nuevaSesion.setAttribute("rolUsuario", rolPrincipal);

        if ("ADMINISTRADOR".equalsIgnoreCase(rolPrincipal)) {
            response.sendRedirect(contextoApp + "/admin/inicio.jsp");
        } else if ("INMOBILIARIA".equalsIgnoreCase(rolPrincipal)) {
            response.sendRedirect(contextoApp + "/inmobiliaria/inicio.jsp");
        } else {
            response.sendRedirect(contextoApp + "/cliente/inicio.jsp");
        }

    } catch (Exception exAcceso) {
        response.sendRedirect(contextoApp + "/login.jsp?error=general");
    } finally {
        if (conexionAcceso != null) { try { conexionAcceso.close(); } catch (Exception ig) {} }
    }
%>
