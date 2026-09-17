<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "CLIENTE";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%
    int idUsuarioDoc = (Integer) session.getAttribute("idUsuario");
    String mensajeErrorDoc = null;
    Integer idSolicitudDoc = null;
    try {
        idSolicitudDoc = Integer.parseInt(request.getParameter("id_solicitud"));
    } catch (Exception ex) {
        idSolicitudDoc = null;
    }

    if (idSolicitudDoc == null) {
        response.sendRedirect(request.getContextPath() + "/cliente/mis-solicitudes.jsp");
        return;
    }

    // Verifica que la solicitud pertenezca al usuario en sesión
    boolean solicitudValida = false;
    Connection conVerificarSol = null;
    try {
        conVerificarSol = obtenerConexion();
        PreparedStatement psVerificar = conVerificarSol.prepareStatement(
            "SELECT id_solicitud FROM solicitud WHERE id_solicitud = ? AND id_usuario = ?");
        psVerificar.setInt(1, idSolicitudDoc);
        psVerificar.setInt(2, idUsuarioDoc);
        ResultSet rsVerificar = psVerificar.executeQuery();
        solicitudValida = rsVerificar.next();
        rsVerificar.close(); psVerificar.close();
    } catch (Exception exVerificar) {
        solicitudValida = false;
    } finally {
        if (conVerificarSol != null) { try { conVerificarSol.close(); } catch (Exception ig) {} }
    }

    if (!solicitudValida) {
        response.sendRedirect(request.getContextPath() + "/cliente/mis-solicitudes.jsp");
        return;
    }

    if ("agregar".equals(request.getParameter("accion")) && "POST".equalsIgnoreCase(request.getMethod())) {
        String nombreArchivoDoc = request.getParameter("nombre_archivo");
        if (nombreArchivoDoc == null || nombreArchivoDoc.trim().isEmpty()) {
            mensajeErrorDoc = "Debes indicar el nombre del archivo.";
        } else {
            Connection conAgregarDoc = null;
            try {
                conAgregarDoc = obtenerConexion();
                PreparedStatement psAgregarDoc = conAgregarDoc.prepareStatement(
                    "INSERT INTO documento_solicitud (id_solicitud, nombre_archivo, ruta_archivo) VALUES (?, ?, ?)");
                psAgregarDoc.setInt(1, idSolicitudDoc);
                psAgregarDoc.setString(2, nombreArchivoDoc.trim());
                // Simulado: como no hay subida real, guardamos una ruta ficticia basada en el nombre
                psAgregarDoc.setString(3, "documentos/" + idSolicitudDoc + "_" + nombreArchivoDoc.trim());
                psAgregarDoc.executeUpdate();
                psAgregarDoc.close();
                response.sendRedirect(request.getContextPath() + "/cliente/documentos.jsp?id_solicitud=" + idSolicitudDoc);
                return;
            } catch (Exception exAgregarDoc) {
                mensajeErrorDoc = "Ocurrió un problema al registrar el documento.";
            } finally {
                if (conAgregarDoc != null) { try { conAgregarDoc.close(); } catch (Exception ig) {} }
            }
        }
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Documentos de la solicitud #<%= idSolicitudDoc %></h2>
<%
    if (mensajeErrorDoc != null) {
%>
    <div class="alerta-error"><%= mensajeErrorDoc %></div>
<%
    }
%>
    <div class="alert alert-secondary">
        Por ahora esto es una simulación: escribe el nombre del archivo como si lo hubieras subido (aún no hay carga real de archivos).
    </div>

    <form method="post" action="<%= request.getContextPath() %>/cliente/documentos.jsp?id_solicitud=<%= idSolicitudDoc %>" class="card-registro mb-5">
        <input type="hidden" name="accion" value="agregar">
        <div class="mb-3">
            <label class="form-label">Nombre del archivo</label>
            <input type="text" name="nombre_archivo" class="form-control" placeholder="ej. cedula.pdf" required>
        </div>
        <button type="submit" class="btn-explorar w-100">Registrar documento</button>
    </form>

    <h3 class="titulo-seccion mb-3">Documentos registrados</h3>
    <table class="table table-bordered bg-white">
        <thead>
            <tr><th>Nombre de archivo</th><th>Fecha de registro</th></tr>
        </thead>
        <tbody>
<%
    Connection conListaDoc = null;
    try {
        conListaDoc = obtenerConexion();
        PreparedStatement psListaDoc = conListaDoc.prepareStatement(
            "SELECT nombre_archivo, fecha_subida FROM documento_solicitud WHERE id_solicitud = ? ORDER BY fecha_subida DESC");
        psListaDoc.setInt(1, idSolicitudDoc);
        ResultSet rsListaDoc = psListaDoc.executeQuery();
        boolean hayDocumentos = false;
        while (rsListaDoc.next()) {
            hayDocumentos = true;
%>
            <tr>
                <td><%= rsListaDoc.getString("nombre_archivo") %></td>
                <td><%= rsListaDoc.getTimestamp("fecha_subida") %></td>
            </tr>
<%
        }
        if (!hayDocumentos) {
%>
            <tr><td colspan="2">Aún no hay documentos registrados para esta solicitud.</td></tr>
<%
        }
        rsListaDoc.close(); psListaDoc.close();
    } catch (Exception exListaDoc) {
%>
            <tr><td colspan="2" class="text-danger">Ocurrió un problema al consultar los documentos.</td></tr>
<%
    } finally {
        if (conListaDoc != null) { try { conListaDoc.close(); } catch (Exception ig) {} }
    }
%>
        </tbody>
    </table>

    <a href="<%= request.getContextPath() %>/cliente/mis-solicitudes.jsp" class="btn-detalles">&larr; Volver a mis solicitudes</a>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>