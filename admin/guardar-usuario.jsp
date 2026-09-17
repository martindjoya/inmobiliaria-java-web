<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "ADMINISTRADOR";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%
    String mensajeError = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String nombreNvo = request.getParameter("nombre");
        String emailNvo = request.getParameter("email");
        String contrasenaNva = request.getParameter("contrasena");
        String idRolSeleccionado = request.getParameter("id_rol");

        if (nombreNvo == null || nombreNvo.trim().isEmpty()
            || emailNvo == null || !esCorreoValido(emailNvo)
            || contrasenaNva == null || contrasenaNva.length() < 6
            || idRolSeleccionado == null || idRolSeleccionado.isEmpty()) {
            mensajeError = "Completa todos los campos correctamente (contraseña mínimo 6 caracteres).";
        } else {
            Connection conGuardar = null;
            try {
                conGuardar = obtenerConexion();
                conGuardar.setAutoCommit(false);

                PreparedStatement psExisteEmail = conGuardar.prepareStatement(
                    "SELECT id_usuario FROM usuario WHERE email = ?");
                psExisteEmail.setString(1, emailNvo);
                ResultSet rsExisteEmail = psExisteEmail.executeQuery();
                if (rsExisteEmail.next()) {
                    mensajeError = "El correo electrónico ya se encuentra registrado.";
                    rsExisteEmail.close(); psExisteEmail.close();
                    conGuardar.rollback();
                } else {
                    rsExisteEmail.close(); psExisteEmail.close();

                    PreparedStatement psInsertarUsr = conGuardar.prepareStatement(
                        "INSERT INTO usuario (nombre, email, contrasena, activo) VALUES (?, ?, ?, 1)",
                        Statement.RETURN_GENERATED_KEYS);
                    psInsertarUsr.setString(1, nombreNvo.trim());
                    psInsertarUsr.setString(2, emailNvo.trim());
                    psInsertarUsr.setString(3, generarHashContrasena(contrasenaNva));
                    psInsertarUsr.executeUpdate();

                    ResultSet rsGenerado = psInsertarUsr.getGeneratedKeys();
                    int idUsuarioNvo = -1;
                    if (rsGenerado.next()) idUsuarioNvo = rsGenerado.getInt(1);
                    rsGenerado.close(); psInsertarUsr.close();

                    PreparedStatement psAsignarRol = conGuardar.prepareStatement(
                        "INSERT INTO usuario_rol (id_usuario, id_rol) VALUES (?, ?)");
                    psAsignarRol.setInt(1, idUsuarioNvo);
                    psAsignarRol.setInt(2, Integer.parseInt(idRolSeleccionado));
                    psAsignarRol.executeUpdate();
                    psAsignarRol.close();

                    conGuardar.commit();
                    response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
                    return;
                }
            } catch (SQLIntegrityConstraintViolationException exDup) {
                try { if (conGuardar != null) conGuardar.rollback(); } catch (Exception ig) {}
                mensajeError = "El correo electrónico ya se encuentra registrado.";
            } catch (Exception exGuardar) {
                try { if (conGuardar != null) conGuardar.rollback(); } catch (Exception ig) {}
                mensajeError = "Ocurrió un problema al guardar el usuario.";
            } finally {
                if (conGuardar != null) {
                    try { conGuardar.setAutoCommit(true); conGuardar.close(); } catch (Exception ig) {}
                }
            }
        }
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Nuevo usuario</h2>
<%
    if (mensajeError != null) {
%>
    <div class="alerta-error"><%= mensajeError %></div>
<%
    }
%>
    <form method="post" action="<%= request.getContextPath() %>/admin/guardar-usuario.jsp" class="card-registro">
        <div class="mb-3">
            <label class="form-label">Nombre completo</label>
            <input type="text" name="nombre" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Correo electrónico</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Contraseña</label>
            <input type="password" name="contrasena" class="form-control" minlength="6" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Rol</label>
            <select name="id_rol" class="form-select" required>
                <option value="">Selecciona un rol</option>
<%
    Connection conRoles = null;
    try {
        conRoles = obtenerConexion();
        PreparedStatement psRoles = conRoles.prepareStatement("SELECT id_rol, nombre FROM rol ORDER BY nombre");
        ResultSet rsRoles = psRoles.executeQuery();
        while (rsRoles.next()) {
%>
                <option value="<%= rsRoles.getInt("id_rol") %>"><%= rsRoles.getString("nombre") %></option>
<%
        }
        rsRoles.close(); psRoles.close();
    } catch (Exception exRoles) {
    } finally {
        if (conRoles != null) { try { conRoles.close(); } catch (Exception ig) {} }
    }
%>
            </select>
        </div>
        <button type="submit" class="btn-explorar w-100">Guardar usuario</button>
    </form>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>