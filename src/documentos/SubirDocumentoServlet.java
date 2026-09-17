package documentos;

import conexion.ConexionBD;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 6 * 1024 * 1024
)
public class SubirDocumentoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String[] EXTENSIONES_PERMITIDAS = {"pdf", "jpg", "jpeg", "png"};

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Object idUsuario = session == null ? null : session.getAttribute("idUsuario");
        String idSolicitudTexto = request.getParameter("id_solicitud");

        if (idUsuario == null || idSolicitudTexto == null) {
            redirigirConError(request, response, null, "acceso");
            return;
        }

        int idSolicitud;
        try {
            idSolicitud = Integer.parseInt(idSolicitudTexto);
        } catch (NumberFormatException exception) {
            redirigirConError(request, response, null, "solicitud");
            return;
        }

        Part archivo = request.getPart("archivo");
        String nombreOriginal = archivo == null ? null : Paths.get(archivo.getSubmittedFileName()).getFileName().toString();
        String extension = obtenerExtension(nombreOriginal);

        if (archivo == null || archivo.getSize() == 0 || nombreOriginal == null || nombreOriginal.trim().isEmpty()) {
            redirigirConError(request, response, idSolicitud, "vacio");
            return;
        }
        if (archivo.getSize() > 5 * 1024 * 1024) {
            redirigirConError(request, response, idSolicitud, "tamano");
            return;
        }
        if (!extensionPermitida(extension)) {
            redirigirConError(request, response, idSolicitud, "extension");
            return;
        }

        Connection conexion = null;
        Path archivoGuardado = null;
        try {
            conexion = ConexionBD.obtenerConexion();
            if (!perteneceSolicitud(conexion, idSolicitud, (Integer) idUsuario)) {
                redirigirConError(request, response, null, "solicitud");
                return;
            }
            if (existeDocumento(conexion, idSolicitud, nombreOriginal)) {
                redirigirConError(request, response, idSolicitud, "duplicado");
                return;
            }

            Path directorio = Paths.get(getServletContext().getRealPath("/WEB-INF/uploads/documentos"), String.valueOf(idSolicitud));
            Files.createDirectories(directorio);
            String nombreSeguro = System.currentTimeMillis() + "_" + nombreOriginal;
            archivoGuardado = directorio.resolve(nombreSeguro).normalize();
            if (!archivoGuardado.startsWith(directorio.toAbsolutePath().normalize())) {
                redirigirConError(request, response, idSolicitud, "archivo");
                return;
            }

            try (InputStream entrada = archivo.getInputStream()) {
                Files.copy(entrada, archivoGuardado, StandardCopyOption.REPLACE_EXISTING);
            }

            PreparedStatement insertar = conexion.prepareStatement(
                "INSERT INTO documento_solicitud (id_solicitud, nombre_archivo, ruta_archivo) VALUES (?, ?, ?)");
            insertar.setInt(1, idSolicitud);
            insertar.setString(2, nombreOriginal);
            insertar.setString(3, "/WEB-INF/uploads/documentos/" + idSolicitud + "/" + nombreSeguro);
            insertar.executeUpdate();
            insertar.close();
            response.sendRedirect(request.getContextPath() + "/cliente/documentos.jsp?id_solicitud=" + idSolicitud + "&subida=ok");
        } catch (Exception exception) {
            if (archivoGuardado != null) {
                try { Files.deleteIfExists(archivoGuardado); } catch (IOException ignored) { }
            }
            redirigirConError(request, response, idSolicitud, "general");
        } finally {
            if (conexion != null) {
                try { conexion.close(); } catch (Exception ignored) { }
            }
        }
    }

    private boolean perteneceSolicitud(Connection conexion, int idSolicitud, int idUsuario) throws Exception {
        PreparedStatement consulta = conexion.prepareStatement(
            "SELECT id_solicitud FROM solicitud WHERE id_solicitud = ? AND id_usuario = ?");
        consulta.setInt(1, idSolicitud);
        consulta.setInt(2, idUsuario);
        ResultSet resultado = consulta.executeQuery();
        boolean pertenece = resultado.next();
        resultado.close();
        consulta.close();
        return pertenece;
    }

    private boolean existeDocumento(Connection conexion, int idSolicitud, String nombreArchivo) throws Exception {
        PreparedStatement consulta = conexion.prepareStatement(
            "SELECT id_documento FROM documento_solicitud WHERE id_solicitud = ? AND nombre_archivo = ?");
        consulta.setInt(1, idSolicitud);
        consulta.setString(2, nombreArchivo);
        ResultSet resultado = consulta.executeQuery();
        boolean existe = resultado.next();
        resultado.close();
        consulta.close();
        return existe;
    }

    private String obtenerExtension(String nombreArchivo) {
        if (nombreArchivo == null) return "";
        int punto = nombreArchivo.lastIndexOf('.');
        return punto < 0 ? "" : nombreArchivo.substring(punto + 1).toLowerCase();
    }

    private boolean extensionPermitida(String extension) {
        for (String permitida : EXTENSIONES_PERMITIDAS) {
            if (permitida.equals(extension)) return true;
        }
        return false;
    }

    private void redirigirConError(HttpServletRequest request, HttpServletResponse response,
            Integer idSolicitud, String error) throws IOException {
        String destino = request.getContextPath() + "/cliente/documentos.jsp";
        if (idSolicitud != null) destino += "?id_solicitud=" + idSolicitud + "&error=" + error;
        response.sendRedirect(destino);
    }
}