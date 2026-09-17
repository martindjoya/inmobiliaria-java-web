<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String rolRequerido = "INMOBILIARIA";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/conexion.jspf" %>
<%@ include file="/WEB-INF/jspf/utilidades.jspf" %>
<%
    int idUsuarioImg = (Integer) session.getAttribute("idUsuario");
    String mensajeErrorImg = null;
    Integer idPropiedadImg = null;
    try {
        idPropiedadImg = Integer.parseInt(request.getParameter("id_propiedad"));
    } catch (Exception ex) {
        idPropiedadImg = null;
    }

    Connection conImagenes = null;
    try {
        conImagenes = obtenerConexion();
        Integer idInmobiliariaImg = obtenerIdInmobiliaria(conImagenes, idUsuarioImg);

        if (idPropiedadImg == null || idInmobiliariaImg == null) {
            conImagenes.close();
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/propiedades.jsp");
            return;
        }

        PreparedStatement psVerificarImg = conImagenes.prepareStatement(
            "SELECT id_propiedad FROM propiedad WHERE id_propiedad = ? AND id_inmobiliaria = ?");
        psVerificarImg.setInt(1, idPropiedadImg);
        psVerificarImg.setInt(2, idInmobiliariaImg);
        ResultSet rsVerificarImg = psVerificarImg.executeQuery();
        boolean esPropiedadMiaImg = rsVerificarImg.next();
        rsVerificarImg.close(); psVerificarImg.close();

        if (!esPropiedadMiaImg) {
            conImagenes.close();
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/propiedades.jsp");
            return;
        }

        String accionImg = request.getParameter("accion");
        if ("agregar".equals(accionImg) && "POST".equalsIgnoreCase(request.getMethod())) {
            String urlNva = request.getParameter("url_imagen");
            if (urlNva != null && !urlNva.trim().isEmpty()) {
                PreparedStatement psAgregarImg = conImagenes.prepareStatement(
                    "INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal) VALUES (?, ?, 0)");
                psAgregarImg.setInt(1, idPropiedadImg);
                psAgregarImg.setString(2, urlNva.trim());
                psAgregarImg.executeUpdate();
                psAgregarImg.close();
            }
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/imagenes.jsp?id_propiedad=" + idPropiedadImg);
            return;
        } else if ("principal".equals(accionImg) && "POST".equalsIgnoreCase(request.getMethod())) {
            String idImgPrincipal = request.getParameter("id_imagen");
            PreparedStatement psQuitarPrincipal = conImagenes.prepareStatement(
                "UPDATE imagen_propiedad SET es_principal = 0 WHERE id_propiedad = ?");
            psQuitarPrincipal.setInt(1, idPropiedadImg);
            psQuitarPrincipal.executeUpdate();
            psQuitarPrincipal.close();

            PreparedStatement psPonerPrincipal = conImagenes.prepareStatement(
                "UPDATE imagen_propiedad SET es_principal = 1 WHERE id_imagen = ? AND id_propiedad = ?");
            psPonerPrincipal.setInt(1, Integer.parseInt(idImgPrincipal));
            psPonerPrincipal.setInt(2, idPropiedadImg);
            psPonerPrincipal.executeUpdate();
            psPonerPrincipal.close();

            response.sendRedirect(request.getContextPath() + "/inmobiliaria/imagenes.jsp?id_propiedad=" + idPropiedadImg);
            return;
        } else if ("eliminar".equals(accionImg) && "POST".equalsIgnoreCase(request.getMethod())) {
            String idImgEliminar = request.getParameter("id_imagen");
            PreparedStatement psEliminarImg = conImagenes.prepareStatement(
                "DELETE FROM imagen_propiedad WHERE id_imagen = ? AND id_propiedad = ?");
            psEliminarImg.setInt(1, Integer.parseInt(idImgEliminar));
            psEliminarImg.setInt(2, idPropiedadImg);
            psEliminarImg.executeUpdate();
            psEliminarImg.close();
            response.sendRedirect(request.getContextPath() + "/inmobiliaria/imagenes.jsp?id_propiedad=" + idPropiedadImg);
            return;
        }
    } catch (Exception exImagenes) {
        mensajeErrorImg = "Ocurrió un problema al procesar las imágenes.";
    }
%>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<div class="container py-5">
    <h2 class="titulo-seccion mb-4">Imágenes de la propiedad</h2>
<%
    if (mensajeErrorImg != null) {
%>
    <div class="alerta-error"><%= mensajeErrorImg %></div>
<%
    }
%>
    <div class="alert alert-secondary">Por ahora se agregan pegando la URL de una imagen (sin subida real de archivos).</div>

    <form method="post" action="<%= request.getContextPath() %>/inmobiliaria/imagenes.jsp?id_propiedad=<%= idPropiedadImg %>" class="card-registro mb-4">
        <input type="hidden" name="accion" value="agregar">
        <div class="mb-3">
            <label class="form-label">URL de la imagen</label>
            <input type="text" name="url_imagen" class="form-control" placeholder="https://..." required>
        </div>
        <button type="submit" class="btn-explorar w-100">Agregar imagen</button>
    </form>

    <div class="row g-3">
<%
    try {
        PreparedStatement psListaImg = conImagenes.prepareStatement(
            "SELECT id_imagen, url_imagen, es_principal FROM imagen_propiedad WHERE id_propiedad = ?");
        psListaImg.setInt(1, idPropiedadImg);
        ResultSet rsListaImg = psListaImg.executeQuery();
        boolean hayImagenesInm = false;
        while (rsListaImg.next()) {
            hayImagenesInm = true;
            int idImgFila = rsListaImg.getInt("id_imagen");
            boolean esPrincipalFila = rsListaImg.getInt("es_principal") == 1;
%>
        <div class="col-md-4">
            <div class="tarjeta-propiedad">
                <img src="<%= rsListaImg.getString("url_imagen") %>" alt="Imagen">
                <div class="tarjeta-body">
                    <p><%= esPrincipalFila ? "★ Principal" : "" %></p>
                    <form method="post" action="<%= request.getContextPath() %>/inmobiliaria/imagenes.jsp?id_propiedad=<%= idPropiedadImg %>" class="d-inline">
                        <input type="hidden" name="accion" value="principal">
                        <input type="hidden" name="id_imagen" value="<%= idImgFila %>">
                        <button type="submit" class="btn-detalles" <%= esPrincipalFila ? "disabled" : "" %>>Hacer principal</button>
                    </form>
                    <form method="post" action="<%= request.getContextPath() %>/inmobiliaria/imagenes.jsp?id_propiedad=<%= idPropiedadImg %>" class="d-inline">
                        <input type="hidden" name="accion" value="eliminar">
                        <input type="hidden" name="id_imagen" value="<%= idImgFila %>">
                        <button type="submit" class="btn-detalles">Eliminar</button>
                    </form>
                </div>
            </div>
        </div>
<%
        }
        if (!hayImagenesInm) {
%>
        <p class="text-center">Sin imágenes registradas todavía.</p>
<%
        }
        rsListaImg.close(); psListaImg.close();
    } catch (Exception exListaImg) {
    } finally {
        if (conImagenes != null) { try { conImagenes.close(); } catch (Exception ig) {} }
    }
%>
    </div>
    <a href="<%= request.getContextPath() %>/inmobiliaria/propiedades.jsp" class="btn-detalles mt-3 d-inline-block">&larr; Volver a mis propiedades</a>
</div>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>