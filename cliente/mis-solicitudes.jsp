<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "CLIENTE";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%
    int idUsuarioSol = (Integer) session.getAttribute("idUsuario");
    String mensajeErrorSol = null;

    if ("crear".equals(request.getParameter("accion")) && "POST".equalsIgnoreCase(request.getMethod())) {
        String idPropSol = request.getParameter("id_propiedad");
        String tipoSol = request.getParameter("tipo_solicitud");

        if (idPropSol == null || idPropSol.isEmpty()
            || (!"compra".equals(tipoSol) && !"arriendo".equals(tipoSol))) {
            mensajeErrorSol = "Debes seleccionar una propiedad y un tipo de solicitud válido.";
        } else {
            Connection conCrearSol = null;
            try {
                conCrearSol = obtenerConexion();
                PreparedStatement psCrearSol = conCrearSol.prepareStatement(
                    "INSERT INTO solicitud (id_propiedad, id_usuario, tipo_solicitud, estado) VALUES (?, ?, ?, 'pendiente')");
                psCrearSol.setInt(1, Integer.parseInt(idPropSol));
                psCrearSol.setInt(2, idUsuarioSol);
                psCrearSol.setString(3, tipoSol);
                psCrearSol.executeUpdate();
                psCrearSol.close();
                response.sendRedirect(request.getContextPath() + "/cliente/mis-solicitudes.jsp");
                return;
            } catch (Exception exCrearSol) {
                mensajeErrorSol = "Ocurrió un problema al crear la solicitud.";
            } finally {
                if (conCrearSol != null) { try { conCrearSol.close(); } catch (Exception ig) {} }
            }
        }
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Nueva solicitud</h2>
<%
    if (mensajeErrorSol != null) {
%>
    <div class="alerta-error"><%= mensajeErrorSol %></div>
<%
    }
%>
    <form method="post" action="<%= request.getContextPath() %>/cliente/mis-solicitudes.jsp" class="card-registro mb-5">
        <input type="hidden" name="accion" value="crear">
        <div class="mb-3">
            <label class="form-label">Propiedad</label>
            <select name="id_propiedad" class="form-select" required>
                <option value="">Selecciona una propiedad</option>
<%
    Connection conPropSol = null;
    try {
        conPropSol = obtenerConexion();
        PreparedStatement psPropSol = conPropSol.prepareStatement(
            "SELECT id_propiedad, titulo FROM propiedad WHERE estado = 'disponible' ORDER BY titulo");
        ResultSet rsPropSol = psPropSol.executeQuery();
        while (rsPropSol.next()) {
%>
                <option value="<%= rsPropSol.getInt("id_propiedad") %>"><%= rsPropSol.getString("titulo") %></option>
<%
        }
        rsPropSol.close(); psPropSol.close();
    } catch (Exception exPropSol) {
    } finally {
        if (conPropSol != null) { try { conPropSol.close(); } catch (Exception ig) {} }
    }
%>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label">Tipo de solicitud</label>
            <select name="tipo_solicitud" class="form-select" required>
                <option value="compra">Compra</option>
                <option value="arriendo">Arriendo</option>
            </select>
        </div>
        <button type="submit" class="btn-explorar w-100">Enviar solicitud</button>
    </form>

    <h3 class="titulo-seccion mb-3">Mis solicitudes</h3>
    <table class="table table-bordered bg-white">
        <thead>
            <tr><th>Propiedad</th><th>Tipo</th><th>Fecha</th><th>Estado</th><th>Documentos</th></tr>
        </thead>
        <tbody>
<%
    Connection conListaSol = null;
    try {
        conListaSol = obtenerConexion();
        PreparedStatement psListaSol = conListaSol.prepareStatement(
            "SELECT s.id_solicitud, s.tipo_solicitud, s.fecha_solicitud, s.estado, p.titulo FROM solicitud s " +
            "JOIN propiedad p ON s.id_propiedad = p.id_propiedad " +
            "WHERE s.id_usuario = ? ORDER BY s.fecha_solicitud DESC");
        psListaSol.setInt(1, idUsuarioSol);
        ResultSet rsListaSol = psListaSol.executeQuery();
        boolean haySolicitudes = false;
        while (rsListaSol.next()) {
            haySolicitudes = true;
%>
            <tr>
                <td><%= rsListaSol.getString("titulo") %></td>
                <td><%= rsListaSol.getString("tipo_solicitud") %></td>
                <td><%= rsListaSol.getTimestamp("fecha_solicitud") %></td>
                <td><%= rsListaSol.getString("estado") %></td>
                <td><a href="<%= request.getContextPath() %>/cliente/documentos.jsp?id_solicitud=<%= rsListaSol.getInt("id_solicitud") %>" class="btn-detalles">Ver/subir</a></td>
            </tr>
<%
        }
        if (!haySolicitudes) {
%>
            <tr><td colspan="5">Aún no tienes solicitudes.</td></tr>
<%
        }
        rsListaSol.close(); psListaSol.close();
    } catch (Exception exListaSol) {
%>
            <tr><td colspan="5" class="text-danger">Ocurrió un problema al consultar tus solicitudes.</td></tr>
<%
    } finally {
        if (conListaSol != null) { try { conListaSol.close(); } catch (Exception ig) {} }
    }
%>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>