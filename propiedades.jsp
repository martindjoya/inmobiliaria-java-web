<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <div class="mb-4">
        <h1 class="titulo-seccion mb-1">Propiedades disponibles</h1>
        <p class="subtitulo-registro mb-0">Encuentra el espacio adecuado para ti.</p>
    </div>
    <div class="row g-4">
<%
    Connection conexionPropiedades = null;
    try {
        conexionPropiedades = obtenerConexion();
        String sqlPropiedades =
            "SELECT p.id_propiedad, p.titulo, p.precio, p.operacion, p.habitaciones, p.banos, p.area_m2, " +
            "c.nombre AS nombre_ciudad, tp.nombre AS nombre_tipo, COALESCE(ip.url_imagen, '') AS url_imagen " +
            "FROM propiedad p " +
            "JOIN ciudad c ON p.id_ciudad = c.id_ciudad " +
            "JOIN tipo_propiedad tp ON p.id_tipo = tp.id_tipo " +
            "LEFT JOIN imagen_propiedad ip ON ip.id_imagen = (" +
            "SELECT MIN(ip2.id_imagen) FROM imagen_propiedad ip2 WHERE ip2.id_propiedad = p.id_propiedad) " +
            "WHERE p.estado = 'disponible' ORDER BY p.fecha_publicacion DESC";
        PreparedStatement psPropiedades = conexionPropiedades.prepareStatement(sqlPropiedades);
        ResultSet rsPropiedades = psPropiedades.executeQuery();
        boolean hayPropiedades = false;
        while (rsPropiedades.next()) {
            hayPropiedades = true;
            int idPropiedad = rsPropiedades.getInt("id_propiedad");
            String urlImagen = rsPropiedades.getString("url_imagen");
            if (urlImagen == null || urlImagen.trim().isEmpty()) {
                urlImagen = "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=700";
            }
%>
        <div class="col-md-6 col-lg-4">
            <article class="tarjeta-propiedad h-100">
                <img src="<%= urlImagen %>" alt="<%= rsPropiedades.getString("titulo") %>" class="w-100">
                <div class="tarjeta-body">
                    <span class="etiqueta"><%= rsPropiedades.getString("nombre_tipo") %></span>
                    <h2 class="h5 mt-2"><%= rsPropiedades.getString("titulo") %></h2>
                    <p class="ciudad mb-2"><%= rsPropiedades.getString("nombre_ciudad") %> · <%= rsPropiedades.getString("operacion") %></p>
                    <p class="caracteristicas"><%= rsPropiedades.getInt("habitaciones") %> habitaciones · <%= rsPropiedades.getInt("banos") %> baños · <%= rsPropiedades.getDouble("area_m2") %> m²</p>
                    <p class="precio">$<%= String.format("%,.0f", rsPropiedades.getDouble("precio")) %> COP</p>
                    <a href="<%= request.getContextPath() %>/detalle-propiedad.jsp?id=<%= idPropiedad %>" class="btn-detalles">Ver detalles</a>
                </div>
            </article>
        </div>
<%
        }
        if (!hayPropiedades) {
%>
        <div class="col-12"><div class="alert alert-secondary">No hay propiedades disponibles en este momento.</div></div>
<%
        }
        rsPropiedades.close();
        psPropiedades.close();
    } catch (Exception exPropiedades) {
%>
        <div class="col-12"><div class="alert alert-danger">No se pudieron cargar las propiedades. Intenta nuevamente más tarde.</div></div>
<%
    } finally {
        if (conexionPropiedades != null) {
            try { conexionPropiedades.close(); } catch (Exception ignorado) { }
        }
    }
%>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
