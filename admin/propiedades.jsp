<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Arrays" %>
<%
    String rolRequerido = "ADMINISTRADOR";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%
    java.util.List<String> estadosValidos = Arrays.asList("disponible", "reservada", "vendida", "alquilada");

    if ("cambiarEstado".equals(request.getParameter("accion")) && "POST".equalsIgnoreCase(request.getMethod())) {
        String idPropParam = request.getParameter("id_propiedad");
        String nuevoEstado = request.getParameter("nuevo_estado");
        if (idPropParam != null && estadosValidos.contains(nuevoEstado)) {
            Connection conEstado = null;
            try {
                conEstado = obtenerConexion();
                PreparedStatement psEstado = conEstado.prepareStatement(
                    "UPDATE propiedad SET estado = ? WHERE id_propiedad = ?");
                psEstado.setString(1, nuevoEstado);
                psEstado.setInt(2, Integer.parseInt(idPropParam));
                psEstado.executeUpdate();
                psEstado.close();
            } catch (Exception exEstado) {
            } finally {
                if (conEstado != null) { try { conEstado.close(); } catch (Exception ig) {} }
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/propiedades.jsp");
        return;
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Todas las propiedades</h2>
    <table class="table table-bordered bg-white">
        <thead>
            <tr>
                <th>Título</th>
                <th>Ciudad</th>
                <th>Tipo</th>
                <th>Inmobiliaria</th>
                <th>Precio</th>
                <th>Estado</th>
            </tr>
        </thead>
        <tbody>
<%
    Connection conexionAdminProp = null;
    try {
        conexionAdminProp = obtenerConexion();
        String sqlAdminProp =
            "SELECT p.id_propiedad, p.titulo, p.precio, p.estado, " +
            "c.nombre AS nombre_ciudad, tp.nombre AS nombre_tipo, im.nombre_comercial " +
            "FROM propiedad p " +
            "JOIN ciudad c ON p.id_ciudad = c.id_ciudad " +
            "JOIN tipo_propiedad tp ON p.id_tipo = tp.id_tipo " +
            "JOIN inmobiliaria im ON p.id_inmobiliaria = im.id_inmobiliaria " +
            "ORDER BY p.fecha_publicacion DESC";
        PreparedStatement psAdminProp = conexionAdminProp.prepareStatement(sqlAdminProp);
        ResultSet rsAdminProp = psAdminProp.executeQuery();
        while (rsAdminProp.next()) {
            int idPropFila = rsAdminProp.getInt("id_propiedad");
            String estadoActualFila = rsAdminProp.getString("estado");
%>
            <tr>
                <td><%= rsAdminProp.getString("titulo") %></td>
                <td><%= rsAdminProp.getString("nombre_ciudad") %></td>
                <td><%= rsAdminProp.getString("nombre_tipo") %></td>
                <td><%= rsAdminProp.getString("nombre_comercial") %></td>
                <td>$<%= String.format("%,.0f", rsAdminProp.getDouble("precio")) %></td>
                <td>
                    <form method="post" action="<%= request.getContextPath() %>/admin/propiedades.jsp" class="d-flex gap-1">
                        <input type="hidden" name="accion" value="cambiarEstado">
                        <input type="hidden" name="id_propiedad" value="<%= idPropFila %>">
                        <select name="nuevo_estado" class="form-select form-select-sm">
<%
            for (String estadoOpcion : estadosValidos) {
                String selEstado = estadoOpcion.equals(estadoActualFila) ? "selected" : "";
%>
                            <option value="<%= estadoOpcion %>" <%= selEstado %>><%= estadoOpcion %></option>
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
        rsAdminProp.close(); psAdminProp.close();
    } catch (Exception exAdminProp) {
%>
            <tr><td colspan="6" class="text-danger">Ocurrió un problema al consultar las propiedades.</td></tr>
<%
    } finally {
        if (conexionAdminProp != null) { try { conexionAdminProp.close(); } catch (Exception ig) {} }
    }
%>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>