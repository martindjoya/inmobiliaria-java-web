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
    int idUsuarioCitasInm = (Integer) session.getAttribute("idUsuario");
    java.util.List<String> estadosCitaValidos = Arrays.asList("pendiente", "confirmada", "cancelada", "realizada");

    Connection conCitasInm = null;
    try {
        conCitasInm = obtenerConexion();
        Integer idInmobiliariaCitas = obtenerIdInmobiliaria(conCitasInm, idUsuarioCitasInm);
        if (idInmobiliariaCitas == null) {
            conCitasInm.close();
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/inicio.jsp");
            return;
        }

        if ("cambiarEstado".equals(request.getParameter("accion")) && "POST".equalsIgnoreCase(request.getMethod())) {
            String idCitaCambio = request.getParameter("id_cita");
            String nuevoEstadoCita = request.getParameter("nuevo_estado");
            if (idCitaCambio != null && estadosCitaValidos.contains(nuevoEstadoCita)) {
                PreparedStatement psCambiarCita = conCitasInm.prepareStatement(
                    "UPDATE cita c JOIN propiedad p ON c.id_propiedad = p.id_propiedad " +
                    "SET c.estado = ? WHERE c.id_cita = ? AND p.id_inmobiliaria = ?");
                psCambiarCita.setString(1, nuevoEstadoCita);
                psCambiarCita.setInt(2, Integer.parseInt(idCitaCambio));
                psCambiarCita.setInt(3, idInmobiliariaCitas);
                psCambiarCita.executeUpdate();
                psCambiarCita.close();
            }
            conCitasInm.close();
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/citas.jsp");
            return;
        }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Citas de mis propiedades</h2>
    <table class="table table-bordered bg-white">
        <thead>
            <tr><th>Propiedad</th><th>Cliente</th><th>Fecha</th><th>Estado</th></tr>
        </thead>
        <tbody>
<%
        String sqlCitasInm =
            "SELECT c.id_cita, c.fecha_cita, c.estado, p.titulo, u.nombre AS nombre_cliente " +
            "FROM cita c " +
            "JOIN propiedad p ON c.id_propiedad = p.id_propiedad " +
            "JOIN usuario u ON c.id_usuario = u.id_usuario " +
            "WHERE p.id_inmobiliaria = ? " +
            "ORDER BY c.fecha_cita DESC";
        PreparedStatement psCitasInm = conCitasInm.prepareStatement(sqlCitasInm);
        psCitasInm.setInt(1, idInmobiliariaCitas);
        ResultSet rsCitasInm = psCitasInm.executeQuery();
        boolean hayCitasInm = false;
        while (rsCitasInm.next()) {
            hayCitasInm = true;
            int idCitaFila = rsCitasInm.getInt("id_cita");
            String estadoActualCita = rsCitasInm.getString("estado");
%>
            <tr>
                <td><%= rsCitasInm.getString("titulo") %></td>
                <td><%= rsCitasInm.getString("nombre_cliente") %></td>
                <td><%= rsCitasInm.getTimestamp("fecha_cita") %></td>
                <td>
                    <form method="post" action="<%= request.getContextPath() %>/inmobiliaria/citas.jsp" class="d-flex gap-1">
                        <input type="hidden" name="accion" value="cambiarEstado">
                        <input type="hidden" name="id_cita" value="<%= idCitaFila %>">
                        <select name="nuevo_estado" class="form-select form-select-sm">
<%
            for (String estOpcionCita : estadosCitaValidos) {
                String selCita = estOpcionCita.equals(estadoActualCita) ? "selected" : "";
%>
                            <option value="<%= estOpcionCita %>" <%= selCita %>><%= estOpcionCita %></option>
<%
            }
%>
                        </select>
                        <button type="submit" class="btn-detalles">Guardar</button>
                    </form>
                </td>
            </tr>
<%
        }
        if (!hayCitasInm) {
%>
            <tr><td colspan="4">Aún no tienes citas registradas.</td></tr>
<%
        }
        rsCitasInm.close(); psCitasInm.close();
    } catch (Exception exCitasInm) {
%>
            <tr><td colspan="4" class="text-danger">Ocurrió un problema al consultar las citas.</td></tr>
<%
    } finally {
        if (conCitasInm != null) { try { conCitasInm.close(); } catch (Exception ig) {} }
    }
%>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>