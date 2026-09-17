<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String rolRequerido = "Administrador";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<section class="seccion-registro py-5">
    <div class="container">
        <div class="text-center mb-5">
            <span class="etiqueta">Centro de control</span>
            <h1 class="titulo-seccion mt-3 mb-2">Bienvenido, <%= session.getAttribute("nombreUsuario") %></h1>
            <p class="subtitulo-registro mb-0">Administra la operación de Dream House S.A. desde un solo lugar.</p>
        </div>

        <div class="row g-4 justify-content-center">
            <div class="col-md-6 col-lg-3">
                <div class="tarjeta-propiedad tarjeta-body text-center">
                    <h2 class="h4">Usuarios</h2>
                    <p class="subtitulo-registro">Gestiona cuentas y permisos.</p>
                    <a href="<%= request.getContextPath() %>/admin/usuarios.jsp" class="btn-detalles">Administrar</a>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="tarjeta-propiedad tarjeta-body text-center">
                    <h2 class="h4">Propiedades</h2>
                    <p class="subtitulo-registro">Revisa el catálogo publicado.</p>
                    <a href="<%= request.getContextPath() %>/admin/propiedades.jsp" class="btn-detalles">Revisar</a>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="tarjeta-propiedad tarjeta-body text-center">
                    <h2 class="h4">Catálogos</h2>
                    <p class="subtitulo-registro">Mantén la información base.</p>
                    <a href="<%= request.getContextPath() %>/admin/catalogos.jsp" class="btn-detalles">Consultar</a>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="tarjeta-propiedad tarjeta-body text-center">
                    <h2 class="h4">Auditoría</h2>
                    <p class="subtitulo-registro">Consulta la actividad del sistema.</p>
                    <a href="<%= request.getContextPath() %>/admin/auditoria.jsp" class="btn-detalles">Ver registros</a>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>