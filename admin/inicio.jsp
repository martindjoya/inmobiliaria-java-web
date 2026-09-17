<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String rolRequerido = "ADMINISTRADOR";
%>
<%@ include file="/WEB-INF/jspf/seguridad.jspf" %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<section class="seccion-registro py-5">
    <div class="container text-center">
        <h2 class="titulo-seccion mb-3">Hola, <%= session.getAttribute("nombreUsuario") %></h2>
        <p class="subtitulo-registro mb-4">Panel de administración de Dream House S.A.</p>
        <p>Rol: <strong><%= session.getAttribute("rolUsuario") %></strong></p>
        <a href="<%= request.getContextPath() %>/index.jsp" class="btn-explorar me-2">Ir al inicio</a>
        <a href="<%= request.getContextPath() %>/admin/reportes.jsp" class="btn-explorar me-2">Ver reportes</a>
        <a href="<%= request.getContextPath() %>/logout.jsp" class="btn-explorar">Cerrar sesion</a>
    </div>
</section>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
