USE dream_house;

ALTER TABLE propiedad
    ADD COLUMN matricula_inmobiliaria VARCHAR(50) NULL AFTER id_propiedad;

UPDATE propiedad
SET matricula_inmobiliaria = CONCAT('DH-', LPAD(id_propiedad, 8, '0'))
WHERE matricula_inmobiliaria IS NULL OR TRIM(matricula_inmobiliaria) = '';

ALTER TABLE propiedad
    MODIFY COLUMN matricula_inmobiliaria VARCHAR(50) NOT NULL,
    ADD UNIQUE KEY uq_propiedad_matricula (matricula_inmobiliaria);
