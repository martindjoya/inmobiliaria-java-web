<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "CLIENTE";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%
    int idUsuarioFav = (Integer) session.getAttribute("idUsuario");

    if ("quitar".equals(request.getParameter("accion")) && "POST".equalsIgnoreCase(request.getMethod())) {
        String idPropQuitar = request.getParameter("id_propiedad");
        Connection conQuitar = null;
        try {
            conQuitar = obtenerConexion();
            PreparedStatement psQuitar = conQuitar.prepareStatement(
                "DELETE FROM favorito WHERE id_usuario = ? AND id_propiedad = ?");
            psQuitar.setInt(1, idUsuarioFav);
            psQuitar.setInt(2, Integer.parseInt(idPropQuitar));
            psQuitar.executeUpdate();
            psQuitar.close();
        } catch (Exception exQuitar) {
        } finally {
            if (conQuitar != null) { try { conQuitar.close(); } catch (Exception ig) {} }
        }
        response.sendRedirect(request.getContextPath() + "/cliente/favoritos.jsp");
        return;
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Mis favoritos</h2>
    <div class="row g-4">
<%
    Connection conFavoritos = null;
    try {
        conFavoritos = obtenerConexion();
        String sqlFavoritos =
            "SELECT p.id_propiedad, p.titulo, p.precio, p.operacion, p.habitaciones, p.banos, " +
            "c.nombre AS nombre_ciudad, i.url_imagen " +
            "FROM favorito f " +
            "JOIN propiedad p ON f.id_propiedad = p.id_propiedad " +
            "JOIN ciudad c ON p.id_ciudad = c.id_ciudad " +
            "LEFT JOIN imagen_propiedad i ON i.id_propiedad = p.id_propiedad AND i.es_principal = 1 " +
            "WHERE f.id_usuario = ? " +
            "ORDER BY f.fecha_agregado DESC";
        PreparedStatement psFavoritos = conFavoritos.prepareStatement(sqlFavoritos);
        psFavoritos.setInt(1, idUsuarioFav);
        ResultSet rsFavoritos = psFavoritos.executeQuery();
        boolean hayFavoritos = false;
        while (rsFavoritos.next()) {
            hayFavoritos = true;
            String urlImgFav = rsFavoritos.getString("url_imagen");
            if (urlImgFav == null || urlImgFav.isEmpty()) {
                urlImgFav = "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=600";
            }
%>
        <div class="col-md-4">
            <div class="tarjeta-propiedad">
                <img src="<%= urlImgFav %>" alt="Propiedad">
                <div class="tarjeta-body">
                    <h5><%= rsFavoritos.getString("titulo") %></h5>
                    <p class="ciudad">📍 <%= rsFavoritos.getString("nombre_ciudad") %></p>
                    <p class="precio">$<%= String.format("%,.0f", rsFavoritos.getDouble("precio")) %> <span>COP</span></p>
                    <a href="<%= request.getContextPath() %>/detalle-propiedad.jsp?id=<%= rsFavoritos.getInt("id_propiedad") %>" class="btn-detalles">Ver detalles</a>
                    <form method="post" action="<%= request.getContextPath() %>/cliente/favoritos.jsp" class="d-inline">
                        <input type="hidden" name="accion" value="quitar">
                        <input type="hidden" name="id_propiedad" value="<%= rsFavoritos.getInt("id_propiedad") %>">
                        <button type="submit" class="btn-detalles">Quitar</button>
                    </form>
                </div>
            </div>
        </div>
<%
        }
        if (!hayFavoritos) {
%>
        <p class="text-center">Aún no tienes propiedades favoritas.</p>
<%
        }
        rsFavoritos.close(); psFavoritos.close();
    } catch (Exception exFavoritos) {
%>
        <p class="text-center text-danger">Ocurrió un problema al consultar tus favoritos.</p>
<%
    } finally {
        if (conFavoritos != null) { try { conFavoritos.close(); } catch (Exception ig) {} }
    }
%>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>