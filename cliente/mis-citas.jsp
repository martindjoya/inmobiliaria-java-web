<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "CLIENTE";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%
    int idUsuarioCita = (Integer) session.getAttribute("idUsuario");
    String mensajeErrorCita = null;

    if ("agendar".equals(request.getParameter("accion")) && "POST".equalsIgnoreCase(request.getMethod())) {
        String idPropCita = request.getParameter("id_propiedad");
        String fechaCitaTexto = request.getParameter("fecha_cita");

        if (idPropCita == null || idPropCita.isEmpty() || fechaCitaTexto == null || fechaCitaTexto.isEmpty()) {
            mensajeErrorCita = "Debes seleccionar una propiedad y una fecha.";
        } else {
            Connection conAgendar = null;
            try {
                conAgendar = obtenerConexion();
                PreparedStatement psAgendar = conAgendar.prepareStatement(
                    "INSERT INTO cita (id_propiedad, id_usuario, fecha_cita, estado) VALUES (?, ?, ?, 'pendiente')");
                psAgendar.setInt(1, Integer.parseInt(idPropCita));
                psAgendar.setInt(2, idUsuarioCita);
                psAgendar.setTimestamp(3, Timestamp.valueOf(fechaCitaTexto.replace("T", " ") + ":00"));
                psAgendar.executeUpdate();
                psAgendar.close();
                response.sendRedirect(request.getContextPath() + "/cliente/mis-citas.jsp");
                return;
            } catch (Exception exAgendar) {
                mensajeErrorCita = "Ocurrió un problema al agendar la cita.";
            } finally {
                if (conAgendar != null) { try { conAgendar.close(); } catch (Exception ig) {} }
            }
        }
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Agendar una visita</h2>
<%
    if (mensajeErrorCita != null) {
%>
    <div class="alerta-error"><%= mensajeErrorCita %></div>
<%
    }
%>
    <form method="post" action="<%= request.getContextPath() %>/cliente/mis-citas.jsp" class="card-registro mb-5">
        <input type="hidden" name="accion" value="agendar">
        <div class="mb-3">
            <label class="form-label">Propiedad</label>
            <select name="id_propiedad" class="form-select" required>
                <option value="">Selecciona una propiedad</option>
<%
    Connection conPropCita = null;
    try {
        conPropCita = obtenerConexion();
        PreparedStatement psPropCita = conPropCita.prepareStatement(
            "SELECT id_propiedad, titulo FROM propiedad WHERE estado = 'disponible' ORDER BY titulo");
        ResultSet rsPropCita = psPropCita.executeQuery();
        while (rsPropCita.next()) {
%>
                <option value="<%= rsPropCita.getInt("id_propiedad") %>"><%= rsPropCita.getString("titulo") %></option>
<%
        }
        rsPropCita.close(); psPropCita.close();
    } catch (Exception exPropCita) {
    } finally {
        if (conPropCita != null) { try { conPropCita.close(); } catch (Exception ig) {} }
    }
%>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label">Fecha y hora</label>
            <input type="datetime-local" name="fecha_cita" class="form-control" required>
        </div>
        <button type="submit" class="btn-explorar w-100">Agendar visita</button>
    </form>

    <h3 class="titulo-seccion mb-3">Mis citas</h3>
    <table class="table table-bordered bg-white">
        <thead>
            <tr><th>Propiedad</th><th>Fecha</th><th>Estado</th></tr>
        </thead>
        <tbody>
<%
    Connection conListaCitas = null;
    try {
        conListaCitas = obtenerConexion();
        PreparedStatement psListaCitas = conListaCitas.prepareStatement(
            "SELECT c.fecha_cita, c.estado, p.titulo FROM cita c " +
            "JOIN propiedad p ON c.id_propiedad = p.id_propiedad " +
            "WHERE c.id_usuario = ? ORDER BY c.fecha_cita DESC");
        psListaCitas.setInt(1, idUsuarioCita);
        ResultSet rsListaCitas = psListaCitas.executeQuery();
        boolean hayCitas = false;
        while (rsListaCitas.next()) {
            hayCitas = true;
%>
            <tr>
                <td><%= rsListaCitas.getString("titulo") %></td>
                <td><%= rsListaCitas.getTimestamp("fecha_cita") %></td>
                <td><%= rsListaCitas.getString("estado") %></td>
            </tr>
<%
        }
        if (!hayCitas) {
%>
            <tr><td colspan="3">Aún no tienes citas agendadas.</td></tr>
<%
        }
        rsListaCitas.close(); psListaCitas.close();
    } catch (Exception exListaCitas) {
%>
            <tr><td colspan="3" class="text-danger">Ocurrió un problema al consultar tus citas.</td></tr>
<%
    } finally {
        if (conListaCitas != null) { try { conListaCitas.close(); } catch (Exception ig) {} }
    }
%>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>