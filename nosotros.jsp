<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

<main class="container py-5">
    <span class="etiqueta">Dream House S.A.</span>
    <h1 class="titulo-seccion mt-3">Sobre nosotros</h1>
    <p class="subtitulo-registro fs-5">Acompañamos a cada cliente en la búsqueda de un espacio que se ajuste a su estilo de vida.</p>
    <p>Combinamos atención cercana con una selección cuidada de propiedades para ofrecer un proceso simple, transparente y confiable.</p>
    <a href="<%= request.getContextPath() %>/index.jsp" class="btn-explorar">Volver al inicio</a>
</main>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>
