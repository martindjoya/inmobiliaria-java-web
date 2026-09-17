<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <div class="mb-4">
        <h1 class="titulo-seccion mb-1">Propiedades disponibles</h1>
        <p class="subtitulo-registro mb-0">Encuentra el espacio adecuado para ti.</p>
    </div>

<%
    String filtroCiudad = request.getParameter("ciudad");
    String filtroTipo = request.getParameter("tipo");
    String filtroOperacion = request.getParameter("operacion");
    String filtroCaracteristica = request.getParameter("caracteristica");
    String filtroPrecioMin = request.getParameter("precio_min");
    String filtroPrecioMax = request.getParameter("precio_max");
    Integer idCiudadFiltro = null;
    Integer idTipoFiltro = null;
    Integer idCaracteristicaFiltro = null;
    Double precioMinFiltro = null;
    Double precioMaxFiltro = null;
    try { if (filtroCiudad != null && !filtroCiudad.isEmpty()) idCiudadFiltro = Integer.valueOf(filtroCiudad); } catch (NumberFormatException ignorado) { }
    try { if (filtroTipo != null && !filtroTipo.isEmpty()) idTipoFiltro = Integer.valueOf(filtroTipo); } catch (NumberFormatException ignorado) { }
    try { if (filtroCaracteristica != null && !filtroCaracteristica.isEmpty()) idCaracteristicaFiltro = Integer.valueOf(filtroCaracteristica); } catch (NumberFormatException ignorado) { }
    try { if (filtroPrecioMin != null && !filtroPrecioMin.isEmpty()) precioMinFiltro = Double.valueOf(filtroPrecioMin); } catch (NumberFormatException ignorado) { }
    try { if (filtroPrecioMax != null && !filtroPrecioMax.isEmpty()) precioMaxFiltro = Double.valueOf(filtroPrecioMax); } catch (NumberFormatException ignorado) { }
%>
    <form method="get" action="<%= request.getContextPath() %>/propiedades.jsp" class="buscador row g-3 align-items-end mb-5">
        <div class="col-md-3">
            <label class="form-label" for="ciudad">Ciudad</label>
            <select id="ciudad" name="ciudad" class="form-select">
                <option value="">Todas las ciudades</option>
<%
    Connection conexionFiltros = null;
    try {
        conexionFiltros = obtenerConexion();
        PreparedStatement psCiudades = conexionFiltros.prepareStatement("SELECT id_ciudad, nombre FROM ciudad ORDER BY nombre");
        ResultSet rsCiudades = psCiudades.executeQuery();
        while (rsCiudades.next()) {
            String seleccionCiudad = rsCiudades.getInt("id_ciudad") == (idCiudadFiltro == null ? -1 : idCiudadFiltro) ? "selected" : "";
%>
                <option value="<%= rsCiudades.getInt("id_ciudad") %>" <%= seleccionCiudad %>><%= rsCiudades.getString("nombre") %></option>
<%
        }
        rsCiudades.close();
        psCiudades.close();
%>
            </select>
        </div>
        <div class="col-md-3">
            <label class="form-label" for="tipo">Tipo de propiedad</label>
            <select id="tipo" name="tipo" class="form-select">
                <option value="">Todos los tipos</option>
<%
        PreparedStatement psTipos = conexionFiltros.prepareStatement("SELECT id_tipo, nombre FROM tipo_propiedad ORDER BY nombre");
        ResultSet rsTipos = psTipos.executeQuery();
        while (rsTipos.next()) {
            String seleccionTipo = rsTipos.getInt("id_tipo") == (idTipoFiltro == null ? -1 : idTipoFiltro) ? "selected" : "";
%>
                <option value="<%= rsTipos.getInt("id_tipo") %>" <%= seleccionTipo %>><%= rsTipos.getString("nombre") %></option>
<%
        }
        rsTipos.close();
        psTipos.close();
%>
            </select>
        </div>
        <div class="col-md-2">
            <label class="form-label" for="operacion">Operacion</label>
            <select id="operacion" name="operacion" class="form-select">
                <option value="">Todas</option>
                <option value="venta" <%= "venta".equals(filtroOperacion) ? "selected" : "" %>>Venta</option>
                <option value="alquiler" <%= "alquiler".equals(filtroOperacion) ? "selected" : "" %>>Alquiler</option>
            </select>
        </div>
        <div class="col-md-2">
            <label class="form-label" for="caracteristica">Caracteristica</label>
            <select id="caracteristica" name="caracteristica" class="form-select">
                <option value="">Todas</option>
<%
        PreparedStatement psCaracteristicas = conexionFiltros.prepareStatement("SELECT id_caracteristica, nombre FROM caracteristica ORDER BY nombre");
        ResultSet rsCaracteristicas = psCaracteristicas.executeQuery();
        while (rsCaracteristicas.next()) {
            String seleccionCaracteristica = rsCaracteristicas.getInt("id_caracteristica") == (idCaracteristicaFiltro == null ? -1 : idCaracteristicaFiltro) ? "selected" : "";
%>
                <option value="<%= rsCaracteristicas.getInt("id_caracteristica") %>" <%= seleccionCaracteristica %>><%= rsCaracteristicas.getString("nombre") %></option>
<%
        }
        rsCaracteristicas.close();
        psCaracteristicas.close();
    } catch (Exception ignorado) {
%>
                <option value="">No disponible</option>
<%
    } finally {
        if (conexionFiltros != null) { try { conexionFiltros.close(); } catch (Exception ignorado) { } }
    }
%>
            </select>
        </div>
        <div class="col-md-2">
            <label class="form-label" for="precio_min">Precio minimo</label>
            <input id="precio_min" name="precio_min" type="number" min="0" step="0.01" class="form-control" value="<%= filtroPrecioMin == null ? "" : filtroPrecioMin %>">
        </div>
        <div class="col-md-2">
            <label class="form-label" for="precio_max">Precio maximo</label>
            <input id="precio_max" name="precio_max" type="number" min="0" step="0.01" class="form-control" value="<%= filtroPrecioMax == null ? "" : filtroPrecioMax %>">
        </div>
        <div class="col-md-2">
            <button type="submit" class="btn-explorar w-100">Buscar</button>
        </div>
        <div class="col-md-2">
            <a href="<%= request.getContextPath() %>/propiedades.jsp" class="btn-detalles d-block text-center">Limpiar</a>
        </div>
    </form>
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
            "WHERE p.estado = 'disponible'";
        java.util.List<String> condicionesPropiedades = new java.util.ArrayList<String>();
        java.util.List<Object> parametrosPropiedades = new java.util.ArrayList<Object>();
        if (idCiudadFiltro != null) { condicionesPropiedades.add("p.id_ciudad = ?"); parametrosPropiedades.add(idCiudadFiltro); }
        if (idTipoFiltro != null) { condicionesPropiedades.add("p.id_tipo = ?"); parametrosPropiedades.add(idTipoFiltro); }
        if ("venta".equals(filtroOperacion) || "alquiler".equals(filtroOperacion)) { condicionesPropiedades.add("p.operacion = ?"); parametrosPropiedades.add(filtroOperacion); }
        if (precioMinFiltro != null) { condicionesPropiedades.add("p.precio >= ?"); parametrosPropiedades.add(precioMinFiltro); }
        if (precioMaxFiltro != null) { condicionesPropiedades.add("p.precio <= ?"); parametrosPropiedades.add(precioMaxFiltro); }
        if (idCaracteristicaFiltro != null) {
            condicionesPropiedades.add("EXISTS (SELECT 1 FROM propiedad_caracteristica pcf WHERE pcf.id_propiedad = p.id_propiedad AND pcf.id_caracteristica = ?)");
            parametrosPropiedades.add(idCaracteristicaFiltro);
        }
        if (!condicionesPropiedades.isEmpty()) sqlPropiedades += " AND " + String.join(" AND ", condicionesPropiedades);
        sqlPropiedades += " ORDER BY p.fecha_publicacion DESC";
        PreparedStatement psPropiedades = conexionPropiedades.prepareStatement(sqlPropiedades);
        for (int indiceParametro = 0; indiceParametro < parametrosPropiedades.size(); indiceParametro++) {
            psPropiedades.setObject(indiceParametro + 1, parametrosPropiedades.get(indiceParametro));
        }
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
