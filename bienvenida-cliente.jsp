<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String rolRequerido = "Cliente";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<section class="seccion-registro py-5">
    <div class="container">
        <div class="row justify-content-center align-items-center g-5">
            <div class="col-lg-7">
                <span class="etiqueta">Tu espacio en Dream House</span>
                <h1 class="titulo-seccion display-5 mt-3 mb-3">Bienvenido, <%= session.getAttribute("nombreUsuario") %></h1>
                <p class="subtitulo-registro fs-5 mb-4">Encuentra un lugar que se sienta como hogar y lleva el control de todo desde un mismo espacio.</p>
                <div class="d-flex flex-wrap gap-2">
                    <a href="<%= request.getContextPath() %>/cliente/inicio.jsp" class="btn-explorar">Ir a mi panel</a>
                    <a href="<%= request.getContextPath() %>/propiedades.jsp" class="btn-detalles">Explorar propiedades</a>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="card-registro">
                    <h2 class="h4 mb-3">Todo listo para comenzar</h2>
                    <p class="subtitulo-registro mb-4">Guarda tus propiedades favoritas, agenda visitas y revisa tus solicitudes.</p>
                    <a href="<%= request.getContextPath() %>/cliente/favoritos.jsp" class="btn-detalles d-block text-center mb-2">Mis favoritos</a>
                    <a href="<%= request.getContextPath() %>/cliente/mis-citas.jsp" class="btn-detalles d-block text-center mb-2">Mis citas</a>
                    <a href="<%= request.getContextPath() %>/cliente/perfil.jsp" class="btn-detalles d-block text-center">Mi perfil</a>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>