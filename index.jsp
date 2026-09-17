<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%
    Object idUsuario = session.getAttribute("idUsuario");
    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
    String filtroCiudad = request.getParameter("ciudad");
    String filtroTipo = request.getParameter("tipo");
    String filtroOperacion = request.getParameter("operacion");
    String filtroCaracteristica = request.getParameter("caracteristica");
    String filtroPrecioMin = request.getParameter("precio_min");
    String filtroPrecioMax = request.getParameter("precio_max");
    Integer idCiudadFiltro = null, idTipoFiltro = null, idCaracteristicaFiltro = null;
    Double precioMinFiltro = null, precioMaxFiltro = null;
    try { if (filtroCiudad != null && !filtroCiudad.isEmpty()) idCiudadFiltro = Integer.valueOf(filtroCiudad); } catch (NumberFormatException ignorado) { }
    try { if (filtroTipo != null && !filtroTipo.isEmpty()) idTipoFiltro = Integer.valueOf(filtroTipo); } catch (NumberFormatException ignorado) { }
    try { if (filtroCaracteristica != null && !filtroCaracteristica.isEmpty()) idCaracteristicaFiltro = Integer.valueOf(filtroCaracteristica); } catch (NumberFormatException ignorado) { }
    try { if (filtroPrecioMin != null && !filtroPrecioMin.isEmpty()) precioMinFiltro = Double.valueOf(filtroPrecioMin); } catch (NumberFormatException ignorado) { }
    try { if (filtroPrecioMax != null && !filtroPrecioMax.isEmpty()) precioMaxFiltro = Double.valueOf(filtroPrecioMax); } catch (NumberFormatException ignorado) { }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dream House S.A.</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>

    <!-- NAVBAR -->
    <nav class="navbar navbar-expand-lg navbar-dh px-4">
        <a class="navbar-brand marca" href="index.jsp">Dream House S.A.</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menuPrincipal">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="menuPrincipal">
            <ul class="navbar-nav align-items-lg-center gap-lg-2">
                <li class="nav-item"><a class="nav-link" href="index.jsp">Inicio</a></li>
                <li class="nav-item"><a class="nav-link" href="index.jsp">Propiedades</a></li>
                <li class="nav-item"><a class="nav-link" href="nosotros.jsp">Nosotros</a></li>
                <li class="nav-item"><a class="nav-link" href="contacto.jsp">Contacto</a></li>
                <% if (idUsuario == null) { %>
                    <li class="nav-item">
                        <a class="btn-login ms-lg-3" href="login.jsp">Iniciar sesión</a>
                    </li>
                <% } else { %>
                    <li class="nav-item"><span class="nav-link">Hola, <%= nombreUsuario %> (<%= rolUsuario %>)</span></li>
                    <li class="nav-item"><a class="btn-login ms-lg-3" href="logout.jsp">Cerrar sesion</a></li>
                <% } %>
            </ul>
        </div>
    </nav>

    <!-- HERO -->
    <section id="inicio" class="hero d-flex align-items-center">
        <div class="container text-center text-white">
            <h1 class="hero-titulo">Encuentra un lugar que se sienta como hogar</h1>
            <p class="hero-subtitulo">Dream House S.A. — inmobiliaria boutique con propiedades seleccionadas para ti</p>
            <a href="#propiedades" class="btn-explorar">Explorar propiedades</a>
        </div>
    </section>

    <!-- BUSQUEDA PRINCIPAL -->
    <section class="buscador-wrapper">
        <div class="container">
            <form method="get" action="index.jsp#propiedades" class="buscador row g-3 align-items-end justify-content-center">
                <div class="col-md-3">
                    <label class="form-label" for="tipo">Tipo de propiedad</label>
                    <select id="tipo" name="tipo" class="form-select">
                        <option value="">Todos los tipos</option>
<%
    Connection conexionFiltrosIndex = null;
    try {
        conexionFiltrosIndex = obtenerConexion();
        PreparedStatement psTiposIndex = conexionFiltrosIndex.prepareStatement("SELECT id_tipo, nombre FROM tipo_propiedad ORDER BY nombre");
        ResultSet rsTiposIndex = psTiposIndex.executeQuery();
        while (rsTiposIndex.next()) {
%>
                        <option value="<%= rsTiposIndex.getInt("id_tipo") %>" <%= rsTiposIndex.getInt("id_tipo") == (idTipoFiltro == null ? -1 : idTipoFiltro) ? "selected" : "" %>><%= rsTiposIndex.getString("nombre") %></option>
<%
        }
        rsTiposIndex.close(); psTiposIndex.close();
%>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="ciudad">Ciudad</label>
                    <select id="ciudad" name="ciudad" class="form-select">
                        <option value="">Todas las ciudades</option>
<%
        PreparedStatement psCiudadesIndex = conexionFiltrosIndex.prepareStatement("SELECT id_ciudad, nombre FROM ciudad ORDER BY nombre");
        ResultSet rsCiudadesIndex = psCiudadesIndex.executeQuery();
        while (rsCiudadesIndex.next()) {
%>
                        <option value="<%= rsCiudadesIndex.getInt("id_ciudad") %>" <%= rsCiudadesIndex.getInt("id_ciudad") == (idCiudadFiltro == null ? -1 : idCiudadFiltro) ? "selected" : "" %>><%= rsCiudadesIndex.getString("nombre") %></option>
<%
        }
        rsCiudadesIndex.close(); psCiudadesIndex.close();
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
        PreparedStatement psCaracteristicasIndex = conexionFiltrosIndex.prepareStatement("SELECT id_caracteristica, nombre FROM caracteristica ORDER BY nombre");
        ResultSet rsCaracteristicasIndex = psCaracteristicasIndex.executeQuery();
        while (rsCaracteristicasIndex.next()) {
%>
                        <option value="<%= rsCaracteristicasIndex.getInt("id_caracteristica") %>" <%= rsCaracteristicasIndex.getInt("id_caracteristica") == (idCaracteristicaFiltro == null ? -1 : idCaracteristicaFiltro) ? "selected" : "" %>><%= rsCaracteristicasIndex.getString("nombre") %></option>
<%
        }
        rsCaracteristicasIndex.close(); psCaracteristicasIndex.close();
    } catch (Exception ignorado) {
    } finally {
        if (conexionFiltrosIndex != null) { try { conexionFiltrosIndex.close(); } catch (Exception ignorado) { } }
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
                    <button type="submit" class="btn-buscar w-100">Buscar</button>
                </div>
                <div class="col-md-2">
                    <a href="index.jsp#propiedades" class="btn-detalles d-block text-center">Limpiar</a>
                </div>
            </form>
        </div>
    </section>

    <!-- RESULTADOS -->
    <section id="propiedades" class="container py-5">
        <h2 class="titulo-seccion text-center mb-5">Propiedades disponibles</h2>
        <div class="row g-4">
<%
    Connection conexionResultadosIndex = null;
    try {
        conexionResultadosIndex = obtenerConexion();
        String sqlResultadosIndex =
            "SELECT p.id_propiedad, p.titulo, p.precio, p.operacion, p.habitaciones, p.banos, p.area_m2, " +
            "c.nombre AS nombre_ciudad, tp.nombre AS nombre_tipo, COALESCE(ip.url_imagen, '') AS url_imagen " +
            "FROM propiedad p JOIN ciudad c ON p.id_ciudad = c.id_ciudad " +
            "JOIN tipo_propiedad tp ON p.id_tipo = tp.id_tipo " +
            "LEFT JOIN imagen_propiedad ip ON ip.id_imagen = (SELECT MIN(ip2.id_imagen) FROM imagen_propiedad ip2 WHERE ip2.id_propiedad = p.id_propiedad) " +
            "WHERE p.estado = 'disponible'";
        java.util.List<String> condicionesIndex = new java.util.ArrayList<String>();
        java.util.List<Object> parametrosIndex = new java.util.ArrayList<Object>();
        if (idCiudadFiltro != null) { condicionesIndex.add("p.id_ciudad = ?"); parametrosIndex.add(idCiudadFiltro); }
        if (idTipoFiltro != null) { condicionesIndex.add("p.id_tipo = ?"); parametrosIndex.add(idTipoFiltro); }
        if ("venta".equals(filtroOperacion) || "alquiler".equals(filtroOperacion)) { condicionesIndex.add("p.operacion = ?"); parametrosIndex.add(filtroOperacion); }
        if (precioMinFiltro != null) { condicionesIndex.add("p.precio >= ?"); parametrosIndex.add(precioMinFiltro); }
        if (precioMaxFiltro != null) { condicionesIndex.add("p.precio <= ?"); parametrosIndex.add(precioMaxFiltro); }
        if (idCaracteristicaFiltro != null) { condicionesIndex.add("EXISTS (SELECT 1 FROM propiedad_caracteristica pcf WHERE pcf.id_propiedad = p.id_propiedad AND pcf.id_caracteristica = ?)"); parametrosIndex.add(idCaracteristicaFiltro); }
        if (!condicionesIndex.isEmpty()) sqlResultadosIndex += " AND " + String.join(" AND ", condicionesIndex);
        sqlResultadosIndex += " ORDER BY p.fecha_publicacion DESC";
        PreparedStatement psResultadosIndex = conexionResultadosIndex.prepareStatement(sqlResultadosIndex);
        for (int i = 0; i < parametrosIndex.size(); i++) psResultadosIndex.setObject(i + 1, parametrosIndex.get(i));
        ResultSet rsResultadosIndex = psResultadosIndex.executeQuery();
        boolean hayResultadosIndex = false;
        while (rsResultadosIndex.next()) {
            hayResultadosIndex = true;
            String imagenIndex = rsResultadosIndex.getString("url_imagen");
            if (imagenIndex == null || imagenIndex.trim().isEmpty()) imagenIndex = "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=700";
%>
            <div class="col-md-6 col-lg-4">
                <article class="tarjeta-propiedad h-100">
                    <img src="<%= imagenIndex %>" alt="<%= rsResultadosIndex.getString("titulo") %>" class="w-100">
                    <div class="tarjeta-body">
                        <span class="etiqueta"><%= rsResultadosIndex.getString("nombre_tipo") %></span>
                        <h3 class="h5 mt-2"><%= rsResultadosIndex.getString("titulo") %></h3>
                        <p class="ciudad mb-2"><%= rsResultadosIndex.getString("nombre_ciudad") %> · <%= rsResultadosIndex.getString("operacion") %></p>
                        <p class="caracteristicas"><%= rsResultadosIndex.getInt("habitaciones") %> habitaciones · <%= rsResultadosIndex.getInt("banos") %> baños · <%= rsResultadosIndex.getDouble("area_m2") %> m²</p>
                        <p class="precio">$<%= String.format("%,.0f", rsResultadosIndex.getDouble("precio")) %> COP</p>
                        <a href="<%= request.getContextPath() %>/propiedades.jsp?id=<%= rsResultadosIndex.getInt("id_propiedad") %>" class="btn-detalles">Ver detalle</a>
                    </div>
                </article>
            </div>
<%
        }
        if (!hayResultadosIndex) {
%>
            <div class="col-12"><div class="alert alert-secondary">No hay propiedades que coincidan con la busqueda.</div></div>
<%
        }
        rsResultadosIndex.close(); psResultadosIndex.close();
    } catch (Exception ignorado) {
%>
            <div class="col-12"><div class="alert alert-danger">No se pudieron cargar las propiedades.</div></div>
<%
    } finally {
        if (conexionResultadosIndex != null) { try { conexionResultadosIndex.close(); } catch (Exception ignorado) { } }
    }
%>
        </div>
    </section>

    <!-- SOBRE DREAM HOUSE -->
    <section id="nosotros" class="seccion-nosotros py-5">
        <div class="container text-center">
            <h2 class="titulo-seccion mb-4">Sobre Dream House S.A.</h2>
            <p class="texto-nosotros mx-auto">
                En Dream House S.A. acompañamos a cada cliente en la búsqueda de un espacio que se ajuste
                a su estilo de vida. Combinamos atención cercana con una selección cuidada de propiedades,
                ofreciendo un proceso simple, transparente y confiable.
            </p>
        </div>
    </section>

    <!-- LLAMADO A LA ACCIÓN -->
    <section class="cta text-center">
        <div class="container">
            <h2>¿Listo para encontrar tu próximo hogar?</h2>
            <p>Explora nuestras propiedades y encuentra tu próximo hogar.</p>
            <% if (idUsuario != null && "Administrador".equalsIgnoreCase(rolUsuario)) { %>
                <a href="admin/inicio.jsp" class="btn-cta btn-cta-outline">Ir al panel</a>
            <% } else if (idUsuario != null && "Inmobiliaria".equalsIgnoreCase(rolUsuario)) { %>
                <a href="inmobiliaria/inicio.jsp" class="btn-cta btn-cta-outline">Ir al panel</a>
            <% } else if (idUsuario != null) { %>
                <a href="cliente/panel.jsp" class="btn-cta btn-cta-outline">Ir a mi panel</a>
            <% } %>
        </div>
    </section>

    <!-- FOOTER -->
    <footer id="contacto" class="footer-dh py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <h5>Dream House S.A.</h5>
                    <p>Inmobiliaria boutique dedicada a encontrar el hogar ideal para cada cliente.</p>
                </div>
                <div class="col-md-4 mb-3">
                    <h5>Enlaces</h5>
                    <ul class="lista-footer">
                        <li><a href="index.jsp">Inicio</a></li>
                        <li><a href="index.jsp">Propiedades</a></li>
                        <li><a href="nosotros.jsp">Nosotros</a></li>
                    </ul>
                </div>
                <div class="col-md-4 mb-3">
                    <h5>Contacto</h5>
                    <p>contacto@dreamhouse.ejemplo<br>+57 300 000 0000<br>Bucaramanga, Colombia</p>
                </div>
            </div>
            <hr>
            <p class="text-center mb-0">&copy; 2026 Dream House S.A. — Todos los derechos reservados.</p>
        </div>
    </footer>

</body>
</html>
