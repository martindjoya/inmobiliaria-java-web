<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<%
    String idParametro = request.getParameter("id");
    Object idUsuarioDetalle = session.getAttribute("idUsuario");
    String rolUsuarioDetalle = (String) session.getAttribute("rolUsuario");
    String mensajeDetalle = null;
    Connection conexionDet = null;
    Integer idPropiedadValido = null;
    try { idPropiedadValido = Integer.parseInt(idParametro); } catch (Exception ignorado) { }

    if (idPropiedadValido != null && "favorito".equals(request.getParameter("accion"))
            && "POST".equalsIgnoreCase(request.getMethod())
            && idUsuarioDetalle != null && "Cliente".equalsIgnoreCase(rolUsuarioDetalle)) {
        try {
            conexionDet = obtenerConexion();
            PreparedStatement psFavorito = conexionDet.prepareStatement(
                "INSERT IGNORE INTO favorito (id_usuario, id_propiedad) VALUES (?, ?)");
            psFavorito.setInt(1, (Integer) idUsuarioDetalle);
            psFavorito.setInt(2, idPropiedadValido);
            psFavorito.executeUpdate();
            psFavorito.close();
            response.sendRedirect(request.getContextPath() + "/cliente/favoritos.jsp");
            return;
        } catch (Exception exFavorito) {
            mensajeDetalle = "No se pudo guardar la propiedad en favoritos.";
        } finally {
            if (conexionDet != null) { try { conexionDet.close(); } catch (Exception ignorado) { } }
            conexionDet = null;
        }
    }
%>

<div class="container py-5">
<%
    if (idPropiedadValido == null) {
%>
    <p class="text-danger">Propiedad no valida. <a href="<%= request.getContextPath() %>/index.jsp#propiedades">Volver a la busqueda</a></p>
<%
    } else {
        try {
            conexionDet = obtenerConexion();
            PreparedStatement psDetalle = conexionDet.prepareStatement(
                "SELECT p.*, c.nombre AS nombre_ciudad, tp.nombre AS nombre_tipo, im.nombre_comercial " +
                "FROM propiedad p JOIN ciudad c ON p.id_ciudad = c.id_ciudad " +
                "JOIN tipo_propiedad tp ON p.id_tipo = tp.id_tipo " +
                "JOIN inmobiliaria im ON p.id_inmobiliaria = im.id_inmobiliaria " +
                "WHERE p.id_propiedad = ?");
            psDetalle.setInt(1, idPropiedadValido);
            ResultSet rsDetalle = psDetalle.executeQuery();
            if (rsDetalle.next()) {
%>
    <a href="<%= request.getContextPath() %>/index.jsp#propiedades" class="btn-detalles mb-3 d-inline-block">&larr; Volver a la busqueda</a>
    <h1 class="titulo-seccion"><%= rsDetalle.getString("titulo") %></h1>
    <p class="ciudad"><%= rsDetalle.getString("nombre_ciudad") %> · <%= rsDetalle.getString("nombre_tipo") %></p>
    <p class="precio">$<%= String.format("%,.0f", rsDetalle.getDouble("precio")) %> <span>COP · <%= rsDetalle.getString("operacion").toUpperCase() %></span></p>
    <p class="caracteristicas"><%= rsDetalle.getInt("habitaciones") %> habitaciones · <%= rsDetalle.getInt("banos") %> baños · <%= rsDetalle.getDouble("area_m2") %> m²</p>
    <p>Publicado por: <%= rsDetalle.getString("nombre_comercial") %></p>
    <p><%= rsDetalle.getString("descripcion") %></p>

    <h2 class="h5 mt-4">Imágenes</h2>
    <div class="row g-3 mb-4">
<%
                PreparedStatement psImagenes = conexionDet.prepareStatement("SELECT url_imagen FROM imagen_propiedad WHERE id_propiedad = ?");
                psImagenes.setInt(1, idPropiedadValido);
                ResultSet rsImagenes = psImagenes.executeQuery();
                boolean hayImagenes = false;
                while (rsImagenes.next()) {
                    hayImagenes = true;
%>
        <div class="col-md-4"><img src="<%= rsImagenes.getString("url_imagen") %>" class="img-fluid rounded" alt="Imagen de la propiedad"></div>
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

    <h2 class="h5">Características</h2>
    <ul>
<%
                PreparedStatement psCaract = conexionDet.prepareStatement(
                    "SELECT ca.nombre FROM propiedad_caracteristica pc JOIN caracteristica ca " +
                    "ON pc.id_caracteristica = ca.id_caracteristica WHERE pc.id_propiedad = ?");
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

    <% if (mensajeDetalle != null) { %><div class="alert alert-danger mt-4"><%= mensajeDetalle %></div><% } %>
    <div class="d-flex flex-wrap gap-2 mt-4">
<%
                if (idUsuarioDetalle != null && "Cliente".equalsIgnoreCase(rolUsuarioDetalle)) {
%>
        <form method="post" action="<%= request.getContextPath() %>/propiedades.jsp?id=<%= idPropiedadValido %>">
            <input type="hidden" name="accion" value="favorito">
            <button type="submit" class="btn-explorar">Guardar en favoritos</button>
        </form>
        <a href="<%= request.getContextPath() %>/cliente/mis-citas.jsp?id_propiedad=<%= idPropiedadValido %>" class="btn-detalles">Agendar visita</a>
        <a href="<%= request.getContextPath() %>/cliente/mis-solicitudes.jsp?id_propiedad=<%= idPropiedadValido %>" class="btn-detalles">Crear solicitud</a>
<%
                } else if (idUsuarioDetalle == null) {
%>
        <a href="<%= request.getContextPath() %>/login.jsp" class="btn-explorar">Inicia sesión para interactuar</a>
<%
                }
%>
    </div>
<%
            } else {
%>
    <p class="text-danger">La propiedad solicitada no existe.</p>
<%
            }
            rsDetalle.close(); psDetalle.close();
        } catch (Exception exDetalle) {
%>
    <p class="text-danger">Ocurrió un problema al consultar la propiedad.</p>
<%
        } finally {
            if (conexionDet != null) { try { conexionDet.close(); } catch (Exception ignorado) { } }
        }
    }
%>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
