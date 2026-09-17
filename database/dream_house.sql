-- =====================================================
-- DREAM HOUSE S.A. - Estructura de base de datos
-- Motor: InnoDB | Codificación: utf8mb4
-- =====================================================

CREATE DATABASE IF NOT EXISTS dream_house
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE dream_house;

-- ROLES DEL SISTEMA
CREATE TABLE rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

INSERT IGNORE INTO rol (nombre)
VALUES ('Cliente'), ('Inmobiliaria'), ('Administrador');

-- USUARIOS
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo TINYINT(1) DEFAULT 1
) ENGINE=InnoDB;

-- RELACIÓN USUARIO-ROL (un usuario puede tener varios roles)
CREATE TABLE usuario_rol (
    id_usuario INT NOT NULL,
    id_rol INT NOT NULL,
    PRIMARY KEY (id_usuario, id_rol),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON DELETE CASCADE
) ENGINE=InnoDB;

-- PERFIL (datos adicionales del usuario)
CREATE TABLE perfil (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    foto_url VARCHAR(255),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- INMOBILIARIA / AGENCIA
CREATE TABLE inmobiliaria (
    id_inmobiliaria INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    nombre_comercial VARCHAR(150) NOT NULL,
    nit VARCHAR(30),
    telefono_contacto VARCHAR(20),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- CIUDAD
CREATE TABLE ciudad (
    id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    departamento VARCHAR(100)
) ENGINE=InnoDB;

-- TIPO DE PROPIEDAD (casa, apartamento, local, etc.)
CREATE TABLE tipo_propiedad (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- PROPIEDAD
CREATE TABLE propiedad (
    id_propiedad INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(14,2) NOT NULL,
    operacion ENUM('venta','alquiler') NOT NULL,
    habitaciones INT DEFAULT 0,
    banos INT DEFAULT 0,
    area_m2 DECIMAL(8,2),
    estado ENUM('disponible','reservada','vendida','alquilada') DEFAULT 'disponible',
    fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_ciudad INT NOT NULL,
    id_tipo INT NOT NULL,
    id_inmobiliaria INT NOT NULL,
    FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad),
    FOREIGN KEY (id_tipo) REFERENCES tipo_propiedad(id_tipo),
    FOREIGN KEY (id_inmobiliaria) REFERENCES inmobiliaria(id_inmobiliaria)
) ENGINE=InnoDB;

-- IMÁGENES DE LA PROPIEDAD
CREATE TABLE imagen_propiedad (
    id_imagen INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    url_imagen VARCHAR(255) NOT NULL,
    es_principal TINYINT(1) DEFAULT 0,
    FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB;

-- CARACTERÍSTICA (piscina, garaje, jardín, etc.)
CREATE TABLE caracteristica (
    id_caracteristica INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- RELACIÓN PROPIEDAD-CARACTERÍSTICA
CREATE TABLE propiedad_caracteristica (
    id_propiedad INT NOT NULL,
    id_caracteristica INT NOT NULL,
    PRIMARY KEY (id_propiedad, id_caracteristica),
    FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE,
    FOREIGN KEY (id_caracteristica) REFERENCES caracteristica(id_caracteristica) ON DELETE CASCADE
) ENGINE=InnoDB;

-- CITA (visita a una propiedad)
CREATE TABLE cita (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    id_usuario INT NOT NULL,
    fecha_cita DATETIME NOT NULL,
    estado ENUM('pendiente','confirmada','cancelada','realizada') DEFAULT 'pendiente',
    FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

-- SOLICITUD (interés formal de compra/alquiler)
CREATE TABLE solicitud (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT NOT NULL,
    id_usuario INT NOT NULL,
    tipo_solicitud VARCHAR(50) NOT NULL,
    fecha_solicitud DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('pendiente','en_revision','aprobada','rechazada') DEFAULT 'pendiente',
    FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

-- DOCUMENTOS ADJUNTOS A UNA SOLICITUD
CREATE TABLE documento_solicitud (
    id_documento INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT NOT NULL,
    nombre_archivo VARCHAR(200) NOT NULL,
    ruta_archivo VARCHAR(255) NOT NULL,
    fecha_subida DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_solicitud) REFERENCES solicitud(id_solicitud) ON DELETE CASCADE
) ENGINE=InnoDB;

-- FAVORITOS
CREATE TABLE favorito (
    id_favorito INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_propiedad INT NOT NULL,
    fecha_agregado DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_usuario_propiedad (id_usuario, id_propiedad),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_propiedad) REFERENCES propiedad(id_propiedad) ON DELETE CASCADE
) ENGINE=InnoDB;

-- AUDITORÍA (registro de acciones del sistema)
CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    accion VARCHAR(100) NOT NULL,
    tabla_afectada VARCHAR(50),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    detalle TEXT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB;
