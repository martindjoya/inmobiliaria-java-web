<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "ADMINISTRADOR";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Auditoría del sistema</h2>
    <table class="table table-bordered bg-white">
        <thead>
            <tr>
                <th>Fecha</th>
                <th>Usuario</th>
                <th>Acción</th>
                <th>Tabla afectada</th>
                <th>Detalle</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conexionAuditoria = null;
    try {
        conexionAuditoria = obtenerConexion();
        String sqlAuditoria =
            "SELECT a.fecha, a.accion, a.tabla_afectada, a.detalle, u.nombre AS nombre_usuario " +
            "FROM auditoria a " +
            "LEFT JOIN usuario u ON a.id_usuario = u.id_usuario " +
            "ORDER BY a.fecha DESC";
        PreparedStatement psAuditoria = conexionAuditoria.prepareStatement(sqlAuditoria);
        ResultSet rsAuditoria = psAuditoria.executeQuery();
        boolean hayRegistros = false;
        while (rsAuditoria.next()) {
            hayRegistros = true;
            String nombreUsuarioAud = rsAuditoria.getString("nombre_usuario");
            if (nombreUsuarioAud == null) nombreUsuarioAud = "(usuario eliminado)";
%>
            <tr>
                <td><%= rsAuditoria.getTimestamp("fecha") %></td>
                <td><%= nombreUsuarioAud %></td>
                <td><%= rsAuditoria.getString("accion") %></td>
                <td><%= rsAuditoria.getString("tabla_afectada") %></td>
                <td><%= rsAuditoria.getString("detalle") %></td>
            </tr>
<%
        }
        if (!hayRegistros) {
%>
            <tr><td colspan="5">Sin registros de auditoría todavía.</td></tr>
<%
        }
        rsAuditoria.close(); psAuditoria.close();
    } catch (Exception exAuditoria) {
%>
            <tr><td colspan="5" class="text-danger">Ocurrió un problema al consultar la auditoría.</td></tr>
<%
    } finally {
        if (conexionAuditoria != null) { try { conexionAuditoria.close(); } catch (Exception ig) {} }
    }
%>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>