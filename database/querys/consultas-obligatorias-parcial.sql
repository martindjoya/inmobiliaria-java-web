USE dream_house;

-- 1. INNER JOIN de tres o mas tablas: propiedades con ciudad, tipo y agencia.
SELECT p.id_propiedad, p.matricula_inmobiliaria, p.titulo,
       c.nombre AS ciudad, tp.nombre AS tipo,
       i.nombre_comercial AS inmobiliaria
FROM propiedad p
INNER JOIN ciudad c ON c.id_ciudad = p.id_ciudad
INNER JOIN tipo_propiedad tp ON tp.id_tipo = p.id_tipo
INNER JOIN inmobiliaria i ON i.id_inmobiliaria = p.id_inmobiliaria
ORDER BY p.titulo;

-- 2. INNER JOIN de tres o mas tablas: solicitudes con cliente, inmueble y agencia.
SELECT s.id_solicitud, s.estado, s.tipo_solicitud,
       u.nombre AS cliente, p.titulo AS propiedad,
       i.nombre_comercial AS inmobiliaria
FROM solicitud s
INNER JOIN usuario u ON u.id_usuario = s.id_usuario
INNER JOIN propiedad p ON p.id_propiedad = s.id_propiedad
INNER JOIN inmobiliaria i ON i.id_inmobiliaria = p.id_inmobiliaria
ORDER BY s.fecha_solicitud DESC;

-- 3. Consulta de relacion N:M: caracteristicas de cada propiedad.
SELECT p.titulo, c.nombre AS caracteristica
FROM propiedad p
INNER JOIN propiedad_caracteristica pc ON pc.id_propiedad = p.id_propiedad
INNER JOIN caracteristica c ON c.id_caracteristica = pc.id_caracteristica
ORDER BY p.titulo, c.nombre;

-- 4. LEFT JOIN: propiedades que aun no tienen citas.
SELECT p.id_propiedad, p.titulo, i.nombre_comercial AS inmobiliaria
FROM propiedad p
INNER JOIN inmobiliaria i ON i.id_inmobiliaria = p.id_inmobiliaria
LEFT JOIN cita c ON c.id_propiedad = p.id_propiedad
WHERE c.id_cita IS NULL
ORDER BY p.titulo;

-- 5. GROUP BY y HAVING: ciudades con dos o mas propiedades disponibles.
SELECT c.nombre AS ciudad, COUNT(*) AS total_disponibles
FROM propiedad p
INNER JOIN ciudad c ON c.id_ciudad = p.id_ciudad
WHERE p.estado = 'disponible'
GROUP BY c.id_ciudad, c.nombre
HAVING COUNT(*) >= 2
ORDER BY total_disponibles DESC, c.nombre;
