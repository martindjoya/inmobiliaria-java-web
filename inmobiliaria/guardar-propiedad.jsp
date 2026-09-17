<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "INMOBILIARIA";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%
    int idUsuarioGuardarProp = (Integer) session.getAttribute("idUsuario");
    String mensajeErrorGuardarProp = null;
    Integer idInmobiliariaGuardar = null;

    Connection conGuardarProp = null;
    try {
        conGuardarProp = obtenerConexion();
        idInmobiliariaGuardar = obtenerIdInmobiliaria(conGuardarProp, idUsuarioGuardarProp);

        if (idInmobiliariaGuardar == null) {
            conGuardarProp.close();
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/inicio.jsp");
            return;
        }

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String tituloNvo = request.getParameter("titulo");
            String matriculaNva = request.getParameter("matricula_inmobiliaria");
            String descripcionNva = request.getParameter("descripcion");
            String precioNvo = request.getParameter("precio");
            String operacionNva = request.getParameter("operacion");
            String habitacionesNvo = request.getParameter("habitaciones");
            String banosNvo = request.getParameter("banos");
            String areaNva = request.getParameter("area_m2");
            String idCiudadNva = request.getParameter("id_ciudad");
            String idTipoNvo = request.getParameter("id_tipo");

            if (tituloNvo == null || tituloNvo.trim().isEmpty()
                || matriculaNva == null || matriculaNva.trim().isEmpty()
                || precioNvo == null || precioNvo.trim().isEmpty()
                || (!"venta".equals(operacionNva) && !"alquiler".equals(operacionNva))
                || idCiudadNva == null || idCiudadNva.isEmpty()
                || idTipoNvo == null || idTipoNvo.isEmpty()) {
                mensajeErrorGuardarProp = "Completa los campos obligatorios: título, precio, operación, ciudad y tipo.";
            } else {
                try {
                    double precioValidado = Double.parseDouble(precioNvo);
                    int habitacionesValidadas = (habitacionesNvo == null || habitacionesNvo.isEmpty()) ? 0 : Integer.parseInt(habitacionesNvo);
                    int banosValidados = (banosNvo == null || banosNvo.isEmpty()) ? 0 : Integer.parseInt(banosNvo);
                    double areaValidada = (areaNva == null || areaNva.trim().isEmpty()) ? 0 : Double.parseDouble(areaNva);

                    if (!Double.isFinite(precioValidado) || precioValidado <= 0
                        || habitacionesValidadas < 0 || banosValidados < 0
                        || !Double.isFinite(areaValidada) || areaValidada < 0) {
                        mensajeErrorGuardarProp = "El precio debe ser mayor que cero y las cantidades no pueden ser negativas.";
                    } else {
                        PreparedStatement psInsertarProp = conGuardarProp.prepareStatement(
                            "INSERT INTO propiedad (matricula_inmobiliaria, titulo, descripcion, precio, operacion, habitaciones, banos, area_m2, estado, id_ciudad, id_tipo, id_inmobiliaria) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'disponible', ?, ?, ?)");
                        psInsertarProp.setString(1, matriculaNva.trim());
                        psInsertarProp.setString(2, tituloNvo.trim());
                        psInsertarProp.setString(3, descripcionNva);
                        psInsertarProp.setDouble(4, precioValidado);
                        psInsertarProp.setString(5, operacionNva);
                        psInsertarProp.setInt(6, habitacionesValidadas);
                        psInsertarProp.setInt(7, banosValidados);
                        if (areaNva == null || areaNva.trim().isEmpty()) {
                            psInsertarProp.setNull(8, Types.DECIMAL);
                        } else {
                            psInsertarProp.setDouble(8, areaValidada);
                        }
                        psInsertarProp.setInt(9, Integer.parseInt(idCiudadNva));
                        psInsertarProp.setInt(10, Integer.parseInt(idTipoNvo));
                        psInsertarProp.setInt(11, idInmobiliariaGuardar);
                        psInsertarProp.executeUpdate();
                        psInsertarProp.close();
                        response.sendRedirect(request.getContextPath() + "/inmobiliaria/propiedades.jsp");
                        return;
                    }
                } catch (NumberFormatException exNumerosProp) {
                    mensajeErrorGuardarProp = "Precio, habitaciones, baños y área deben tener valores numéricos válidos.";
                }
            }
        }
    } catch (SQLIntegrityConstraintViolationException exDuplicadoProp) {
        mensajeErrorGuardarProp = "La matrícula inmobiliaria ya está registrada.";
    } catch (Exception exGuardarProp) {
        mensajeErrorGuardarProp = "Ocurrió un problema al guardar la propiedad. Verifica los valores numéricos.";
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Nueva propiedad</h2>
<%
    if (mensajeErrorGuardarProp != null) {
%>
    <div class="alerta-error"><%= mensajeErrorGuardarProp %></div>
<%
    }
%>
    <form method="post" action="<%= request.getContextPath() %>/inmobiliaria/guardar-propiedad.jsp" class="card-registro">
        <div class="mb-3">
            <label class="form-label">Matrícula inmobiliaria</label>
            <input type="text" name="matricula_inmobiliaria" class="form-control" maxlength="50" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Título</label>
            <input type="text" name="titulo" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Descripción</label>
            <textarea name="descripcion" class="form-control" rows="4"></textarea>
        </div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Precio</label>
                <input type="number" step="0.01" name="precio" class="form-control" required>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">Operación</label>
                <select name="operacion" class="form-select" required>
                    <option value="venta">Venta</option>
                    <option value="alquiler">Alquiler</option>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4 mb-3">
                <label class="form-label">Habitaciones</label>
                <input type="number" name="habitaciones" class="form-control" value="0">
            </div>
            <div class="col-md-4 mb-3">
                <label class="form-label">Baños</label>
                <input type="number" name="banos" class="form-control" value="0">
            </div>
            <div class="col-md-4 mb-3">
                <label class="form-label">Área (m²)</label>
                <input type="number" step="0.01" name="area_m2" class="form-control">
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Ciudad</label>
                <select name="id_ciudad" class="form-select" required>
                    <option value="">Selecciona</option>
<%
    try {
        PreparedStatement psCiudadesForm = conGuardarProp.prepareStatement("SELECT id_ciudad, nombre FROM ciudad ORDER BY nombre");
        ResultSet rsCiudadesForm = psCiudadesForm.executeQuery();
        while (rsCiudadesForm.next()) {
%>
                    <option value="<%= rsCiudadesForm.getInt("id_ciudad") %>"><%= rsCiudadesForm.getString("nombre") %></option>
<%
        }
        rsCiudadesForm.close(); psCiudadesForm.close();
    } catch (Exception ex) { }
%>
                </select>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">Tipo de propiedad</label>
                <select name="id_tipo" class="form-select" required>
                    <option value="">Selecciona</option>
<%
    try {
        PreparedStatement psTiposForm = conGuardarProp.prepareStatement("SELECT id_tipo, nombre FROM tipo_propiedad ORDER BY nombre");
        ResultSet rsTiposForm = psTiposForm.executeQuery();
        while (rsTiposForm.next()) {
%>
                    <option value="<%= rsTiposForm.getInt("id_tipo") %>"><%= rsTiposForm.getString("nombre") %></option>
<%
        }
        rsTiposForm.close(); psTiposForm.close();
    } catch (Exception ex) {
    } finally {
        if (conGuardarProp != null) { try { conGuardarProp.close(); } catch (Exception ig) {} }
    }
%>
                </select>
            </div>
        </div>
        <button type="submit" class="btn-explorar w-100">Publicar propiedad</button>
    </form>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>