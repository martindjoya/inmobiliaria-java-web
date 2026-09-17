<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "ADMINISTRADOR";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%
    String mensajeErrorEdit = null;
    Integer idUsuarioEditar = null;
    try {
        idUsuarioEditar = Integer.parseInt(request.getParameter("id"));
    } catch (Exception ex) {
        idUsuarioEditar = null;
    }

    if (idUsuarioEditar == null) {
        response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String nombreEdit = request.getParameter("nombre");
        String contrasenaEdit = request.getParameter("contrasena"); // puede venir vacía
        String idRolEdit = request.getParameter("id_rol");

        if (nombreEdit == null || nombreEdit.trim().isEmpty() || idRolEdit == null || idRolEdit.isEmpty()) {
            mensajeErrorEdit = "El nombre y el rol son obligatorios.";
        } else {
            Connection conEditar = null;
            try {
                conEditar = obtenerConexion();
                conEditar.setAutoCommit(false);

                if (contrasenaEdit != null && !contrasenaEdit.trim().isEmpty()) {
                    if (contrasenaEdit.length() < 6) {
                        throw new IllegalArgumentException("La nueva contraseña debe tener mínimo 6 caracteres.");
                    }
                    PreparedStatement psActualizarConPass = conEditar.prepareStatement(
                        "UPDATE usuario SET nombre = ?, contrasena = ? WHERE id_usuario = ?");
                    psActualizarConPass.setString(1, nombreEdit.trim());
                    psActualizarConPass.setString(2, generarHashContrasena(contrasenaEdit));
                    psActualizarConPass.setInt(3, idUsuarioEditar);
                    psActualizarConPass.executeUpdate();
                    psActualizarConPass.close();
                } else {
                    PreparedStatement psActualizarSinPass = conEditar.prepareStatement(
                        "UPDATE usuario SET nombre = ? WHERE id_usuario = ?");
                    psActualizarSinPass.setString(1, nombreEdit.trim());
                    psActualizarSinPass.setInt(2, idUsuarioEditar);
                    psActualizarSinPass.executeUpdate();
                    psActualizarSinPass.close();
                }

                PreparedStatement psBorrarRoles = conEditar.prepareStatement(
                    "DELETE FROM usuario_rol WHERE id_usuario = ?");
                psBorrarRoles.setInt(1, idUsuarioEditar);
                psBorrarRoles.executeUpdate();
                psBorrarRoles.close();

                PreparedStatement psNuevoRol = conEditar.prepareStatement(
                    "INSERT INTO usuario_rol (id_usuario, id_rol) VALUES (?, ?)");
                psNuevoRol.setInt(1, idUsuarioEditar);
                psNuevoRol.setInt(2, Integer.parseInt(idRolEdit));
                psNuevoRol.executeUpdate();
                psNuevoRol.close();

                conEditar.commit();
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
                return;

            } catch (IllegalArgumentException exValidacion) {
                try { if (conEditar != null) conEditar.rollback(); } catch (Exception ig) {}
                mensajeErrorEdit = exValidacion.getMessage();
            } catch (Exception exEditar) {
                try { if (conEditar != null) conEditar.rollback(); } catch (Exception ig) {}
                mensajeErrorEdit = "Ocurrió un problema al actualizar el usuario.";
            } finally {
                if (conEditar != null) {
                    try { conEditar.setAutoCommit(true); conEditar.close(); } catch (Exception ig) {}
                }
            }
        }
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Editar usuario</h2>
<%
    if (mensajeErrorEdit != null) {
%>
    <div class="alerta-error"><%= mensajeErrorEdit %></div>
<%
    }

    Connection conCargar = null;
    try {
        conCargar = obtenerConexion();
        PreparedStatement psCargar = conCargar.prepareStatement(
            "SELECT nombre, email FROM usuario WHERE id_usuario = ?");
        psCargar.setInt(1, idUsuarioEditar);
        ResultSet rsCargar = psCargar.executeQuery();
        if (rsCargar.next()) {
            String nombreActual = rsCargar.getString("nombre");
            String emailActual = rsCargar.getString("email");
            rsCargar.close(); psCargar.close();

            PreparedStatement psRolActual = conCargar.prepareStatement(
                "SELECT id_rol FROM usuario_rol WHERE id_usuario = ? LIMIT 1");
            psRolActual.setInt(1, idUsuarioEditar);
            ResultSet rsRolActual = psRolActual.executeQuery();
            int idRolActual = rsRolActual.next() ? rsRolActual.getInt("id_rol") : -1;
            rsRolActual.close(); psRolActual.close();
%>
    <form method="post" action="<%= request.getContextPath() %>/admin/editar-usuario.jsp?id=<%= idUsuarioEditar %>" class="card-registro">
        <div class="mb-3">
            <label class="form-label">Correo (no editable)</label>
            <input type="email" class="form-control" value="<%= emailActual %>" disabled>
        </div>
        <div class="mb-3">
            <label class="form-label">Nombre completo</label>
            <input type="text" name="nombre" class="form-control" value="<%= nombreActual %>" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Nueva contraseña (dejar vacío para no cambiarla)</label>
            <input type="password" name="contrasena" class="form-control" minlength="6">
        </div>
        <div class="mb-3">
            <label class="form-label">Rol</label>
            <select name="id_rol" class="form-select" required>
<%
            PreparedStatement psTodosRoles = conCargar.prepareStatement("SELECT id_rol, nombre FROM rol ORDER BY nombre");
            ResultSet rsTodosRoles = psTodosRoles.executeQuery();
            while (rsTodosRoles.next()) {
                int idRolFila = rsTodosRoles.getInt("id_rol");
                String selRol = (idRolFila == idRolActual) ? "selected" : "";
%>
                <option value="<%= idRolFila %>" <%= selRol %>><%= rsTodosRoles.getString("nombre") %></option>
<%
            }
            rsTodosRoles.close(); psTodosRoles.close();
%>
            </select>
        </div>
        <button type="submit" class="btn-explorar w-100">Guardar cambios</button>
    </form>
<%
        } else {
            rsCargar.close(); psCargar.close();
%>
    <p class="text-danger">Usuario no encontrado.</p>
<%
        }
    } catch (Exception exCargar) {
%>
    <p class="text-danger">Ocurrió un problema al cargar el usuario.</p>
<%
    } finally {
        if (conCargar != null) { try { conCargar.close(); } catch (Exception ig) {} }
    }
%>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>