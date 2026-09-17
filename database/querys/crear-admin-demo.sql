USE dream_house;

START TRANSACTION;

INSERT IGNORE INTO rol (nombre) VALUES ('Administrador');

INSERT INTO usuario (nombre, email, contrasena, activo)
SELECT 'Administrador Demo', 'admin.demo@dreamhouse.local', '$2a$10$yqH81/pPY9IxjME8qko0J.zi30lEWX3g6xdrbDMZoXVw1akhRGtYe', 1
WHERE NOT EXISTS (
    SELECT 1 FROM usuario WHERE email = 'admin.demo@dreamhouse.local'
);

SET @id_admin = (SELECT id_usuario FROM usuario WHERE email = 'admin.demo@dreamhouse.local');
SET @id_rol_admin = (SELECT id_rol FROM rol WHERE nombre = 'Administrador');

INSERT IGNORE INTO usuario_rol (id_usuario, id_rol)
VALUES (@id_admin, @id_rol_admin);

COMMIT;

SELECT u.id_usuario, u.nombre, u.email, u.activo, r.nombre AS rol
FROM usuario u
JOIN usuario_rol ur ON ur.id_usuario = u.id_usuario
JOIN rol r ON r.id_rol = ur.id_rol
WHERE u.email = 'admin.demo@dreamhouse.local';
