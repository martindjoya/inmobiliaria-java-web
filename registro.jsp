<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Dream House S.A.</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dh px-4">
        <a class="navbar-brand marca" href="index.jsp">Dream House S.A.</a>
    </nav>

    <section class="seccion-registro py-5">
        <div class="container d-flex justify-content-center">
            <div class="card-registro">
                <h2 class="titulo-seccion text-center mb-2">Crear cuenta</h2>
                <p class="subtitulo-registro text-center mb-4">Únete a Dream House S.A. y guarda tus propiedades favoritas</p>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alerta-error">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="procesar-registro.jsp" method="post">
                    <div class="mb-3">
                        <label class="form-label">Nombre completo</label>
                        <input type="text" class="form-control" name="nombre" required
                               value="<%= request.getAttribute("nombreValor") != null ? request.getAttribute("nombreValor") : "" %>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Correo electrónico</label>
                        <input type="email" class="form-control" name="email" required
                               value="<%= request.getAttribute("emailValor") != null ? request.getAttribute("emailValor") : "" %>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Teléfono</label>
                           <input type="tel" class="form-control" name="telefono"
                               pattern="[0-9+() -]{7,20}"
                               title="Ingresa un teléfono válido de 7 a 20 caracteres."
                               value="<%= request.getAttribute("telefonoValor") != null ? request.getAttribute("telefonoValor") : "" %>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Dirección</label>
                        <input type="text" class="form-control" name="direccion"
                               value="<%= request.getAttribute("direccionValor") != null ? request.getAttribute("direccionValor") : "" %>">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Contraseña</label>
                        <input type="password" class="form-control" name="contrasena" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Confirmar contraseña</label>
                        <input type="password" class="form-control" name="confirmarContrasena" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Rol asignado</label>
                        <input type="text" class="form-control" value="Cliente" readonly>
                        <small class="text-muted">Las cuentas nuevas se registran como Cliente.</small>
                    </div>
                    <button type="submit" class="btn-explorar w-100">Registrarme</button>
                </form>
            </div>
        </div>
    </section>

</body>
</html>