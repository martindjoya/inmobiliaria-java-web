<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "ADMINISTRADOR";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%
    String mensajeCatalogo = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String tablaDestino = request.getParameter("tabla");
        String nombreNuevoItem = request.getParameter("nombre_item");
        String departamentoCiudad = request.getParameter("departamento"); // solo aplica a ciudad

        if (nombreNuevoItem != null && !nombreNuevoItem.trim().isEmpty()
            && ("ciudad".equals(tablaDestino) || "tipo_propiedad".equals(tablaDestino) || "caracteristica".equals(tablaDestino))) {
            Connection conCatalogo = null;
            try {
                conCatalogo = obtenerConexion();
                if ("ciudad".equals(tablaDestino)) {
                    PreparedStatement psCiudadNva = conCatalogo.prepareStatement(
                        "INSERT INTO ciudad (nombre, departamento) VALUES (?, ?)");
                    psCiudadNva.setString(1, nombreNuevoItem.trim());
                    psCiudadNva.setString(2, (departamentoCiudad != null) ? departamentoCiudad.trim() : null);
                    psCiudadNva.executeUpdate();
                    psCiudadNva.close();
                } else if ("tipo_propiedad".equals(tablaDestino)) {
                    PreparedStatement psTipoNvo = conCatalogo.prepareStatement(
                        "INSERT INTO tipo_propiedad (nombre) VALUES (?)");
                    psTipoNvo.setString(1, nombreNuevoItem.trim());
                    psTipoNvo.executeUpdate();
                    psTipoNvo.close();
                } else {
                    PreparedStatement psCaractNva = conCatalogo.prepareStatement(
                        "INSERT INTO caracteristica (nombre) VALUES (?)");
                    psCaractNva.setString(1, nombreNuevoItem.trim());
                    psCaractNva.executeUpdate();
                    psCaractNva.close();
                }
            } catch (SQLIntegrityConstraintViolationException exDupCat) {
                mensajeCatalogo = "Ese valor ya existe en el catálogo (debe ser único).";
            } catch (Exception exCatalogo) {
                mensajeCatalogo = "Ocurrió un problema al agregar el elemento.";
            } finally {
                if (conCatalogo != null) { try { conCatalogo.close(); } catch (Exception ig) {} }
            }
        }
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Catálogos del sistema</h2>
<%
    if (mensajeCatalogo != null) {
%>
    <div class="alerta-error"><%= mensajeCatalogo %></div>
<%
    }
%>
    <div class="row g-4">
        <!-- CIUDADES -->
        <div class="col-md-4">
            <h5>Ciudades</h5>
            <form method="post" action="<%= request.getContextPath() %>/admin/catalogos.jsp" class="mb-3">
                <input type="hidden" name="tabla" value="ciudad">
                <input type="text" name="nombre_item" class="form-control mb-2" placeholder="Nombre de ciudad" required>
                <input type="text" name="departamento" class="form-control mb-2" placeholder="Departamento">
                <button type="submit" class="btn-detalles w-100">Agregar ciudad</button>
            </form>
            <ul class="list-group">
<%
    Connection conListasCat = null;
    try {
        conListasCat = obtenerConexion();
        PreparedStatement psCiudadesLista = conListasCat.prepareStatement("SELECT nombre, departamento FROM ciudad ORDER BY nombre");
        ResultSet rsCiudadesLista = psCiudadesLista.executeQuery();
        while (rsCiudadesLista.next()) {
%>
                <li class="list-group-item"><%= rsCiudadesLista.getString("nombre") %><% if (rsCiudadesLista.getString("departamento") != null) { %> (<%= rsCiudadesLista.getString("departamento") %>)<% } %></li>
<%
        }
        rsCiudadesLista.close(); psCiudadesLista.close();
    } catch (Exception exListaCiudad) { }
%>
            </ul>
        </div>

        <!-- TIPOS DE PROPIEDAD -->
        <div class="col-md-4">
            <h5>Tipos de propiedad</h5>
            <form method="post" action="<%= request.getContextPath() %>/admin/catalogos.jsp" class="mb-3">
                <input type="hidden" name="tabla" value="tipo_propiedad">
                <input type="text" name="nombre_item" class="form-control mb-2" placeholder="Nombre del tipo" required>
                <button type="submit" class="btn-detalles w-100">Agregar tipo</button>
            </form>
            <ul class="list-group">
<%
    try {
        PreparedStatement psTiposLista = conListasCat.prepareStatement("SELECT nombre FROM tipo_propiedad ORDER BY nombre");
        ResultSet rsTiposLista = psTiposLista.executeQuery();
        while (rsTiposLista.next()) {
%>
                <li class="list-group-item"><%= rsTiposLista.getString("nombre") %></li>
<%
        }
        rsTiposLista.close(); psTiposLista.close();
    } catch (Exception exListaTipo) { }
%>
            </ul>
        </div>

        <!-- CARACTERÍSTICAS -->
        <div class="col-md-4">
            <h5>Características</h5>
            <form method="post" action="<%= request.getContextPath() %>/admin/catalogos.jsp" class="mb-3">
                <input type="hidden" name="tabla" value="caracteristica">
                <input type="text" name="nombre_item" class="form-control mb-2" placeholder="Nombre de característica" required>
                <button type="submit" class="btn-detalles w-100">Agregar característica</button>
            </form>
            <ul class="list-group">
<%
    try {
        PreparedStatement psCaractLista = conListasCat.prepareStatement("SELECT nombre FROM caracteristica ORDER BY nombre");
        ResultSet rsCaractLista = psCaractLista.executeQuery();
        while (rsCaractLista.next()) {
%>
                <li class="list-group-item"><%= rsCaractLista.getString("nombre") %></li>
<%
        }
        rsCaractLista.close(); psCaractLista.close();
    } catch (Exception exListaCaract) {
    } finally {
        if (conListasCat != null) { try { conListasCat.close(); } catch (Exception ig) {} }
    }
%>
            </ul>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>