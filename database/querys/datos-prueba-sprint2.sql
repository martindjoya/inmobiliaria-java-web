USE dream_house;

START TRANSACTION;

INSERT INTO usuario (nombre, email, contrasena, activo)
SELECT 'Agente Demo', 'agente.demo@dreamhouse.local', '$2a$10$yqH81/pPY9IxjME8qko0J.zi30lEWX3g6xdrbDMZoXVw1akhRGtYe', 1
WHERE NOT EXISTS (
    SELECT 1 FROM usuario WHERE email = 'agente.demo@dreamhouse.local'
);

SET @id_agente = (SELECT id_usuario FROM usuario WHERE email = 'agente.demo@dreamhouse.local');
SET @id_rol_inmobiliaria = (SELECT id_rol FROM rol WHERE nombre = 'Inmobiliaria');

INSERT IGNORE INTO usuario_rol (id_usuario, id_rol)
VALUES (@id_agente, @id_rol_inmobiliaria);

INSERT INTO usuario (nombre, email, contrasena, activo)
SELECT 'Cliente Demo', 'cliente.demo@dreamhouse.local', '$2a$10$yqH81/pPY9IxjME8qko0J.zi30lEWX3g6xdrbDMZoXVw1akhRGtYe', 1
WHERE NOT EXISTS (
    SELECT 1 FROM usuario WHERE email = 'cliente.demo@dreamhouse.local'
);

SET @id_cliente = (SELECT id_usuario FROM usuario WHERE email = 'cliente.demo@dreamhouse.local');
SET @id_rol_cliente = (SELECT id_rol FROM rol WHERE nombre = 'Cliente');

INSERT IGNORE INTO usuario_rol (id_usuario, id_rol)
VALUES (@id_cliente, @id_rol_cliente);

INSERT INTO perfil (id_usuario, telefono, direccion)
SELECT @id_cliente, '3007654321', 'Calle Demo 123'
WHERE NOT EXISTS (
    SELECT 1 FROM perfil WHERE id_usuario = @id_cliente
);

INSERT INTO inmobiliaria (id_usuario, nombre_comercial, nit, telefono_contacto)
SELECT @id_agente, 'Dream House Demo', '900123456-7', '3001234567'
WHERE NOT EXISTS (
    SELECT 1 FROM inmobiliaria WHERE id_usuario = @id_agente
);

INSERT INTO ciudad (nombre, departamento)
SELECT 'Bucaramanga', 'Santander'
WHERE NOT EXISTS (SELECT 1 FROM ciudad WHERE nombre = 'Bucaramanga' AND departamento = 'Santander');
INSERT INTO ciudad (nombre, departamento)
SELECT 'Floridablanca', 'Santander'
WHERE NOT EXISTS (SELECT 1 FROM ciudad WHERE nombre = 'Floridablanca' AND departamento = 'Santander');
INSERT INTO ciudad (nombre, departamento)
SELECT 'Giron', 'Santander'
WHERE NOT EXISTS (SELECT 1 FROM ciudad WHERE nombre = 'Giron' AND departamento = 'Santander');

INSERT IGNORE INTO tipo_propiedad (nombre) VALUES ('Casa'), ('Apartamento'), ('Local comercial');
INSERT IGNORE INTO caracteristica (nombre) VALUES ('Piscina'), ('Garaje'), ('Jardin'), ('Terraza');

SET @id_inmobiliaria = (SELECT id_inmobiliaria FROM inmobiliaria WHERE id_usuario = @id_agente);
SET @id_bucaramanga = (SELECT id_ciudad FROM ciudad WHERE nombre = 'Bucaramanga' LIMIT 1);
SET @id_floridablanca = (SELECT id_ciudad FROM ciudad WHERE nombre = 'Floridablanca' LIMIT 1);
SET @id_giron = (SELECT id_ciudad FROM ciudad WHERE nombre = 'Giron' LIMIT 1);
SET @id_casa = (SELECT id_tipo FROM tipo_propiedad WHERE nombre = 'Casa');
SET @id_apartamento = (SELECT id_tipo FROM tipo_propiedad WHERE nombre = 'Apartamento');
SET @id_local = (SELECT id_tipo FROM tipo_propiedad WHERE nombre = 'Local comercial');

INSERT INTO propiedad (titulo, descripcion, precio, operacion, habitaciones, banos, area_m2, estado, id_ciudad, id_tipo, id_inmobiliaria)
SELECT 'Casa Campestre Demo', 'Casa amplia con jardin y piscina.', 450000000, 'venta', 3, 2, 180, 'disponible', @id_bucaramanga, @id_casa, @id_inmobiliaria
WHERE NOT EXISTS (SELECT 1 FROM propiedad WHERE titulo = 'Casa Campestre Demo');
INSERT INTO propiedad (titulo, descripcion, precio, operacion, habitaciones, banos, area_m2, estado, id_ciudad, id_tipo, id_inmobiliaria)
SELECT 'Apartamento Centro Demo', 'Apartamento cercano a servicios y transporte.', 280000000, 'venta', 2, 2, 85, 'disponible', @id_floridablanca, @id_apartamento, @id_inmobiliaria
WHERE NOT EXISTS (SELECT 1 FROM propiedad WHERE titulo = 'Apartamento Centro Demo');
INSERT INTO propiedad (titulo, descripcion, precio, operacion, habitaciones, banos, area_m2, estado, id_ciudad, id_tipo, id_inmobiliaria)
SELECT 'Local Comercial Demo', 'Local para actividad comercial.', 2500000, 'alquiler', 0, 1, 60, 'disponible', @id_giron, @id_local, @id_inmobiliaria
WHERE NOT EXISTS (SELECT 1 FROM propiedad WHERE titulo = 'Local Comercial Demo');

SET @id_casa_demo = (SELECT id_propiedad FROM propiedad WHERE titulo = 'Casa Campestre Demo');
SET @id_apto_demo = (SELECT id_propiedad FROM propiedad WHERE titulo = 'Apartamento Centro Demo');
SET @id_local_demo = (SELECT id_propiedad FROM propiedad WHERE titulo = 'Local Comercial Demo');
SET @id_piscina = (SELECT id_caracteristica FROM caracteristica WHERE nombre = 'Piscina');
SET @id_garaje = (SELECT id_caracteristica FROM caracteristica WHERE nombre = 'Garaje');
SET @id_jardin = (SELECT id_caracteristica FROM caracteristica WHERE nombre = 'Jardin');
SET @id_terraza = (SELECT id_caracteristica FROM caracteristica WHERE nombre = 'Terraza');

INSERT IGNORE INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES
    (@id_casa_demo, @id_piscina),
    (@id_casa_demo, @id_garaje),
    (@id_casa_demo, @id_jardin),
    (@id_apto_demo, @id_garaje),
    (@id_apto_demo, @id_terraza),
    (@id_local_demo, @id_terraza);

INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal)
SELECT @id_casa_demo, 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=900', 1
WHERE NOT EXISTS (SELECT 1 FROM imagen_propiedad WHERE id_propiedad = @id_casa_demo);
INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal)
SELECT @id_apto_demo, 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=900', 1
WHERE NOT EXISTS (SELECT 1 FROM imagen_propiedad WHERE id_propiedad = @id_apto_demo);
INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal)
SELECT @id_local_demo, 'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=900', 1
WHERE NOT EXISTS (SELECT 1 FROM imagen_propiedad WHERE id_propiedad = @id_local_demo);

COMMIT;
