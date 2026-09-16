<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%
    String nombre = request.getParameter("nombre");
    String email = request.getParameter("email");
    String telefono = request.getParameter("telefono");
    String direccion = request.getParameter("direccion");
    String contrasena = request.getParameter("contrasena");
    String confirmarContrasena = request.getParameter("confirmarContrasena");

    if (email != null) email = email.trim().toLowerCase();
    if (telefono != null) telefono = telefono.trim();

    String error = null;
    Pattern patronEmail = Pattern.compile("^[\\w.+-]+@[\\w-]+\\.[a-zA-Z]{2,}$");
    Pattern patronTelefono = Pattern.compile("^[0-9+() -]{7,20}$");

    if (nombre == null || nombre.trim().isEmpty()
            || email == null || email.trim().isEmpty()
            || contrasena == null || contrasena.trim().isEmpty()) {
        error = "Todos los campos obligatorios deben estar completos.";
    } else if (!patronEmail.matcher(email).matches()) {
        error = "El correo electrónico no tiene un formato válido.";
    } else if (telefono != null && !telefono.isEmpty() && !patronTelefono.matcher(telefono).matches()) {
        error = "El teléfono no tiene un formato válido.";
    } else if (contrasena.length() < 6) {
        error = "La contraseña debe tener al menos 6 caracteres.";
    } else if (!contrasena.equals(confirmarContrasena)) {
        error = "Las contraseñas no coinciden.";
    }

    if (error == null) {
        Connection con = null;
        try {
            con = ConexionBD.obtenerConexion();

            // Verificar correo duplicado
            PreparedStatement psVerificar = con.prepareStatement(
                "SELECT id_usuario FROM usuario WHERE email = ?");
            psVerificar.setString(1, email);
            ResultSet rsVerificar = psVerificar.executeQuery();
            if (rsVerificar.next()) {
                error = "Ya existe una cuenta registrada con ese correo electrónico.";
            }
            rsVerificar.close();
            psVerificar.close();

            if (error == null) {
                con.setAutoCommit(false);

                String contrasenaHasheada = BCrypt.hashpw(contrasena, BCrypt.gensalt());

                // Insertar usuario
                PreparedStatement psUsuario = con.prepareStatement(
                    "INSERT INTO usuario (nombre, email, contrasena, fecha_registro, activo) VALUES (?, ?, ?, NOW(), 1)",
                    PreparedStatement.RETURN_GENERATED_KEYS);
                psUsuario.setString(1, nombre);
                psUsuario.setString(2, email);
                psUsuario.setString(3, contrasenaHasheada);
                psUsuario.executeUpdate();

                ResultSet claves = psUsuario.getGeneratedKeys();
                int idUsuario = -1;
                if (claves.next()) {
                    idUsuario = claves.getInt(1);
                }
                claves.close();
                psUsuario.close();

                // Insertar perfil
                PreparedStatement psPerfil = con.prepareStatement(
                    "INSERT INTO perfil (id_usuario, telefono, direccion) VALUES (?, ?, ?)");
                psPerfil.setInt(1, idUsuario);
                psPerfil.setString(2, telefono);
                psPerfil.setString(3, direccion);
                psPerfil.executeUpdate();
                psPerfil.close();

                // Buscar el id del rol "Cliente"
                PreparedStatement psRol = con.prepareStatement(
                    "SELECT id_rol FROM rol WHERE nombre = ?");
                psRol.setString(1, "Cliente");
                ResultSet rsRol = psRol.executeQuery();
                int idRol = -1;
                if (rsRol.next()) {
                    idRol = rsRol.getInt("id_rol");
                }
                rsRol.close();
                psRol.close();

                if (idRol == -1) {
                    throw new SQLException("No existe el rol 'Cliente' en la base de datos. Debe insertarse primero en la tabla rol.");
                }

                // Insertar usuario_rol
                PreparedStatement psUsuarioRol = con.prepareStatement(
                    "INSERT INTO usuario_rol (id_usuario, id_rol) VALUES (?, ?)");
                psUsuarioRol.setInt(1, idUsuario);
                psUsuarioRol.setInt(2, idRol);
                psUsuarioRol.executeUpdate();
                psUsuarioRol.close();

                con.commit();
            }
        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { }
            }
            error = "Ocurrió un error al registrar el usuario. Intenta nuevamente más tarde.";
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException ex) { }
            }
        }
    }

    if (error != null) {
        request.setAttribute("error", error);
        request.setAttribute("nombreValor", nombre);
        request.setAttribute("emailValor", email);
        request.setAttribute("telefonoValor", telefono);
        request.setAttribute("direccionValor", direccion);
        request.getRequestDispatcher("registro.jsp").forward(request, response);
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro exitoso - Dream House S.A.</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/estilos.css">
</head>
<body>
    <section class="seccion-registro py-5">
        <div class="container text-center">
            <h2 class="titulo-seccion mb-3">¡Registro exitoso!</h2>
            <p class="subtitulo-registro mb-4">Tu cuenta en Dream House S.A. ha sido creada correctamente.</p>
            <a href="index.jsp" class="btn-explorar">Ir al inicio</a>
        </div>
    </section>
</body>
</html>