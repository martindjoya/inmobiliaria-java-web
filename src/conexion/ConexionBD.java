package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {

    private static final String URL_PUERTO_PRINCIPAL = "jdbc:mysql://localhost:3307/dream_house?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String URL_PUERTO_ALTERNATIVO = "jdbc:mysql://localhost:3306/dream_house?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USUARIO = "root";
    private static final String[] CONTRASENAS = { "", "1234" };
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // Lanzar RuntimeException evita tener que repetir la carga en cada llamada
            throw new ExceptionInInitializerError("Driver JDBC de MySQL no encontrado. Añade mysql-connector en el classpath.");
        }
    }

    public static Connection obtenerConexion() throws SQLException {
        String[] urls = { URL_PUERTO_PRINCIPAL, URL_PUERTO_ALTERNATIVO };
        SQLException ultimoError = null;

        for (String url : urls) {
            for (String contrasena : CONTRASENAS) {
                try {
                    return DriverManager.getConnection(url, USUARIO, contrasena);
                } catch (SQLException errorConexion) {
                    ultimoError = errorConexion;
                }
            }
        }

        throw ultimoError;
    }
}
