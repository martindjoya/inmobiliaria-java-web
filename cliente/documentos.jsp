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
    String errorCargaDoc = request.getParameter("error");
    if ("vacio".equals(errorCargaDoc)) mensajeErrorDoc = "Selecciona un archivo antes de enviarlo.";
    if ("tamano".equals(errorCargaDoc)) mensajeErrorDoc = "El archivo no puede superar 5 MB.";
    if ("extension".equals(errorCargaDoc)) mensajeErrorDoc = "Solo se permiten archivos PDF, JPG, JPEG o PNG.";
    if ("duplicado".equals(errorCargaDoc)) mensajeErrorDoc = "Ya existe un documento con ese nombre en esta solicitud.";
    if ("solicitud".equals(errorCargaDoc)) mensajeErrorDoc = "La solicitud no existe o no pertenece al usuario actual.";
    if ("general".equals(errorCargaDoc)) mensajeErrorDoc = "No se pudo guardar el archivo.";
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
    <div class="alert alert-secondary">Formatos permitidos: PDF, JPG, JPEG y PNG. Tamaño máximo: 5 MB.</div>

    <form method="post" enctype="multipart/form-data" action="<%= request.getContextPath() %>/cliente/subir-documento" class="card-registro mb-5">
        <input type="hidden" name="id_solicitud" value="<%= idSolicitudDoc %>">
        <div class="mb-3">
            <label class="form-label">Archivo</label>
            <input type="file" name="archivo" class="form-control" accept=".pdf,.jpg,.jpeg,.png" required>
        </div>
        <button type="submit" class="btn-explorar w-100">Subir documento</button>
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