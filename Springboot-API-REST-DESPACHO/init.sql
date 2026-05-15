-- Script de inicialización para la base de datos de Despachos
-- Se ejecuta automáticamente al crear el contenedor MySQL

CREATE DATABASE IF NOT EXISTS despachos_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE despachos_db;

-- Tabla de Despachos
CREATE TABLE IF NOT EXISTS despacho (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero_despacho VARCHAR(50) NOT NULL UNIQUE,
    fecha_despacho DATE NOT NULL,
    direccion_destino VARCHAR(255) NOT NULL,
    estado VARCHAR(50) NOT NULL DEFAULT 'PENDIENTE',
    responsable VARCHAR(100),
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Datos de ejemplo
INSERT INTO despacho (numero_despacho, fecha_despacho, direccion_destino, estado, responsable)
VALUES
  ('DSP-001', CURDATE(), 'Av. Principal 123, Santiago', 'PENDIENTE', 'Juan Pérez'),
  ('DSP-002', CURDATE(), 'Calle Secundaria 456, Valparaíso', 'EN_CAMINO', 'María López'),
  ('DSP-003', CURDATE(), 'Los Aromos 789, Concepción', 'ENTREGADO', 'Carlos Ruiz');
