<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "INMOBILIARIA";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%
    int idUsuarioInm = (Integer) session.getAttribute("idUsuario");
    String mensajeErrorInm = null;
    Integer idInmobiliariaActual = null;

    Connection conInicioInm = null;
    try {
        conInicioInm = obtenerConexion();
        idInmobiliariaActual = obtenerIdInmobiliaria(conInicioInm, idUsuarioInm);

        if (idInmobiliariaActual == null && "POST".equalsIgnoreCase(request.getMethod())) {
            String nombreComercialNvo = request.getParameter("nombre_comercial");
            String nitNvo = request.getParameter("nit");
            String telefonoNvo = request.getParameter("telefono_contacto");

            if (nombreComercialNvo == null || nombreComercialNvo.trim().isEmpty()) {
                mensajeErrorInm = "El nombre comercial es obligatorio.";
            } else {
                PreparedStatement psCrearInm = conInicioInm.prepareStatement(
                    "INSERT INTO inmobiliaria (id_usuario, nombre_comercial, nit, telefono_contacto) VALUES (?, ?, ?, ?)");
                psCrearInm.setInt(1, idUsuarioInm);
                psCrearInm.setString(2, nombreComercialNvo.trim());
                psCrearInm.setString(3, nitNvo);
                psCrearInm.setString(4, telefonoNvo);
                psCrearInm.executeUpdate();
                psCrearInm.close();
                response.sendRedirect(request.getContextPath() + "/inmobiliaria/inicio.jsp");
                return;
            }
        }
    } catch (Exception exInicioInm) {
        mensajeErrorInm = "Ocurrió un problema al procesar tu información.";
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
<%
    if (idInmobiliariaActual == null) {
%>
    <h2 class="titulo-seccion mb-4">Completa los datos de tu inmobiliaria</h2>
<%
        if (mensajeErrorInm != null) {
%>
    <div class="alerta-error"><%= mensajeErrorInm %></div>
<%
        }
%>
    <form method="post" action="<%= request.getContextPath() %>/inmobiliaria/inicio.jsp" class="card-registro">
        <div class="mb-3">
            <label class="form-label">Nombre comercial</label>
            <input type="text" name="nombre_comercial" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">NIT</label>
            <input type="text" name="nit" class="form-control">
        </div>
        <div class="mb-3">
            <label class="form-label">Teléfono de contacto</label>
            <input type="text" name="telefono_contacto" class="form-control">
        </div>
        <button type="submit" class="btn-explorar w-100">Guardar y continuar</button>
    </form>
<%
    } else {
        int totalPropiedadesInm = 0, totalCitasPendientesInm = 0, totalSolicitudesPendientesInm = 0;
        try {
            PreparedStatement psTotProp = conInicioInm.prepareStatement(
                "SELECT COUNT(*) AS total FROM propiedad WHERE id_inmobiliaria = ?");
            psTotProp.setInt(1, idInmobiliariaActual);
            ResultSet rsTotProp = psTotProp.executeQuery();
            if (rsTotProp.next()) totalPropiedadesInm = rsTotProp.getInt("total");
            rsTotProp.close(); psTotProp.close();

            PreparedStatement psTotCitas = conInicioInm.prepareStatement(
                "SELECT COUNT(*) AS total FROM cita c JOIN propiedad p ON c.id_propiedad = p.id_propiedad " +
                "WHERE p.id_inmobiliaria = ? AND c.estado = 'pendiente'");
            psTotCitas.setInt(1, idInmobiliariaActual);
            ResultSet rsTotCitas = psTotCitas.executeQuery();
            if (rsTotCitas.next()) totalCitasPendientesInm = rsTotCitas.getInt("total");
            rsTotCitas.close(); psTotCitas.close();

            PreparedStatement psTotSol = conInicioInm.prepareStatement(
                "SELECT COUNT(*) AS total FROM solicitud s JOIN propiedad p ON s.id_propiedad = p.id_propiedad " +
                "WHERE p.id_inmobiliaria = ? AND s.estado = 'pendiente'");
            psTotSol.setInt(1, idInmobiliariaActual);
            ResultSet rsTotSol = psTotSol.executeQuery();
            if (rsTotSol.next()) totalSolicitudesPendientesInm = rsTotSol.getInt("total");
            rsTotSol.close(); psTotSol.close();
        } catch (Exception exTotales) { }
%>
    <h2 class="titulo-seccion mb-1">Hola, <%= session.getAttribute("nombreUsuario") %></h2>
    <p class="subtitulo-registro mb-4">Panel de tu inmobiliaria en Dream House S.A.</p>

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="tarjeta-propiedad tarjeta-body text-center">
                <h3><%= totalPropiedadesInm %></h3>
                <p class="mb-0">Propiedades publicadas</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="tarjeta-propiedad tarjeta-body text-center">
                <h3><%= totalCitasPendientesInm %></h3>
                <p class="mb-0">Citas pendientes</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="tarjeta-propiedad tarjeta-body text-center">
                <h3><%= totalSolicitudesPendientesInm %></h3>
                <p class="mb-0">Solicitudes pendientes</p>
            </div>
        </div>
    </div>

    <div class="d-flex flex-wrap gap-2">
        <a href="<%= request.getContextPath() %>/inmobiliaria/propiedades.jsp" class="btn-explorar">Mis propiedades</a>
        <a href="<%= request.getContextPath() %>/inmobiliaria/guardar-propiedad.jsp" class="btn-detalles">+ Nueva propiedad</a>
        <a href="<%= request.getContextPath() %>/inmobiliaria/citas.jsp" class="btn-detalles">Citas</a>
        <a href="<%= request.getContextPath() %>/inmobiliaria/solicitudes.jsp" class="btn-detalles">Solicitudes</a>
    </div>
<%
    }
    if (conInicioInm != null) { try { conInicioInm.close(); } catch (Exception ig) {} }
%>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>