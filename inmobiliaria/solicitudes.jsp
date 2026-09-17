<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Arrays" %>
<%
    String rolRequerido = "INMOBILIARIA";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%
    int idUsuarioSolInm = (Integer) session.getAttribute("idUsuario");
    java.util.List<String> estadosSolValidos = Arrays.asList("pendiente", "en_revision", "aprobada", "rechazada");

    Connection conSolInm = null;
    try {
        conSolInm = obtenerConexion();
        Integer idInmobiliariaSol = obtenerIdInmobiliaria(conSolInm, idUsuarioSolInm);
        if (idInmobiliariaSol == null) {
            conSolInm.close();
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/inicio.jsp");
            return;
        }

        if ("cambiarEstado".equals(request.getParameter("accion")) && "POST".equalsIgnoreCase(request.getMethod())) {
            String idSolCambio = request.getParameter("id_solicitud");
            String nuevoEstadoSol = request.getParameter("nuevo_estado");
            if (idSolCambio != null && estadosSolValidos.contains(nuevoEstadoSol)) {
                PreparedStatement psCambiarSol = conSolInm.prepareStatement(
                    "UPDATE solicitud s JOIN propiedad p ON s.id_propiedad = p.id_propiedad " +
                    "SET s.estado = ? WHERE s.id_solicitud = ? AND p.id_inmobiliaria = ?");
                psCambiarSol.setString(1, nuevoEstadoSol);
                psCambiarSol.setInt(2, Integer.parseInt(idSolCambio));
                psCambiarSol.setInt(3, idInmobiliariaSol);
                psCambiarSol.executeUpdate();
                psCambiarSol.close();
            }
            conSolInm.close();
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/solicitudes.jsp");
            return;
        }

        Integer idSolicitudVerDocs = null;
        try {
            idSolicitudVerDocs = Integer.parseInt(request.getParameter("ver_docs"));
        } catch (Exception ex) {
            idSolicitudVerDocs = null;
        }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Solicitudes de mis propiedades</h2>
    <table class="table table-bordered bg-white">
        <thead>
            <tr><th>Propiedad</th><th>Cliente</th><th>Tipo</th><th>Fecha</th><th>Estado</th><th>Documentos</th></tr>
        </thead>
        <tbody>
<%
        String sqlSolInm =
            "SELECT s.id_solicitud, s.tipo_solicitud, s.fecha_solicitud, s.estado, p.titulo, u.nombre AS nombre_cliente " +
            "FROM solicitud s " +
            "JOIN propiedad p ON s.id_propiedad = p.id_propiedad " +
            "JOIN usuario u ON s.id_usuario = u.id_usuario " +
            "WHERE p.id_inmobiliaria = ? " +
            "ORDER BY s.fecha_solicitud DESC";
        PreparedStatement psSolInm = conSolInm.prepareStatement(sqlSolInm);
        psSolInm.setInt(1, idInmobiliariaSol);
        ResultSet rsSolInm = psSolInm.executeQuery();
        boolean haySolInm = false;
        while (rsSolInm.next()) {
            haySolInm = true;
            int idSolFila = rsSolInm.getInt("id_solicitud");
            String estadoActualSol = rsSolInm.getString("estado");
%>
            <tr>
                <td><%= rsSolInm.getString("titulo") %></td>
                <td><%= rsSolInm.getString("nombre_cliente") %></td>
                <td><%= rsSolInm.getString("tipo_solicitud") %></td>
                <td><%= rsSolInm.getTimestamp("fecha_solicitud") %></td>
                <td>
                    <form method="post" action="<%= request.getContextPath() %>/inmobiliaria/solicitudes.jsp" class="d-flex gap-1">
                        <input type="hidden" name="accion" value="cambiarEstado">
                        <input type="hidden" name="id_solicitud" value="<%= idSolFila %>">
                        <select name="nuevo_estado" class="form-select form-select-sm">
<%
            for (String estOpcionSol : estadosSolValidos) {
                String selSol = estOpcionSol.equals(estadoActualSol) ? "selected" : "";
%>
                            <option value="<%= estOpcionSol %>" <%= selSol %>><%= estOpcionSol %></option>
<%
            }
%>
                        </select>
                        <button type="submit" class="btn-detalles">Guardar</button>
                    </form>
                </td>
                <td><a href="<%= request.getContextPath() %>/inmobiliaria/solicitudes.jsp?ver_docs=<%= idSolFila %>" class="btn-detalles">Ver documentos</a></td>
            </tr>
<%
        }
        if (!haySolInm) {
%>
            <tr><td colspan="6">Aún no tienes solicitudes registradas.</td></tr>
<%
        }
        rsSolInm.close(); psSolInm.close();
%>
        </tbody>
    </table>

<%
        if (idSolicitudVerDocs != null) {
%>
    <h3 class="titulo-seccion mt-4 mb-3">Documentos de la solicitud #<%= idSolicitudVerDocs %></h3>
    <table class="table table-bordered bg-white">
        <thead><tr><th>Nombre de archivo</th><th>Fecha de registro</th></tr></thead>
        <tbody>
<%
            PreparedStatement psDocsSol = conSolInm.prepareStatement(
                "SELECT ds.nombre_archivo, ds.fecha_subida FROM documento_solicitud ds " +
                "JOIN solicitud s ON ds.id_solicitud = s.id_solicitud " +
                "JOIN propiedad p ON s.id_propiedad = p.id_propiedad " +
                "WHERE ds.id_solicitud = ? AND p.id_inmobiliaria = ?");
            psDocsSol.setInt(1, idSolicitudVerDocs);
            psDocsSol.setInt(2, idInmobiliariaSol);
            ResultSet rsDocsSol = psDocsSol.executeQuery();
            boolean hayDocsSol = false;
            while (rsDocsSol.next()) {
                hayDocsSol = true;
%>
            <tr><td><%= rsDocsSol.getString("nombre_archivo") %></td><td><%= rsDocsSol.getTimestamp("fecha_subida") %></td></tr>
<%
            }
            if (!hayDocsSol) {
%>
            <tr><td colspan="2">Esta solicitud no tiene documentos registrados.</td></tr>
<%
            }
            rsDocsSol.close(); psDocsSol.close();
%>
        </tbody>
    </table>
<%
        }
    } catch (Exception exSolInm) {
%>
    <p class="text-danger">Ocurrió un problema al consultar las solicitudes.</p>
<%
    } finally {
        if (conSolInm != null) { try { conSolInm.close(); } catch (Exception ig) {} }
    }
%>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>