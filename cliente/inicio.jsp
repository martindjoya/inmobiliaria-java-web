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
    Connection conInicioCliente = null;
    try {
        conInicioCliente = obtenerConexion();

        PreparedStatement psFav = conInicioCliente.prepareStatement(
            "SELECT COUNT(*) AS total FROM favorito WHERE id_usuario = ?");
        psFav.setInt(1, idUsuarioCliente);
        ResultSet rsFav = psFav.executeQuery();
        if (rsFav.next()) totalFavoritos = rsFav.getInt("total");
        rsFav.close(); psFav.close();

        PreparedStatement psCitas = conInicioCliente.prepareStatement(
            "SELECT COUNT(*) AS total FROM cita WHERE id_usuario = ? AND estado = 'pendiente'");
        psCitas.setInt(1, idUsuarioCliente);
        ResultSet rsCitas = psCitas.executeQuery();
        if (rsCitas.next()) totalCitasPendientes = rsCitas.getInt("total");
        rsCitas.close(); psCitas.close();

        PreparedStatement psSol = conInicioCliente.prepareStatement(
            "SELECT COUNT(*) AS total FROM solicitud WHERE id_usuario = ? AND estado = 'pendiente'");
        psSol.setInt(1, idUsuarioCliente);
        ResultSet rsSol = psSol.executeQuery();
        if (rsSol.next()) totalSolicitudesPendientes = rsSol.getInt("total");
        rsSol.close(); psSol.close();

    } catch (Exception exInicioCliente) {
    } finally {
        if (conInicioCliente != null) { try { conInicioCliente.close(); } catch (Exception ig) {} }
    }
%>

<div class="container py-5">
    <h2 class="titulo-seccion mb-1">Hola, <%= session.getAttribute("nombreUsuario") %></h2>
    <p class="subtitulo-registro mb-4">Tu panel de cliente en Dream House S.A.</p>

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="tarjeta-propiedad tarjeta-body text-center">
                <h3><%= totalFavoritos %></h3>
                <p class="mb-0">Propiedades favoritas</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="tarjeta-propiedad tarjeta-body text-center">
                <h3><%= totalCitasPendientes %></h3>
                <p class="mb-0">Citas pendientes</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="tarjeta-propiedad tarjeta-body text-center">
                <h3><%= totalSolicitudesPendientes %></h3>
                <p class="mb-0">Solicitudes pendientes</p>
            </div>
        </div>
    </div>

    <div class="d-flex flex-wrap gap-2">
        <a href="<%= request.getContextPath() %>/propiedades.jsp" class="btn-explorar">Buscar propiedades</a>
        <a href="<%= request.getContextPath() %>/cliente/favoritos.jsp" class="btn-detalles">Mis favoritos</a>
        <a href="<%= request.getContextPath() %>/cliente/mis-citas.jsp" class="btn-detalles">Mis citas</a>
        <a href="<%= request.getContextPath() %>/cliente/mis-solicitudes.jsp" class="btn-detalles">Mis solicitudes</a>
        <a href="<%= request.getContextPath() %>/cliente/perfil.jsp" class="btn-detalles">Mi perfil</a>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>