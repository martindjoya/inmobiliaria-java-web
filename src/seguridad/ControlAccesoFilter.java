package seguridad;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ControlAccesoFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest solicitud = (HttpServletRequest) request;
        HttpServletResponse respuesta = (HttpServletResponse) response;
        String ruta = solicitud.getRequestURI().substring(solicitud.getContextPath().length());
        String rolRequerido = obtenerRolRequerido(ruta);

        if (rolRequerido == null) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession sesion = solicitud.getSession(false);
        Object idUsuario = sesion == null ? null : sesion.getAttribute("idUsuario");
        Object rolUsuario = sesion == null ? null : sesion.getAttribute("rolUsuario");

        if (idUsuario == null || rolUsuario == null) {
            redirigirAccesoDenegado(solicitud, respuesta);
            return;
        }

        if (!rolRequerido.equalsIgnoreCase(String.valueOf(rolUsuario))) {
            redirigirAccesoDenegado(solicitud, respuesta);
            return;
        }

        chain.doFilter(request, response);
    }

    private String obtenerRolRequerido(String ruta) {
        if (ruta.startsWith("/admin/")) {
            return "ADMINISTRADOR";
        }
        if (ruta.startsWith("/inmobiliaria/")) {
            return "INMOBILIARIA";
        }
        if (ruta.startsWith("/cliente/")) {
            return "CLIENTE";
        }
        return null;
    }

    private void redirigirAccesoDenegado(HttpServletRequest solicitud, HttpServletResponse respuesta)
            throws IOException {
        respuesta.sendRedirect(solicitud.getContextPath() + "/acceso-denegado.jsp");
    }
}