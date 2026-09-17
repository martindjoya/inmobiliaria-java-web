<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "ADMINISTRADOR";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%
    // Procesa el toggle de activo/inactivo si viene por POST
    String accionUsuarios = request.getParameter("accion");
    if ("toggle".equals(accionUsuarios) && "POST".equalsIgnoreCase(request.getMethod())) {
        String idParaToggle = request.getParameter("id_usuario");
        Connection conToggle = null;
        try {
            conToggle = obtenerConexion();
            PreparedStatement psToggle = conToggle.prepareStatement(
                "UPDATE usuario SET activo = NOT activo WHERE id_usuario = ?");
            psToggle.setInt(1, Integer.parseInt(idParaToggle));
            psToggle.executeUpdate();
            psToggle.close();
        } catch (Exception exToggle) {
            // si falla, simplemente seguimos y mostramos la lista igual
        } finally {
            if (conToggle != null) { try { conToggle.close(); } catch (Exception ig) {} }
        }
        response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
        return;
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Gestión de usuarios</h2>
    <a href="<%= request.getContextPath() %>/admin/guardar-usuario.jsp" class="btn-explorar mb-3 d-inline-block">+ Nuevo usuario</a>

    <table class="table table-bordered bg-white">
        <thead>
            <tr>
                <th>Nombre</th>
                <th>Email</th>
                <th>Roles</th>
                <th>Estado</th>
                <th>Registrado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conexionUsuarios = null;
    try {
        conexionUsuarios = obtenerConexion();
        String sqlUsuarios =
            "SELECT u.id_usuario, u.nombre, u.email, u.activo, u.fecha_registro, " +
            "GROUP_CONCAT(r.nombre SEPARATOR ', ') AS roles " +
            "FROM usuario u " +
            "LEFT JOIN usuario_rol ur ON u.id_usuario = ur.id_usuario " +
            "LEFT JOIN rol r ON ur.id_rol = r.id_rol " +
            "GROUP BY u.id_usuario, u.nombre, u.email, u.activo, u.fecha_registro " +
            "ORDER BY u.fecha_registro DESC";
        PreparedStatement psUsuarios = conexionUsuarios.prepareStatement(sqlUsuarios);
        ResultSet rsUsuarios = psUsuarios.executeQuery();
        while (rsUsuarios.next()) {
            boolean activoUsuario = rsUsuarios.getInt("activo") == 1;
            String rolesTexto = rsUsuarios.getString("roles");
            if (rolesTexto == null) rolesTexto = "(sin rol)";
%>
            <tr>
                <td><%= rsUsuarios.getString("nombre") %></td>
                <td><%= rsUsuarios.getString("email") %></td>
                <td><%= rolesTexto %></td>
                <td><%= activoUsuario ? "Activo" : "Inactivo" %></td>
                <td><%= rsUsuarios.getTimestamp("fecha_registro") %></td>
                <td>
                    <a href="<%= request.getContextPath() %>/admin/editar-usuario.jsp?id=<%= rsUsuarios.getInt("id_usuario") %>" class="btn-detalles">Editar</a>
                    <form method="post" action="<%= request.getContextPath() %>/admin/usuarios.jsp" class="d-inline">
                        <input type="hidden" name="accion" value="toggle">
                        <input type="hidden" name="id_usuario" value="<%= rsUsuarios.getInt("id_usuario") %>">
                        <button type="submit" class="btn-detalles"><%= activoUsuario ? "Desactivar" : "Activar" %></button>
                    </form>
                </td>
            </tr>
<%
        }
        rsUsuarios.close(); psUsuarios.close();
    } catch (Exception exUsuarios) {
%>
            <tr><td colspan="6" class="text-danger">Ocurrió un problema al consultar los usuarios.</td></tr>
<%
    } finally {
        if (conexionUsuarios != null) { try { conexionUsuarios.close(); } catch (Exception ig) {} }
    }
%>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>