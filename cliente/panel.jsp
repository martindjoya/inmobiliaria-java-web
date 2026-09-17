<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "CLIENTE";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>
<%
    int idUsuarioCliente = (Integer) session.getAttribute("idUsuario");
    int totalFavoritos = 0, totalCitasPendientes = 0, totalSolicitudesPendientes = 0;
    Connection conPanelCliente = null;
    try {
        conPanelCliente = obtenerConexion();
        PreparedStatement psFav = conPanelCliente.prepareStatement("SELECT COUNT(*) AS total FROM favorito WHERE id_usuario = ?");
        psFav.setInt(1, idUsuarioCliente);
        ResultSet rsFav = psFav.executeQuery();
        if (rsFav.next()) totalFavoritos = rsFav.getInt("total");
        rsFav.close(); psFav.close();

        PreparedStatement psCitas = conPanelCliente.prepareStatement("SELECT COUNT(*) AS total FROM cita WHERE id_usuario = ? AND estado = 'pendiente'");
        psCitas.setInt(1, idUsuarioCliente);
        ResultSet rsCitas = psCitas.executeQuery();
        if (rsCitas.next()) totalCitasPendientes = rsCitas.getInt("total");
        rsCitas.close(); psCitas.close();

        PreparedStatement psSolicitudes = conPanelCliente.prepareStatement("SELECT COUNT(*) AS total FROM solicitud WHERE id_usuario = ? AND estado = 'pendiente'");
        psSolicitudes.setInt(1, idUsuarioCliente);
        ResultSet rsSolicitudes = psSolicitudes.executeQuery();
        if (rsSolicitudes.next()) totalSolicitudesPendientes = rsSolicitudes.getInt("total");
        rsSolicitudes.close(); psSolicitudes.close();
    } catch (Exception ignorado) {
    } finally {
        if (conPanelCliente != null) { try { conPanelCliente.close(); } catch (Exception ignorado) { } }
    }
%>

<div class="container py-5">
    <h1 class="titulo-seccion mb-1">Hola, <%= session.getAttribute("nombreUsuario") %></h1>
    <p class="subtitulo-registro mb-4">Resumen de tus interacciones en Dream House S.A.</p>

    <div class="row g-4 mb-4">
        <div class="col-md-4"><div class="tarjeta-propiedad tarjeta-body text-center"><h2><%= totalFavoritos %></h2><p class="mb-0">Propiedades favoritas</p></div></div>
        <div class="col-md-4"><div class="tarjeta-propiedad tarjeta-body text-center"><h2><%= totalCitasPendientes %></h2><p class="mb-0">Citas pendientes</p></div></div>
        <div class="col-md-4"><div class="tarjeta-propiedad tarjeta-body text-center"><h2><%= totalSolicitudesPendientes %></h2><p class="mb-0">Solicitudes pendientes</p></div></div>
    </div>

    <div class="d-flex flex-wrap gap-2">
        <a href="<%= request.getContextPath() %>/cliente/favoritos.jsp" class="btn-detalles">Mis favoritos</a>
        <a href="<%= request.getContextPath() %>/cliente/mis-citas.jsp" class="btn-detalles">Mis citas</a>
        <a href="<%= request.getContextPath() %>/cliente/mis-solicitudes.jsp" class="btn-detalles">Mis solicitudes</a>
        <a href="<%= request.getContextPath() %>/cliente/perfil.jsp" class="btn-detalles">Mi perfil</a>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
