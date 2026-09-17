<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String rolRequerido = "Inmobiliaria";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<section class="seccion-registro py-5">
    <div class="container">
        <div class="row justify-content-center align-items-center g-5">
            <div class="col-lg-7">
                <span class="etiqueta">Espacio para inmobiliarias</span>
                <h1 class="titulo-seccion display-5 mt-3 mb-3">Bienvenido, <%= session.getAttribute("nombreUsuario") %></h1>
                <p class="subtitulo-registro fs-5 mb-4">Publica propiedades, organiza tus citas y atiende las solicitudes de tus clientes.</p>
            </div>
            <div class="col-lg-4">
                <div class="card-registro">
                    <h2 class="h4 mb-3">Gestiona tu inventario</h2>
                    <p class="subtitulo-registro mb-4">Ten tus inmuebles y oportunidades organizados para dar una mejor atención.</p>
                    <a href="<%= request.getContextPath() %>/inmobiliaria/propiedades.jsp" class="btn-detalles d-block text-center mb-2">Mis propiedades</a>
                    <a href="<%= request.getContextPath() %>/inmobiliaria/citas.jsp" class="btn-detalles d-block text-center mb-2">Citas</a>
                    <a href="<%= request.getContextPath() %>/inmobiliaria/solicitudes.jsp" class="btn-detalles d-block text-center">Solicitudes</a>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>