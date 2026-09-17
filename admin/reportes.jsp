<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "ADMINISTRADOR";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Reportes administrativos</h2>
    <div class="row g-4">
        <div class="col-12">
            <h3 class="h5">Propiedades disponibles por ciudad</h3>
            <table class="table table-bordered bg-white">
                <thead><tr><th>Ciudad</th><th>Estado</th><th>Cantidad</th></tr></thead>
                <tbody>
<%
    Connection conexionReportes = null;
    try {
        conexionReportes = obtenerConexion();
        PreparedStatement psPropiedadesCiudad = conexionReportes.prepareStatement(
            "SELECT c.nombre AS ciudad, p.estado, COUNT(*) AS total " +
            "FROM propiedad p INNER JOIN ciudad c ON c.id_ciudad = p.id_ciudad " +
            "INNER JOIN tipo_propiedad tp ON tp.id_tipo = p.id_tipo " +
            "WHERE p.estado = 'disponible' " +
            "GROUP BY c.id_ciudad, c.nombre, p.estado " +
            "HAVING COUNT(*) > 0 ORDER BY c.nombre");
        ResultSet rsPropiedadesCiudad = psPropiedadesCiudad.executeQuery();
        boolean hayPropiedadesCiudad = false;
        while (rsPropiedadesCiudad.next()) {
            hayPropiedadesCiudad = true;
%>
                    <tr><td><%= rsPropiedadesCiudad.getString("ciudad") %></td><td><%= rsPropiedadesCiudad.getString("estado") %></td><td><%= rsPropiedadesCiudad.getInt("total") %></td></tr>
<%
        }
        if (!hayPropiedadesCiudad) {
%>
                    <tr><td colspan="3">No hay propiedades disponibles.</td></tr>
<%
        }
        rsPropiedadesCiudad.close(); psPropiedadesCiudad.close();
%>
                </tbody>
            </table>

            <h3 class="h5 mt-4">Citas por estado</h3>
            <table class="table table-bordered bg-white">
                <thead><tr><th>Estado</th><th>Cantidad</th></tr></thead>
                <tbody>
<%
        PreparedStatement psCitasEstado = conexionReportes.prepareStatement(
            "SELECT estado, COUNT(*) AS total FROM cita GROUP BY estado ORDER BY estado");
        ResultSet rsCitasEstado = psCitasEstado.executeQuery();
        boolean hayCitasEstado = false;
        while (rsCitasEstado.next()) {
            hayCitasEstado = true;
%>
                    <tr><td><%= rsCitasEstado.getString("estado") %></td><td><%= rsCitasEstado.getInt("total") %></td></tr>
<%
        }
        if (!hayCitasEstado) {
%>
                    <tr><td colspan="2">No hay citas registradas.</td></tr>
<%
        }
        rsCitasEstado.close(); psCitasEstado.close();
%>
                </tbody>
            </table>

            <h3 class="h5 mt-4">Solicitudes por inmobiliaria</h3>
            <table class="table table-bordered bg-white">
                <thead><tr><th>Inmobiliaria</th><th>Estado</th><th>Cantidad</th></tr></thead>
                <tbody>
<%
        PreparedStatement psSolicitudesInmobiliaria = conexionReportes.prepareStatement(
            "SELECT im.nombre_comercial, s.estado, COUNT(*) AS total " +
            "FROM solicitud s INNER JOIN propiedad p ON p.id_propiedad = s.id_propiedad " +
            "INNER JOIN inmobiliaria im ON im.id_inmobiliaria = p.id_inmobiliaria " +
            "GROUP BY im.id_inmobiliaria, im.nombre_comercial, s.estado " +
            "ORDER BY im.nombre_comercial, s.estado");
        ResultSet rsSolicitudesInmobiliaria = psSolicitudesInmobiliaria.executeQuery();
        boolean haySolicitudesInmobiliaria = false;
        while (rsSolicitudesInmobiliaria.next()) {
            haySolicitudesInmobiliaria = true;
%>
                    <tr><td><%= rsSolicitudesInmobiliaria.getString("nombre_comercial") %></td><td><%= rsSolicitudesInmobiliaria.getString("estado") %></td><td><%= rsSolicitudesInmobiliaria.getInt("total") %></td></tr>
<%
        }
        if (!haySolicitudesInmobiliaria) {
%>
                    <tr><td colspan="3">No hay solicitudes registradas.</td></tr>
<%
        }
        rsSolicitudesInmobiliaria.close(); psSolicitudesInmobiliaria.close();
%>
                </tbody>
            </table>

            <h3 class="h5 mt-4">Propiedades sin citas</h3>
            <table class="table table-bordered bg-white">
                <thead><tr><th>Propiedad</th><th>Ciudad</th><th>Inmobiliaria</th></tr></thead>
                <tbody>
<%
        PreparedStatement psPropiedadesSinCitas = conexionReportes.prepareStatement(
            "SELECT p.titulo, c.nombre AS ciudad, im.nombre_comercial " +
            "FROM propiedad p LEFT JOIN cita ci ON ci.id_propiedad = p.id_propiedad " +
            "INNER JOIN ciudad c ON c.id_ciudad = p.id_ciudad " +
            "INNER JOIN inmobiliaria im ON im.id_inmobiliaria = p.id_inmobiliaria " +
            "WHERE ci.id_cita IS NULL ORDER BY p.titulo");
        ResultSet rsPropiedadesSinCitas = psPropiedadesSinCitas.executeQuery();
        boolean hayPropiedadesSinCitas = false;
        while (rsPropiedadesSinCitas.next()) {
            hayPropiedadesSinCitas = true;
%>
                    <tr><td><%= rsPropiedadesSinCitas.getString("titulo") %></td><td><%= rsPropiedadesSinCitas.getString("ciudad") %></td><td><%= rsPropiedadesSinCitas.getString("nombre_comercial") %></td></tr>
<%
        }
        if (!hayPropiedadesSinCitas) {
%>
                    <tr><td colspan="3">Todas las propiedades tienen citas o no hay propiedades registradas.</td></tr>
<%
        }
        rsPropiedadesSinCitas.close(); psPropiedadesSinCitas.close();
    } catch (Exception exReportes) {
%>
                    <tr><td colspan="3" class="text-danger">Ocurrió un problema al generar los reportes.</td></tr>
<%
    } finally {
        if (conexionReportes != null) { try { conexionReportes.close(); } catch (Exception ignorado) {} }
    }
%>
                </tbody>
            </table>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
