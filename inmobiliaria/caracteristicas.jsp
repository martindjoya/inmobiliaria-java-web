<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashSet" %>
<%
    String rolRequerido = "INMOBILIARIA";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%
    int idUsuarioCaract = (Integer) session.getAttribute("idUsuario");
    Integer idPropiedadCaract = null;
    try {
        idPropiedadCaract = Integer.parseInt(request.getParameter("id_propiedad"));
    } catch (Exception ex) {
        idPropiedadCaract = null;
    }

    Connection conCaract = null;
    try {
        conCaract = obtenerConexion();
        Integer idInmobiliariaCaract = obtenerIdInmobiliaria(conCaract, idUsuarioCaract);

        if (idPropiedadCaract == null || idInmobiliariaCaract == null) {
            conCaract.close();
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/propiedades.jsp");
            return;
        }

        PreparedStatement psVerificarCaract = conCaract.prepareStatement(
            "SELECT id_propiedad FROM propiedad WHERE id_propiedad = ? AND id_inmobiliaria = ?");
        psVerificarCaract.setInt(1, idPropiedadCaract);
        psVerificarCaract.setInt(2, idInmobiliariaCaract);
        ResultSet rsVerificarCaract = psVerificarCaract.executeQuery();
        boolean esPropiedadMiaCaract = rsVerificarCaract.next();
        rsVerificarCaract.close(); psVerificarCaract.close();

        if (!esPropiedadMiaCaract) {
            conCaract.close();
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/propiedades.jsp");
            return;
        }

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String[] seleccionadas = request.getParameterValues("caracteristicas");
            conCaract.setAutoCommit(false);
            PreparedStatement psBorrarCaract = conCaract.prepareStatement(
                "DELETE FROM propiedad_caracteristica WHERE id_propiedad = ?");
            psBorrarCaract.setInt(1, idPropiedadCaract);
            psBorrarCaract.executeUpdate();
            psBorrarCaract.close();

            if (seleccionadas != null) {
                PreparedStatement psInsertarCaract = conCaract.prepareStatement(
                    "INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES (?, ?)");
                for (String idCaractSel : seleccionadas) {
                    psInsertarCaract.setInt(1, idPropiedadCaract);
                    psInsertarCaract.setInt(2, Integer.parseInt(idCaractSel));
                    psInsertarCaract.addBatch();
                }
                psInsertarCaract.executeBatch();
                psInsertarCaract.close();
            }
            conCaract.commit();
            conCaract.setAutoCommit(true);
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/caracteristicas.jsp?id_propiedad=" + idPropiedadCaract);
            return;
        }
    } catch (Exception exCaract) {
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Características de la propiedad</h2>
    <form method="post" action="<%= request.getContextPath() %>/inmobiliaria/caracteristicas.jsp?id_propiedad=<%= idPropiedadCaract %>" class="card-registro">
<%
    HashSet<Integer> caractAsignadas = new HashSet<>();
    try {
        PreparedStatement psAsignadasCaract = conCaract.prepareStatement(
            "SELECT id_caracteristica FROM propiedad_caracteristica WHERE id_propiedad = ?");
        psAsignadasCaract.setInt(1, idPropiedadCaract);
        ResultSet rsAsignadasCaract = psAsignadasCaract.executeQuery();
        while (rsAsignadasCaract.next()) {
            caractAsignadas.add(rsAsignadasCaract.getInt("id_caracteristica"));
        }
        rsAsignadasCaract.close(); psAsignadasCaract.close();

        PreparedStatement psTodasCaract = conCaract.prepareStatement("SELECT id_caracteristica, nombre FROM caracteristica ORDER BY nombre");
        ResultSet rsTodasCaract = psTodasCaract.executeQuery();
        while (rsTodasCaract.next()) {
            int idCaractFila = rsTodasCaract.getInt("id_caracteristica");
            boolean marcada = caractAsignadas.contains(idCaractFila);
%>
        <div class="form-check">
            <input class="form-check-input" type="checkbox" name="caracteristicas" value="<%= idCaractFila %>" id="car<%= idCaractFila %>" <%= marcada ? "checked" : "" %>>
            <label class="form-check-label" for="car<%= idCaractFila %>"><%= rsTodasCaract.getString("nombre") %></label>
        </div>
<%
        }
        rsTodasCaract.close(); psTodasCaract.close();
    } catch (Exception exListaCaract) {
    } finally {
        if (conCaract != null) { try { conCaract.close(); } catch (Exception ig) {} }
    }
%>
        <button type="submit" class="btn-explorar w-100 mt-3">Guardar características</button>
    </form>
    <a href="<%= request.getContextPath() %>/inmobiliaria/propiedades.jsp" class="btn-detalles mt-3 d-inline-block">&larr; Volver a mis propiedades</a>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>