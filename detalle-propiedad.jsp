<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<%
    String idParametro = request.getParameter("id");
    Connection conexionDet = null;
    Integer idPropiedadValido = null;
    try {
        idPropiedadValido = Integer.parseInt(idParametro);
    } catch (Exception ePar) {
        idPropiedadValido = null;
    }
%>

<div class="container py-5">
<%
    if (idPropiedadValido == null) {
%>
    <p class="text-danger">Propiedad no válida. <a href="<%= request.getContextPath() %>/propiedades.jsp">Volver al catálogo</a></p>
<%
    } else {
        try {
            conexionDet = obtenerConexion();
            String sqlDetalle =
                "SELECT p.*, c.nombre AS nombre_ciudad, tp.nombre AS nombre_tipo, im.nombre_comercial " +
                "FROM propiedad p " +
                "JOIN ciudad c ON p.id_ciudad = c.id_ciudad " +
                "JOIN tipo_propiedad tp ON p.id_tipo = tp.id_tipo " +
                "JOIN inmobiliaria im ON p.id_inmobiliaria = im.id_inmobiliaria " +
                "WHERE p.id_propiedad = ?";
            PreparedStatement psDetalle = conexionDet.prepareStatement(sqlDetalle);
            psDetalle.setInt(1, idPropiedadValido);
            ResultSet rsDetalle = psDetalle.executeQuery();

            if (rsDetalle.next()) {
%>
    <a href="<%= request.getContextPath() %>/propiedades.jsp" class="btn-detalles mb-3 d-inline-block">&larr; Volver al catálogo</a>
    <h2 class="titulo-seccion"><%= rsDetalle.getString("titulo") %></h2>
    <p class="ciudad">📍 <%= rsDetalle.getString("nombre_ciudad") %> · <%= rsDetalle.getString("nombre_tipo") %></p>
    <p class="precio">$<%= String.format("%,.0f", rsDetalle.getDouble("precio")) %> <span>COP · <%= rsDetalle.getString("operacion").toUpperCase() %></span></p>
    <p class="caracteristicas"><%= rsDetalle.getInt("habitaciones") %> habitaciones · <%= rsDetalle.getInt("banos") %> baños · <%= rsDetalle.getDouble("area_m2") %> m²</p>
    <p>Publicado por: <%= rsDetalle.getString("nombre_comercial") %></p>
    <p><%= rsDetalle.getString("descripcion") %></p>

    <h5 class="mt-4">Imágenes</h5>
    <div class="row g-3 mb-4">
<%
                PreparedStatement psImagenes = conexionDet.prepareStatement(
                    "SELECT url_imagen FROM imagen_propiedad WHERE id_propiedad = ?");
                psImagenes.setInt(1, idPropiedadValido);
                ResultSet rsImagenes = psImagenes.executeQuery();
                boolean hayImagenes = false;
                while (rsImagenes.next()) {
                    hayImagenes = true;
%>
        <div class="col-md-4">
            <img src="<%= rsImagenes.getString("url_imagen") %>" class="img-fluid rounded" alt="Imagen propiedad">
        </div>
<%
                }
                if (!hayImagenes) {
%>
        <p>Sin imágenes registradas para esta propiedad.</p>
<%
                }
                rsImagenes.close(); psImagenes.close();
%>
    </div>

    <h5>Características</h5>
    <ul>
<%
                PreparedStatement psCaract = conexionDet.prepareStatement(
                    "SELECT ca.nombre FROM propiedad_caracteristica pc " +
                    "JOIN caracteristica ca ON pc.id_caracteristica = ca.id_caracteristica " +
                    "WHERE pc.id_propiedad = ?");
                psCaract.setInt(1, idPropiedadValido);
                ResultSet rsCaract = psCaract.executeQuery();
                boolean hayCaract = false;
                while (rsCaract.next()) {
                    hayCaract = true;
%>
        <li><%= rsCaract.getString("nombre") %></li>
<%
                }
                if (!hayCaract) {
%>
        <li>Sin características registradas.</li>
<%
                }
                rsCaract.close(); psCaract.close();
%>
    </ul>

    <div class="alert alert-secondary mt-4">
        Para agendar una visita o marcar como favorito, necesitas <a href="<%= request.getContextPath() %>/login.jsp">iniciar sesión</a>.
    </div>
<%
            } else {
%>
    <p class="text-danger">La propiedad solicitada no existe.</p>
<%
            }
            rsDetalle.close(); psDetalle.close();
        } catch (Exception exDet) {
%>
    <p class="text-danger">Ocurrió un problema al consultar la propiedad.</p>
<%
        } finally {
            if (conexionDet != null) { try { conexionDet.close(); } catch (Exception ig) {} }
        }
    }
%>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
