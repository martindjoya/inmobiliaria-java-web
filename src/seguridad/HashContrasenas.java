package seguridad;

import org.mindrot.jbcrypt.BCrypt;

public final class HashContrasenas {

    private HashContrasenas() {
    }

    public static String generar(String contrasena) {
        return BCrypt.hashpw(contrasena, BCrypt.gensalt());
    }

    public static boolean coincide(String contrasena, String hash) {
        try {
            return BCrypt.checkpw(contrasena, hash);
        } catch (Exception error) {
            return false;
        }
    }
}
