-- =====================================================================
-- PROYECTO: Sistema de Base de Datos Relacional - Clínica Médica San Rafael
-- FASE 2.2 : Inserción de datos iniciales (DML - INSERT INTO)
-- ARCHIVO  : 03_dml_insercion.sql
-- EJECUTAR : conectado a "clinica_db", justo después de 02_ddl_tablas.sql
-- =====================================================================
-- Orden de inserción: primero las tablas sin claves foráneas (catálogos),
-- luego las que dependen de ellas. Así cada FK apunta a un registro que
-- ya existe. Las columnas id_* se generan solas (IDENTITY) y, en una base
-- recién creada, toman los valores 1, 2, 3... en el orden de inserción.
-- Datos ficticios con formato panameño (cédula, teléfono, balboas/USD).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. ESPECIALIDAD (6 registros)
-- ---------------------------------------------------------------------
INSERT INTO especialidad (nombre, descripcion, tarifa_consulta) VALUES
('Medicina General', 'Atención primaria y control de salud general',          35.00),  -- id 1
('Pediatría',        'Atención de niños y adolescentes',                      45.00),  -- id 2
('Cardiología',      'Enfermedades del corazón y del sistema circulatorio',   80.00),  -- id 3
('Dermatología',     'Enfermedades de la piel, cabello y uñas',               60.00),  -- id 4
('Ginecología',      'Salud reproductiva de la mujer',                        65.00),  -- id 5
('Neurología',       'Enfermedades del sistema nervioso',                     90.00);  -- id 6 (aún sin médicos)

-- ---------------------------------------------------------------------
-- 2. ASEGURADORA (5 registros) - nombres ficticios
-- ---------------------------------------------------------------------
INSERT INTO aseguradora (nombre, telefono, correo, porcentaje_cobertura) VALUES
('Seguros Istmo',         '210-4500', 'atencion@segurosistmo.com',     80.00),  -- id 1
('Protección Total',      '300-1200', 'clientes@protecciontotal.com',  70.00),  -- id 2
('Salud Segura',          '269-8800', 'info@saludsegura.com',          75.00),  -- id 3
('Seguros del Pacífico',  '264-3300', 'servicio@segpacifico.com',      60.00),  -- id 4
('Vida Plena Seguros',    '227-9100', 'contacto@vidaplena.com',        50.00);  -- id 5

-- ---------------------------------------------------------------------
-- 3. CONSULTORIO (6 registros)
-- ---------------------------------------------------------------------
INSERT INTO consultorio (numero, piso, equipamiento) VALUES
('C-101', 1, 'Camilla, tensiómetro y báscula'),           -- id 1
('C-102', 1, 'Camilla pediátrica y otoscopio'),           -- id 2
('C-201', 2, 'Electrocardiógrafo y monitor cardíaco'),    -- id 3
('C-202', 2, 'Dermatoscopio y lámpara de aumento'),       -- id 4
('C-203', 2, 'Camilla ginecológica y ecógrafo'),          -- id 5
('C-301', 3, 'Camilla básica');                           -- id 6

-- ---------------------------------------------------------------------
-- 4. PACIENTE (10 registros)
--    id_aseguradora NULL = paciente particular (sin seguro).
-- ---------------------------------------------------------------------
INSERT INTO paciente (cedula, nombre, apellido, fecha_nacimiento, sexo, telefono, correo, direccion, id_aseguradora) VALUES
('8-845-1203',  'María',    'González', '1985-03-14', 'F', '6612-3344', 'maria.gonzalez@correo.com',  'Calle 50, Bella Vista, Panamá',        1),     -- id 1
('8-912-4410',  'José',     'Rodríguez','1978-11-02', 'M', '6623-1190', 'jose.rodriguez@correo.com',  'Vía España, San Francisco, Panamá',    2),     -- id 2
('4-756-2231',  'Ana',      'Pérez',    '2016-07-21', 'F', '6634-5567', NULL,                         'Barrio Bolívar, David, Chiriquí',      3),     -- id 3
('8-1002-3345', 'Carlos',   'Martínez', '1990-05-30', 'M', '6645-8821', 'carlos.martinez@correo.com', 'Condado del Rey, Panamá',              5),     -- id 4
('9-703-1188',  'Lucía',    'Herrera',  '1995-09-12', 'F', '6656-2290', 'lucia.herrera@correo.com',   'Calle 2da, Santiago, Veraguas',        5),     -- id 5
('8-777-9021',  'Pedro',    'Sánchez',  '1962-01-25', 'M', '6667-4413', 'pedro.sanchez@correo.com',   'Betania, Panamá',                      4),     -- id 6
('3-721-4456',  'Sofía',    'Castillo', '2019-12-03', 'F', '6678-9034', NULL,                         'Sabanitas, Colón',                     NULL),  -- id 7
('8-930-6672',  'Miguel',   'Torres',   '1988-08-17', 'M', '6689-1276', 'miguel.torres@correo.com',   'Juan Díaz, Panamá',                    NULL),  -- id 8
('6-712-3390',  'Gabriela', 'Vargas',   '1973-04-09', 'F', '6690-5543', 'gabriela.vargas@correo.com', 'Chitré, Herrera',                      1),     -- id 9
('8-1055-2210', 'Daniel',   'Moreno',   '2001-10-28', 'M', '6601-7788', 'daniel.moreno@correo.com',   'Costa del Este, Panamá',               2);     -- id 10

-- ---------------------------------------------------------------------
-- 5. MEDICO (8 registros)
-- ---------------------------------------------------------------------
INSERT INTO medico (cedula, licencia, nombre, apellido, telefono, correo, id_especialidad, fecha_ingreso) VALUES
('8-501-1122', 'MG-1021',  'Roberto',  'Jaén',     '6701-1122', 'rjaen@clinicasanrafael.com',      1, '2015-02-01'),  -- id 1
('8-602-3344', 'MG-1187',  'Patricia', 'Ríos',     '6702-3344', 'prios@clinicasanrafael.com',      1, '2019-06-15'),  -- id 2
('4-411-5566', 'PED-2034', 'Fernando', 'Guerra',   '6703-5566', 'fguerra@clinicasanrafael.com',    2, '2017-03-10'),  -- id 3
('8-633-7788', 'PED-2091', 'Laura',    'Méndez',   '6704-7788', 'lmendez@clinicasanrafael.com',    2, '2021-08-01'),  -- id 4
('8-544-9900', 'CAR-3012', 'Alberto',  'Quintero', '6705-9900', 'aquintero@clinicasanrafael.com',  3, '2012-11-20'),  -- id 5
('3-388-2211', 'DER-4005', 'Carmen',   'Delgado',  '6706-2211', 'cdelgado@clinicasanrafael.com',   4, '2018-01-08'),  -- id 6
('8-720-4433', 'GIN-5021', 'Isabel',   'Navarro',  '6707-4433', 'inavarro@clinicasanrafael.com',   5, '2016-09-05'),  -- id 7
('9-455-6677', 'CAR-3055', 'Ricardo',  'Pinzón',   '6708-6677', 'rpinzon@clinicasanrafael.com',    3, '2020-04-12');  -- id 8

-- ---------------------------------------------------------------------
-- 6. MEDICAMENTO (8 registros)
-- ---------------------------------------------------------------------
INSERT INTO medicamento (nombre, presentacion, precio_unitario, stock) VALUES
('Paracetamol',    'Tabletas 500 mg',    0.15, 500),  -- id 1
('Amoxicilina',    'Cápsulas 500 mg',    0.40, 300),  -- id 2
('Ibuprofeno',     'Tabletas 400 mg',    0.20, 400),  -- id 3
('Losartán',       'Tabletas 50 mg',     0.35, 250),  -- id 4
('Loratadina',     'Tabletas 10 mg',     0.25, 200),  -- id 5
('Salbutamol',     'Inhalador 100 mcg',  6.50,  40),  -- id 6
('Hidrocortisona', 'Crema 1 %',          4.75,  60),  -- id 7
('Ranitidina',     'Tabletas 150 mg',    0.30,   0);  -- id 8 (sin existencias)

-- ---------------------------------------------------------------------
-- 7. CITA (12 registros)
--    Citas 1-8: atendidas en octubre de 2026.
--    Cita 9   : el paciente no se presentó.
--    Citas 10-12: programadas para noviembre de 2026.
-- ---------------------------------------------------------------------
INSERT INTO cita (id_paciente, id_medico, id_consultorio, fecha_hora, motivo, estado) VALUES
(1, 1, 1, '2026-10-05 08:00', 'Chequeo general anual',                 'Atendida'),    -- id 1
(2, 5, 3, '2026-10-05 09:00', 'Dolor en el pecho al hacer ejercicio',  'Atendida'),    -- id 2
(3, 3, 2, '2026-10-06 10:00', 'Fiebre y tos persistente',              'Atendida'),    -- id 3
(4, 6, 4, '2026-10-06 11:00', 'Erupción en la piel de los brazos',     'Atendida'),    -- id 4
(5, 7, 5, '2026-10-07 08:30', 'Ardor al orinar',                       'Atendida'),    -- id 5
(6, 5, 3, '2026-10-07 10:00', 'Control de hipertensión',               'Atendida'),    -- id 6
(7, 4, 2, '2026-10-08 09:00', 'Dificultad para respirar',              'Atendida'),    -- id 7
(9, 2, 1, '2026-10-08 14:00', 'Dolor de cabeza frecuente',             'Atendida'),    -- id 8
(8, 1, 1, '2026-10-09 08:00', 'Dolor lumbar',                          'No asistió'),  -- id 9
(1, 6, 4, '2026-11-20 10:00', 'Revisión de lunar',                     'Programada'),  -- id 10
(2, 5, 6, '2026-11-24 09:00', 'Control cardiológico post-tratamiento', 'Programada'),  -- id 11
(6, 8, 6, '2026-11-25 11:00', 'Segunda opinión cardiológica',          'Programada');  -- id 12

-- ---------------------------------------------------------------------
-- 8. CONSULTA (8 registros) - una por cada cita atendida (citas 1 a 8)
-- ---------------------------------------------------------------------
INSERT INTO consulta (id_cita, presion_sistolica, presion_diastolica, temperatura, peso_kg, diagnostico, observaciones, fecha_registro) VALUES
(1, 118, 76, 36.6, 62.50, 'Paciente sana, sin hallazgos',            'Se recomienda ejercicio regular',      '2026-10-05 08:30'),  -- id 1
(2, 145, 92, 36.8, 88.00, 'Hipertensión arterial estadio 1',         'Se solicita electrocardiograma',       '2026-10-05 09:40'),  -- id 2
(3, 100, 65, 38.4, 22.00, 'Bronquitis aguda',                        'Reposo e hidratación abundante',       '2026-10-06 10:35'),  -- id 3
(4, 120, 80, 36.5, 75.30, 'Dermatitis de contacto',                  'Evitar detergentes fuertes',           '2026-10-06 11:30'),  -- id 4
(5, 115, 75, 37.1, 58.00, 'Infección urinaria leve',                 'Aumentar consumo de agua',             '2026-10-07 09:00'),  -- id 5
(6, 150, 95, 36.6, 91.20, 'Hipertensión arterial no controlada',     'Se ajusta la dosis de Losartán',       '2026-10-07 10:40'),  -- id 6
(7, 105, 70, 37.2, 18.50, 'Asma bronquial leve',                     'Usar inhalador solo en crisis',        '2026-10-08 09:30'),  -- id 7
(8, 125, 82, 36.6, 68.00, 'Cefalea tensional',                       'Control del estrés y descanso',        '2026-10-08 14:30');  -- id 8

-- ---------------------------------------------------------------------
-- 9. RECETA_DETALLE (12 registros) - medicamentos por consulta (N:M)
--    La consulta 1 (paciente sana) no genera receta.
-- ---------------------------------------------------------------------
INSERT INTO receta_detalle (id_consulta, id_medicamento, dosis, frecuencia, duracion_dias, cantidad) VALUES
(2, 4, '50 mg',          'Cada 24 horas',               30, 30),
(3, 2, '250 mg',         'Cada 8 horas',                 7, 21),
(3, 1, '250 mg',         'Cada 6 horas si hay fiebre',   3, 12),
(4, 7, 'Capa fina',      'Cada 12 horas',               10,  1),
(4, 5, '10 mg',          'Cada 24 horas',                7,  7),
(5, 2, '500 mg',         'Cada 8 horas',                 7, 21),
(5, 1, '500 mg',         'Cada 8 horas si hay dolor',    3,  9),
(6, 4, '50 mg',          'Cada 12 horas',               30, 60),
(7, 6, '2 inhalaciones', 'Cada 6 horas si hay crisis',  30,  1),
(7, 5, '5 mg',           'Cada 24 horas',               10, 10),
(8, 3, '400 mg',         'Cada 8 horas',                 5, 15),
(8, 1, '500 mg',         'Cada 8 horas si hay dolor',    3,  9);

-- ---------------------------------------------------------------------
-- 10. FACTURA (8 registros) - una por cita atendida
--     monto_total    = tarifa de la especialidad al momento de facturar
--     monto_cubierto = monto_total x % de cobertura de la aseguradora
--     Pago del paciente = monto_total - monto_cubierto (se calcula en consultas)
-- ---------------------------------------------------------------------
INSERT INTO factura (id_cita, fecha_emision, monto_total, monto_cubierto, metodo_pago, estado_pago) VALUES
(1, '2026-10-05', 35.00, 28.00, 'Tarjeta',       'Pagada'),     -- 80 % Seguros Istmo
(2, '2026-10-05', 80.00, 56.00, 'Efectivo',      'Pagada'),     -- 70 % Protección Total
(3, '2026-10-06', 45.00, 33.75, 'Yappy',         'Pagada'),     -- 75 % Salud Segura
(4, '2026-10-06', 60.00, 30.00, NULL,            'Pendiente'),  -- 50 % Vida Plena
(5, '2026-10-07', 65.00, 32.50, 'Transferencia', 'Pagada'),     -- 50 % Vida Plena
(6, '2026-10-07', 80.00, 48.00, NULL,            'Pendiente'),  -- 60 % Seguros del Pacífico
(7, '2026-10-08', 45.00,  0.00, 'Efectivo',      'Pagada'),     -- particular, sin seguro
(8, '2026-10-08', 35.00, 28.00, NULL,            'Pendiente');  -- 80 % Seguros Istmo

-- ---------------------------------------------------------------------
-- Verificación: cantidad de registros por tabla.
-- ---------------------------------------------------------------------
SELECT 'especialidad'   AS tabla, COUNT(*) AS registros FROM especialidad
UNION ALL SELECT 'aseguradora',    COUNT(*) FROM aseguradora
UNION ALL SELECT 'consultorio',    COUNT(*) FROM consultorio
UNION ALL SELECT 'paciente',       COUNT(*) FROM paciente
UNION ALL SELECT 'medico',         COUNT(*) FROM medico
UNION ALL SELECT 'medicamento',    COUNT(*) FROM medicamento
UNION ALL SELECT 'cita',           COUNT(*) FROM cita
UNION ALL SELECT 'consulta',       COUNT(*) FROM consulta
UNION ALL SELECT 'receta_detalle', COUNT(*) FROM receta_detalle
UNION ALL SELECT 'factura',        COUNT(*) FROM factura;

-- Comprobación de coherencia: las relaciones funcionan (JOIN de 5 tablas).
SELECT c.id_cita,
       p.nombre || ' ' || p.apellido   AS paciente,
       m.nombre || ' ' || m.apellido   AS medico,
       e.nombre                        AS especialidad,
       co.numero                       AS consultorio,
       c.fecha_hora,
       c.estado
FROM   cita c
JOIN   paciente     p  ON p.id_paciente      = c.id_paciente
JOIN   medico       m  ON m.id_medico        = c.id_medico
JOIN   especialidad e  ON e.id_especialidad  = m.id_especialidad
LEFT   JOIN consultorio co ON co.id_consultorio = c.id_consultorio
ORDER  BY c.fecha_hora;
