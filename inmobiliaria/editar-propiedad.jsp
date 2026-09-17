<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "INMOBILIARIA";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%
    int idUsuarioEditarProp = (Integer) session.getAttribute("idUsuario");
    String mensajeErrorEditarProp = null;
    Integer idPropiedadEditar = null;
    try {
        idPropiedadEditar = Integer.parseInt(request.getParameter("id"));
    } catch (Exception ex) {
        idPropiedadEditar = null;
    }

    Connection conEditarProp = null;
    Integer idInmobiliariaEditar = null;
    try {
        conEditarProp = obtenerConexion();
        idInmobiliariaEditar = obtenerIdInmobiliaria(conEditarProp, idUsuarioEditarProp);

        if (idPropiedadEditar == null || idInmobiliariaEditar == null) {
            conEditarProp.close();
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/propiedades.jsp");
            return;
        }

        // Verifica que la propiedad pertenezca a esta inmobiliaria
        PreparedStatement psVerificarProp = conEditarProp.prepareStatement(
            "SELECT id_propiedad FROM propiedad WHERE id_propiedad = ? AND id_inmobiliaria = ?");
        psVerificarProp.setInt(1, idPropiedadEditar);
        psVerificarProp.setInt(2, idInmobiliariaEditar);
        ResultSet rsVerificarProp = psVerificarProp.executeQuery();
        boolean propiedadEsMia = rsVerificarProp.next();
        rsVerificarProp.close(); psVerificarProp.close();

        if (!propiedadEsMia) {
            conEditarProp.close();
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/propiedades.jsp");
            return;
        }

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String tituloEdit = request.getParameter("titulo");
            String descripcionEdit = request.getParameter("descripcion");
            String precioEdit = request.getParameter("precio");
            String operacionEdit = request.getParameter("operacion");
            String habitacionesEdit = request.getParameter("habitaciones");
            String banosEdit = request.getParameter("banos");
            String areaEdit = request.getParameter("area_m2");
            String estadoEdit = request.getParameter("estado");
            String idCiudadEdit = request.getParameter("id_ciudad");
            String idTipoEdit = request.getParameter("id_tipo");

            if (tituloEdit == null || tituloEdit.trim().isEmpty()
                || precioEdit == null || precioEdit.trim().isEmpty()
                || (!"venta".equals(operacionEdit) && !"alquiler".equals(operacionEdit))
                || (!"disponible".equals(estadoEdit) && !"reservada".equals(estadoEdit)
                    && !"vendida".equals(estadoEdit) && !"alquilada".equals(estadoEdit))
                || idCiudadEdit == null || idCiudadEdit.isEmpty()
                || idTipoEdit == null || idTipoEdit.isEmpty()) {
                mensajeErrorEditarProp = "Completa los campos obligatorios.";
            } else {
                try {
                    double precioValidadoEdit = Double.parseDouble(precioEdit);
                    int habitacionesValidadasEdit = (habitacionesEdit == null || habitacionesEdit.isEmpty()) ? 0 : Integer.parseInt(habitacionesEdit);
                    int banosValidadosEdit = (banosEdit == null || banosEdit.isEmpty()) ? 0 : Integer.parseInt(banosEdit);
                    double areaValidadaEdit = (areaEdit == null || areaEdit.trim().isEmpty()) ? 0 : Double.parseDouble(areaEdit);

                    if (!Double.isFinite(precioValidadoEdit) || precioValidadoEdit <= 0
                        || habitacionesValidadasEdit < 0 || banosValidadosEdit < 0
                        || !Double.isFinite(areaValidadaEdit) || areaValidadaEdit < 0) {
                        mensajeErrorEditarProp = "El precio debe ser mayor que cero y las cantidades no pueden ser negativas.";
                    } else {
                        PreparedStatement psActualizarProp = conEditarProp.prepareStatement(
                            "UPDATE propiedad SET titulo=?, descripcion=?, precio=?, operacion=?, habitaciones=?, banos=?, area_m2=?, estado=?, id_ciudad=?, id_tipo=? " +
                            "WHERE id_propiedad=? AND id_inmobiliaria=?");
                        psActualizarProp.setString(1, tituloEdit.trim());
                        psActualizarProp.setString(2, descripcionEdit);
                        psActualizarProp.setDouble(3, precioValidadoEdit);
                        psActualizarProp.setString(4, operacionEdit);
                        psActualizarProp.setInt(5, habitacionesValidadasEdit);
                        psActualizarProp.setInt(6, banosValidadosEdit);
                        if (areaEdit == null || areaEdit.trim().isEmpty()) {
                            psActualizarProp.setNull(7, Types.DECIMAL);
                        } else {
                            psActualizarProp.setDouble(7, areaValidadaEdit);
                        }
                        psActualizarProp.setString(8, estadoEdit);
                        psActualizarProp.setInt(9, Integer.parseInt(idCiudadEdit));
                        psActualizarProp.setInt(10, Integer.parseInt(idTipoEdit));
                        psActualizarProp.setInt(11, idPropiedadEditar);
                        psActualizarProp.setInt(12, idInmobiliariaEditar);
                        psActualizarProp.executeUpdate();
                        psActualizarProp.close();
                        response.sendRedirect(request.getContextPath() + "/inmobiliaria/propiedades.jsp");
                        return;
                    }
                } catch (NumberFormatException exNumerosEditarProp) {
                    mensajeErrorEditarProp = "Precio, habitaciones, baños y área deben tener valores numéricos válidos.";
                }
            }
        }
    } catch (Exception exEditarProp) {
        mensajeErrorEditarProp = "Ocurrió un problema al procesar la propiedad.";
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Editar propiedad</h2>
<%
    if (mensajeErrorEditarProp != null) {
%>
    <div class="alerta-error"><%= mensajeErrorEditarProp %></div>
<%
    }

    PreparedStatement psCargarProp = null;
    ResultSet rsCargarProp = null;
    try {
        psCargarProp = conEditarProp.prepareStatement("SELECT * FROM propiedad WHERE id_propiedad = ?");
        psCargarProp.setInt(1, idPropiedadEditar);
        rsCargarProp = psCargarProp.executeQuery();
        if (rsCargarProp.next()) {
%>
    <form method="post" action="<%= request.getContextPath() %>/inmobiliaria/editar-propiedad.jsp?id=<%= idPropiedadEditar %>" class="card-registro">
        <div class="mb-3">
            <label class="form-label">Título</label>
            <input type="text" name="titulo" class="form-control" value="<%= rsCargarProp.getString("titulo") %>" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Descripción</label>
            <textarea name="descripcion" class="form-control" rows="4"><%= rsCargarProp.getString("descripcion") %></textarea>
        </div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Precio</label>
                <input type="number" step="0.01" name="precio" class="form-control" value="<%= rsCargarProp.getDouble("precio") %>" required>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">Operación</label>
                <select name="operacion" class="form-select" required>
                    <option value="venta" <%= "venta".equals(rsCargarProp.getString("operacion")) ? "selected" : "" %>>Venta</option>
                    <option value="alquiler" <%= "alquiler".equals(rsCargarProp.getString("operacion")) ? "selected" : "" %>>Alquiler</option>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col-md-3 mb-3">
                <label class="form-label">Habitaciones</label>
                <input type="number" name="habitaciones" class="form-control" value="<%= rsCargarProp.getInt("habitaciones") %>">
            </div>
            <div class="col-md-3 mb-3">
                <label class="form-label">Baños</label>
                <input type="number" name="banos" class="form-control" value="<%= rsCargarProp.getInt("banos") %>">
            </div>
            <div class="col-md-3 mb-3">
                <label class="form-label">Área (m²)</label>
                <input type="number" step="0.01" name="area_m2" class="form-control" value="<%= rsCargarProp.getDouble("area_m2") %>">
            </div>
            <div class="col-md-3 mb-3">
                <label class="form-label">Estado</label>
                <select name="estado" class="form-select">
<%
            String[] estadosPosibles = {"disponible", "reservada", "vendida", "alquilada"};
            String estadoActualProp = rsCargarProp.getString("estado");
            for (String estOpcion : estadosPosibles) {
                String selEst = estOpcion.equals(estadoActualProp) ? "selected" : "";
%>
                    <option value="<%= estOpcion %>" <%= selEst %>><%= estOpcion %></option>
<%
            }
%>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Ciudad</label>
                <select name="id_ciudad" class="form-select" required>
<%
            int idCiudadActualProp = rsCargarProp.getInt("id_ciudad");
            PreparedStatement psCiudadesEdit = conEditarProp.prepareStatement("SELECT id_ciudad, nombre FROM ciudad ORDER BY nombre");
            ResultSet rsCiudadesEdit = psCiudadesEdit.executeQuery();
            while (rsCiudadesEdit.next()) {
                int idCFila = rsCiudadesEdit.getInt("id_ciudad");
                String selC = (idCFila == idCiudadActualProp) ? "selected" : "";
%>
                    <option value="<%= idCFila %>" <%= selC %>><%= rsCiudadesEdit.getString("nombre") %></option>
<%
            }
            rsCiudadesEdit.close(); psCiudadesEdit.close();
%>
                </select>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">Tipo de propiedad</label>
                <select name="id_tipo" class="form-select" required>
<%
            int idTipoActualProp = rsCargarProp.getInt("id_tipo");
            PreparedStatement psTiposEdit = conEditarProp.prepareStatement("SELECT id_tipo, nombre FROM tipo_propiedad ORDER BY nombre");
            ResultSet rsTiposEdit = psTiposEdit.executeQuery();
            while (rsTiposEdit.next()) {
                int idTFila = rsTiposEdit.getInt("id_tipo");
                String selT = (idTFila == idTipoActualProp) ? "selected" : "";
%>
                    <option value="<%= idTFila %>" <%= selT %>><%= rsTiposEdit.getString("nombre") %></option>
<%
            }
            rsTiposEdit.close(); psTiposEdit.close();
%>
                </select>
            </div>
        </div>
        <button type="submit" class="btn-explorar w-100">Guardar cambios</button>
    </form>
<%
        } else {
%>
    <p class="text-danger">Propiedad no encontrada.</p>
<%
        }
        rsCargarProp.close(); psCargarProp.close();
    } catch (Exception exCargarProp) {
%>
    <p class="text-danger">Ocurrió un problema al cargar la propiedad.</p>
<%
    } finally {
        if (conEditarProp != null) { try { conEditarProp.close(); } catch (Exception ig) {} }
    }
%>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>