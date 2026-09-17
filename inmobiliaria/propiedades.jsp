<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "INMOBILIARIA";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%
    int idUsuarioPropInm = (Integer) session.getAttribute("idUsuario");
    Integer idInmobiliariaProp = null;
    Connection conPropInm = null;
    try {
        conPropInm = obtenerConexion();
        idInmobiliariaProp = obtenerIdInmobiliaria(conPropInm, idUsuarioPropInm);
    } catch (Exception ex) { }

    if (idInmobiliariaProp == null) {
        if (conPropInm != null) { try { conPropInm.close(); } catch (Exception ig) {} }
        response.sendRedirect(request.getContextPath() + "/inmobiliaria/inicio.jsp");
        return;
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="titulo-seccion mb-0">Mis propiedades</h2>
        <a href="<%= request.getContextPath() %>/inmobiliaria/guardar-propiedad.jsp" class="btn-explorar">+ Nueva propiedad</a>
    </div>
    <table class="table table-bordered bg-white">
        <thead>
            <tr><th>Título</th><th>Ciudad</th><th>Tipo</th><th>Precio</th><th>Estado</th><th>Acciones</th></tr>
        </thead>
        <tbody>
<%
    try {
        String sqlMisProp =
            "SELECT p.id_propiedad, p.titulo, p.precio, p.estado, " +
            "c.nombre AS nombre_ciudad, tp.nombre AS nombre_tipo " +
            "FROM propiedad p " +
            "JOIN ciudad c ON p.id_ciudad = c.id_ciudad " +
            "JOIN tipo_propiedad tp ON p.id_tipo = tp.id_tipo " +
            "WHERE p.id_inmobiliaria = ? " +
            "ORDER BY p.fecha_publicacion DESC";
        PreparedStatement psMisProp = conPropInm.prepareStatement(sqlMisProp);
        psMisProp.setInt(1, idInmobiliariaProp);
        ResultSet rsMisProp = psMisProp.executeQuery();
        boolean hayPropInm = false;
        while (rsMisProp.next()) {
            hayPropInm = true;
            int idPropFilaInm = rsMisProp.getInt("id_propiedad");
%>
            <tr>
                <td><%= rsMisProp.getString("titulo") %></td>
                <td><%= rsMisProp.getString("nombre_ciudad") %></td>
                <td><%= rsMisProp.getString("nombre_tipo") %></td>
                <td>$<%= String.format("%,.0f", rsMisProp.getDouble("precio")) %></td>
                <td><%= rsMisProp.getString("estado") %></td>
                <td>
                    <a href="<%= request.getContextPath() %>/inmobiliaria/editar-propiedad.jsp?id=<%= idPropFilaInm %>" class="btn-detalles">Editar</a>
                    <a href="<%= request.getContextPath() %>/inmobiliaria/imagenes.jsp?id_propiedad=<%= idPropFilaInm %>" class="btn-detalles">Imágenes</a>
                    <a href="<%= request.getContextPath() %>/inmobiliaria/caracteristicas.jsp?id_propiedad=<%= idPropFilaInm %>" class="btn-detalles">Características</a>
                </td>
            </tr>
<%
        }
        if (!hayPropInm) {
%>
            <tr><td colspan="6">Aún no has publicado propiedades.</td></tr>
<%
        }
        rsMisProp.close(); psMisProp.close();
    } catch (Exception exMisProp) {
%>
            <tr><td colspan="6" class="text-danger">Ocurrió un problema al consultar tus propiedades.</td></tr>
<%
    } finally {
        if (conPropInm != null) { try { conPropInm.close(); } catch (Exception ig) {} }
    }
%>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>