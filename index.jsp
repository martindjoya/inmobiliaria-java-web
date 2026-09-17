<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Object idUsuario = session.getAttribute("idUsuario");
    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    String rolUsuario = (String) session.getAttribute("rolUsuario");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dream House S.A.</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>

    <!-- NAVBAR -->
    <nav class="navbar navbar-expand-lg navbar-dh px-4">
        <a class="navbar-brand marca" href="index.jsp">Dream House S.A.</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#menuPrincipal">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="menuPrincipal">
            <ul class="navbar-nav align-items-lg-center gap-lg-2">
                <li class="nav-item"><a class="nav-link" href="#inicio">Inicio</a></li>
                <li class="nav-item"><a class="nav-link" href="#propiedades">Propiedades</a></li>
                <li class="nav-item"><a class="nav-link" href="#nosotros">Nosotros</a></li>
                <li class="nav-item"><a class="nav-link" href="#contacto">Contacto</a></li>
                <% if (idUsuario == null) { %>
                    <li class="nav-item">
                        <a class="btn-login ms-lg-3" href="login.jsp">Iniciar sesión</a>
                    </li>
                <% } else { %>
                    <li class="nav-item"><span class="nav-link">Hola, <%= nombreUsuario %> (<%= rolUsuario %>)</span></li>
                    <li class="nav-item"><a class="btn-login ms-lg-3" href="logout.jsp">Cerrar sesion</a></li>
                <% } %>
            </ul>
        </div>
    </nav>

    <!-- HERO -->
    <section id="inicio" class="hero d-flex align-items-center">
        <div class="container text-center text-white">
            <h1 class="hero-titulo">Encuentra un lugar que se sienta como hogar</h1>
            <p class="hero-subtitulo">Dream House S.A. — inmobiliaria boutique con propiedades seleccionadas para ti</p>
            <a href="#propiedades" class="btn-explorar">Explorar propiedades</a>
        </div>
    </section>

    <!-- BÚSQUEDA VISUAL (sin lógica, solo maqueta) -->
    <section class="buscador-wrapper">
        <div class="container">
            <form class="buscador row g-3 align-items-end justify-content-center">
                <div class="col-md-3">
                    <label class="form-label">Tipo de propiedad</label>
                    <select class="form-select">
                        <option>Casa</option>
                        <option>Apartamento</option>
                        <option>Local comercial</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Ciudad</label>
                    <select class="form-select">
                        <option>Bucaramanga</option>
                        <option>Floridablanca</option>
                        <option>Girón</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Operación</label>
                    <select class="form-select">
                        <option>Venta</option>
                        <option>Alquiler</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="button" class="btn-buscar w-100">Buscar</button>
                </div>
            </form>
        </div>
    </section>

    <!-- PROPIEDADES DESTACADAS -->
    <section id="propiedades" class="container py-5">
        <h2 class="titulo-seccion text-center mb-5">Propiedades destacadas</h2>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="tarjeta-propiedad">
                    <img src="https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=500" alt="Casa Campestre">
                    <div class="tarjeta-body">
                        <span class="etiqueta">Casa</span>
                        <h5>Casa Campestre</h5>
                        <p class="ciudad">Bucaramanga</p>
                        <p class="caracteristicas">3 hab · 2 baños · jardín amplio</p>
                        <p class="precio">$450.000.000 <span>(precio ficticio)</span></p>
                        <a href="#" class="btn-detalles">Ver detalles</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="tarjeta-propiedad">
                    <img src="https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500" alt="Apartamento Centro">
                    <div class="tarjeta-body">
                        <span class="etiqueta">Apartamento</span>
                        <h5>Apartamento Centro</h5>
                        <p class="ciudad">Floridablanca</p>
                        <p class="caracteristicas">2 hab · cerca a zona comercial</p>
                        <p class="precio">$280.000.000 <span>(precio ficticio)</span></p>
                        <a href="#" class="btn-detalles">Ver detalles</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="tarjeta-propiedad">
                    <img src="https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=500" alt="Casa Familiar">
                    <div class="tarjeta-body">
                        <span class="etiqueta">Casa</span>
                        <h5>Casa Familiar</h5>
                        <p class="ciudad">Girón</p>
                        <p class="caracteristicas">4 hab · garaje doble · terraza</p>
                        <p class="precio">$520.000.000 <span>(precio ficticio)</span></p>
                        <a href="#" class="btn-detalles">Ver detalles</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- SOBRE DREAM HOUSE -->
    <section id="nosotros" class="seccion-nosotros py-5">
        <div class="container text-center">
            <h2 class="titulo-seccion mb-4">Sobre Dream House S.A.</h2>
            <p class="texto-nosotros mx-auto">
                En Dream House S.A. acompañamos a cada cliente en la búsqueda de un espacio que se ajuste
                a su estilo de vida. Combinamos atención cercana con una selección cuidada de propiedades,
                ofreciendo un proceso simple, transparente y confiable.
            </p>
        </div>
    </section>

    <!-- LLAMADO A LA ACCIÓN -->
    <section class="cta text-center">
        <div class="container">
            <h2>¿Listo para encontrar tu próximo hogar?</h2>
            <p>Explora nuestras propiedades y encuentra tu próximo hogar.</p>
            <% if (idUsuario != null && "Administrador".equalsIgnoreCase(rolUsuario)) { %>
                <a href="admin/inicio.jsp" class="btn-cta btn-cta-outline">Ir al panel</a>
            <% } else if (idUsuario != null && "Inmobiliaria".equalsIgnoreCase(rolUsuario)) { %>
                <a href="inmobiliaria/inicio.jsp" class="btn-cta btn-cta-outline">Ir al panel</a>
            <% } else if (idUsuario != null) { %>
                <a href="cliente/inicio.jsp" class="btn-cta btn-cta-outline">Ir a mi panel</a>
            <% } %>
        </div>
    </section>

    <!-- FOOTER -->
    <footer id="contacto" class="footer-dh py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <h5>Dream House S.A.</h5>
                    <p>Inmobiliaria boutique dedicada a encontrar el hogar ideal para cada cliente.</p>
                </div>
                <div class="col-md-4 mb-3">
                    <h5>Enlaces</h5>
                    <ul class="lista-footer">
                        <li><a href="#inicio">Inicio</a></li>
                        <li><a href="#propiedades">Propiedades</a></li>
                        <li><a href="#nosotros">Nosotros</a></li>
                    </ul>
                </div>
                <div class="col-md-4 mb-3">
                    <h5>Contacto</h5>
                    <p>contacto@dreamhouse.ejemplo<br>+57 300 000 0000<br>Bucaramanga, Colombia</p>
                </div>
            </div>
            <hr>
            <p class="text-center mb-0">&copy; 2026 Dream House S.A. — Todos los derechos reservados.</p>
        </div>
    </footer>

</body>
</html>
