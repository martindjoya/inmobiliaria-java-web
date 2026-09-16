<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="conexion.ConexionBD" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%
    String email = request.getParameter("email");
    String contrasena = request.getParameter("contrasena");

    String error = null;

    if (email == null || email.trim().isEmpty()
            || contrasena == null || contrasena.trim().isEmpty()) {
        error = "Debes ingresar el correo y la contraseña.";
    }

    if (error == null) {
        Connection con = null;
        try {
            con = ConexionBD.obtenerConexion();

            PreparedStatement psUsuario = con.prepareStatement(
                "SELECT id_usuario, nombre, contrasena, activo FROM usuario WHERE email = ?");
            psUsuario.setString(1, email);
            ResultSet rsUsuario = psUsuario.executeQuery();

            if (!rsUsuario.next()) {
                error = "Correo o contraseña incorrectos.";
            } else {
                int idUsuario = rsUsuario.getInt("id_usuario");
                String nombre = rsUsuario.getString("nombre");
                String hashGuardado = rsUsuario.getString("contrasena");
                boolean activo = rsUsuario.getBoolean("activo");

                if (!activo) {
                    error = "Esta cuenta se encuentra inactiva.";
                } else if (!BCrypt.checkpw(contrasena, hashGuardado)) {
                    error = "Correo o contraseña incorrectos.";
                } else {
                    // Buscar el rol del usuario
                    PreparedStatement psRol = con.prepareStatement(
                        "SELECT r.nombre AS nombre_rol " +
                        "FROM rol r " +
                        "INNER JOIN usuario_rol ur ON r.id_rol = ur.id_rol " +
                        "WHERE ur.id_usuario = ? LIMIT 1");
                    psRol.setInt(1, idUsuario);
                    ResultSet rsRol = psRol.executeQuery();

                    String nombreRol = null;
                    if (rsRol.next()) {
                        nombreRol = rsRol.getString("nombre_rol");
                    }
                    rsRol.close();
                    psRol.close();

                    if (nombreRol == null) {
                        error = "El usuario no tiene un rol asignado. Contacta al administrador.";
                    } else {
                        session.setAttribute("idUsuario", idUsuario);
                        session.setAttribute("nombreUsuario", nombre);
                        session.setAttribute("rolUsuario", nombreRol);

                        if (nombreRol.equals("Administrador")) {
                            response.sendRedirect("bienvenida-admin.jsp");
                        } else if (nombreRol.equals("Inmobiliaria")) {
                            response.sendRedirect("bienvenida-agente.jsp");
                        } else {
                            response.sendRedirect("bienvenida-cliente.jsp");
                        }
                        return;
                    }
                }
            }
            rsUsuario.close();
            psUsuario.close();
        } catch (SQLException e) {
            error = "Ocurrió un error al iniciar sesión. Intenta nuevamente más tarde.";
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException ex) { }
            }
        }
    }

    if (error != null) {
        request.setAttribute("error", error);
        request.setAttribute("emailValor", email);
        request.getRequestDispatcher("login.jsp").forward(request, response);
        return;
    }
%>