
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "CLIENTE";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%
    int idUsuarioPerfil = (Integer) session.getAttribute("idUsuario");
    String mensajeErrorPerfil = null;
    String mensajeOkPerfil = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String telefonoPerfil = request.getParameter("telefono");
        String direccionPerfil = request.getParameter("direccion");
        String fotoUrlPerfil = request.getParameter("foto_url");

        Connection conGuardarPerfil = null;
        try {
            conGuardarPerfil = obtenerConexion();
            PreparedStatement psGuardarPerfil = conGuardarPerfil.prepareStatement(
                "INSERT INTO perfil (id_usuario, telefono, direccion, foto_url) VALUES (?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE telefono = VALUES(telefono), direccion = VALUES(direccion), foto_url = VALUES(foto_url)");
            psGuardarPerfil.setInt(1, idUsuarioPerfil);
            psGuardarPerfil.setString(2, telefonoPerfil);
            psGuardarPerfil.setString(3, direccionPerfil);
            psGuardarPerfil.setString(4, fotoUrlPerfil);
            psGuardarPerfil.executeUpdate();
            psGuardarPerfil.close();
            mensajeOkPerfil = "Perfil actualizado correctamente.";
        } catch (Exception exGuardarPerfil) {
            mensajeErrorPerfil = "Ocurrió un problema al guardar tu perfil.";
        } finally {
            if (conGuardarPerfil != null) { try { conGuardarPerfil.close(); } catch (Exception ig) {} }
        }
    }

    String telefonoActual = "", direccionActual = "", fotoUrlActual = "";
    Connection conCargarPerfil = null;
    try {
        conCargarPerfil = obtenerConexion();
        PreparedStatement psCargarPerfil = conCargarPerfil.prepareStatement(
            "SELECT telefono, direccion, foto_url FROM perfil WHERE id_usuario = ?");
        psCargarPerfil.setInt(1, idUsuarioPerfil);
        ResultSet rsCargarPerfil = psCargarPerfil.executeQuery();
        if (rsCargarPerfil.next()) {
            telefonoActual = rsCargarPerfil.getString("telefono");
            direccionActual = rsCargarPerfil.getString("direccion");
            fotoUrlActual = rsCargarPerfil.getString("foto_url");
            if (telefonoActual == null) telefonoActual = "";
            if (direccionActual == null) direccionActual = "";
            if (fotoUrlActual == null) fotoUrlActual = "";
        }
        rsCargarPerfil.close(); psCargarPerfil.close();
    } catch (Exception exCargarPerfil) {
    } finally {
        if (conCargarPerfil != null) { try { conCargarPerfil.close(); } catch (Exception ig) {} }
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Mi perfil</h2>
<%
    if (mensajeErrorPerfil != null) {
%>
    <div class="alerta-error"><%= mensajeErrorPerfil %></div>
<%
    }
    if (mensajeOkPerfil != null) {
%>
    <div class="alert alert-success"><%= mensajeOkPerfil %></div>
<%
    }
%>
    <form method="post" action="<%= request.getContextPath() %>/cliente/perfil.jsp" class="card-registro">
        <div class="mb-3">
            <label class="form-label">Nombre (no editable aquí)</label>
            <input type="text" class="form-control" value="<%= session.getAttribute("nombreUsuario") %>" disabled>
        </div>
        <div class="mb-3">
            <label class="form-label">Teléfono</label>
            <input type="text" name="telefono" class="form-control" value="<%= telefonoActual %>">
        </div>
        <div class="mb-3">
            <label class="form-label">Dirección</label>
            <input type="text" name="direccion" class="form-control" value="<%= direccionActual %>">
        </div>
        <div class="mb-3">
            <label class="form-label">URL de foto</label>
            <input type="text" name="foto_url" class="form-control" value="<%= fotoUrlActual %>">
        </div>
        <button type="submit" class="btn-explorar w-100">Guardar cambios</button>
    </form>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>