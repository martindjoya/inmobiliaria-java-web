USE dream_house;

INSERT IGNORE INTO rol (nombre)
VALUES ('Cliente'), ('Inmobiliaria'), ('Administrador');

-- Consultar el usuario
SELECT id_usuario, nombre, email
FROM usuario
WHERE email = 'usuario@ejemplo.com';

-- Consultar el rol
SELECT id_rol, nombre
FROM rol
WHERE nombre = 'Inmobiliaria';

-- Asignar el rol
INSERT INTO usuario_rol (id_usuario, id_rol)
VALUES (ID_USUARIO, ID_ROL);