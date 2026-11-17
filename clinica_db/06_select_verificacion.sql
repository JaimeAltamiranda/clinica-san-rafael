-- =====================================================================
-- PROYECTO: Sistema de Base de Datos Relacional - Clínica Médica San Rafael
-- FASE 3.3 : Consultas de verificación del estado final (SELECT)
-- ARCHIVO  : 06_select_verificacion.sql
-- EJECUTAR : conectado a "clinica_db", después de 05_dml_delete.sql
-- =====================================================================

-- ---------------------------------------------------------------------
-- V1. Conteo final por tabla (compárese con el conteo de 03_dml_insercion).
--     Esperado: especialidad 5, aseguradora 4, consultorio 5, paciente 9,
--     medico 8, medicamento 7, cita 11, consulta 7, receta_detalle 10,
--     factura 8.
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

-- ---------------------------------------------------------------------
-- V2. Estado completo de cada tabla.
-- ---------------------------------------------------------------------
SELECT * FROM especialidad   ORDER BY id_especialidad;   -- Cardiología 88.00; Dermatología id 40; sin Neurología
SELECT * FROM aseguradora    ORDER BY id_aseguradora;    -- Protección Total 75 %; sin Vida Plena
SELECT * FROM consultorio    ORDER BY id_consultorio;    -- sin C-301
SELECT * FROM paciente       ORDER BY id_paciente;       -- sin Daniel Moreno
SELECT * FROM medico         ORDER BY id_medico;         -- Ricardo Pinzón activo = false
SELECT * FROM medicamento    ORDER BY id_medicamento;    -- Losartán 220; sin Ranitidina
SELECT * FROM cita           ORDER BY id_cita;           -- sin cita 10; citas 11 y 12 sin consultorio
SELECT * FROM consulta       ORDER BY id_consulta;       -- sin consulta 5
SELECT * FROM receta_detalle ORDER BY id_consulta, id_medicamento;
SELECT * FROM factura        ORDER BY id_factura;        -- 1 pendiente

-- ---------------------------------------------------------------------
-- V3. Verificación de los UPDATE.
-- ---------------------------------------------------------------------
SELECT 'U1 tarifa Cardiología'      AS cambio, tarifa_consulta::TEXT AS valor_actual
FROM   especialidad WHERE nombre = 'Cardiología'
UNION ALL
SELECT 'U2 dirección Miguel Torres', direccion
FROM   paciente WHERE cedula = '8-930-6672'
UNION ALL
SELECT 'U3 seguro Sofía Castillo',   a.nombre
FROM   paciente p JOIN aseguradora a ON a.id_aseguradora = p.id_aseguradora
WHERE  p.cedula = '3-721-4456'
UNION ALL
SELECT 'U4 Dr. Pinzón activo',       activo::TEXT
FROM   medico WHERE licencia = 'CAR-3055'
UNION ALL
SELECT 'U7 stock Losartán',          stock::TEXT
FROM   medicamento WHERE nombre = 'Losartán'
UNION ALL
SELECT 'U8 cobertura Protección Total', porcentaje_cobertura::TEXT
FROM   aseguradora WHERE nombre = 'Protección Total'
UNION ALL
SELECT 'U9 especialidad Dra. Delgado', id_especialidad::TEXT
FROM   medico WHERE licencia = 'DER-4005';

-- ---------------------------------------------------------------------
-- V4. Verificación de los DELETE (cada fila debe mostrar 0).
-- ---------------------------------------------------------------------
SELECT 'D1 citas canceladas'        AS eliminado, COUNT(*) AS quedan FROM cita        WHERE estado = 'Cancelada'
UNION ALL SELECT 'D2 Daniel Moreno',         COUNT(*) FROM paciente    WHERE cedula = '8-1055-2210'
UNION ALL SELECT 'D4 Neurología',            COUNT(*) FROM especialidad WHERE nombre = 'Neurología'
UNION ALL SELECT 'D5 Vida Plena Seguros',    COUNT(*) FROM aseguradora WHERE nombre = 'Vida Plena Seguros'
UNION ALL SELECT 'D6 consultorio C-301',     COUNT(*) FROM consultorio WHERE numero = 'C-301'
UNION ALL SELECT 'D7 receta de consulta 5',  COUNT(*) FROM receta_detalle WHERE id_consulta = 5
UNION ALL SELECT 'D9 Ranitidina',            COUNT(*) FROM medicamento WHERE nombre = 'Ranitidina';

-- Registros que las restricciones protegieron (cada fila debe mostrar 1).
SELECT 'D3 María González'  AS protegido, COUNT(*) AS existe FROM paciente     WHERE cedula = '8-845-1203'
UNION ALL SELECT 'D4 Cardiología',        COUNT(*) FROM especialidad WHERE nombre = 'Cardiología'
UNION ALL SELECT 'D8 cita 1',             COUNT(*) FROM cita         WHERE id_cita = 1
UNION ALL SELECT 'D9 Paracetamol',        COUNT(*) FROM medicamento  WHERE nombre = 'Paracetamol';

-- ---------------------------------------------------------------------
-- V5. Agenda de citas con todas sus relaciones.
--     LEFT JOIN a consultorio muestra las citas por reubicar (SET NULL).
-- ---------------------------------------------------------------------
SELECT c.id_cita,
       c.fecha_hora,
       p.nombre || ' ' || p.apellido               AS paciente,
       'Dr(a). ' || m.nombre || ' ' || m.apellido  AS medico,
       e.nombre                                    AS especialidad,
       COALESCE(co.numero, 'POR REUBICAR')         AS consultorio,
       c.estado
FROM   cita c
JOIN   paciente     p  ON p.id_paciente     = c.id_paciente
JOIN   medico       m  ON m.id_medico       = c.id_medico
JOIN   especialidad e  ON e.id_especialidad = m.id_especialidad
LEFT   JOIN consultorio co ON co.id_consultorio = c.id_consultorio
ORDER  BY c.fecha_hora;

-- ---------------------------------------------------------------------
-- V6. Pacientes y su aseguradora (los particulares aparecen como tales).
-- ---------------------------------------------------------------------
SELECT p.cedula,
       p.nombre || ' ' || p.apellido               AS paciente,
       COALESCE(a.nombre, 'Particular')            AS aseguradora,
       COALESCE(a.porcentaje_cobertura, 0)         AS cobertura_pct
FROM   paciente p
LEFT   JOIN aseguradora a ON a.id_aseguradora = p.id_aseguradora
ORDER  BY p.apellido;

-- ---------------------------------------------------------------------
-- V7. Recetas por consulta (relación N:M resuelta con receta_detalle).
-- ---------------------------------------------------------------------
SELECT co.id_consulta,
       p.nombre || ' ' || p.apellido   AS paciente,
       co.diagnostico,
       me.nombre || ' ' || me.presentacion AS medicamento,
       r.dosis, r.frecuencia, r.duracion_dias, r.cantidad
FROM   receta_detalle r
JOIN   consulta    co ON co.id_consulta    = r.id_consulta
JOIN   cita        c  ON c.id_cita         = co.id_cita
JOIN   paciente    p  ON p.id_paciente     = c.id_paciente
JOIN   medicamento me ON me.id_medicamento = r.id_medicamento
ORDER  BY co.id_consulta, me.nombre;

-- ---------------------------------------------------------------------
-- V8. Facturación: lo que cubre el seguro y lo que paga el paciente.
-- ---------------------------------------------------------------------
SELECT f.id_factura,
       f.fecha_emision,
       p.nombre || ' ' || p.apellido        AS paciente,
       f.monto_total,
       f.monto_cubierto,
       f.monto_total - f.monto_cubierto     AS pago_paciente,
       COALESCE(f.metodo_pago, '-')         AS metodo_pago,
       f.estado_pago
FROM   factura f
JOIN   cita     c ON c.id_cita     = f.id_cita
JOIN   paciente p ON p.id_paciente = c.id_paciente
ORDER  BY f.id_factura;

-- Resumen de ingresos por estado de pago.
SELECT estado_pago,
       COUNT(*)                              AS facturas,
       SUM(monto_total)                      AS total_facturado,
       SUM(monto_cubierto)                   AS total_aseguradoras,
       SUM(monto_total - monto_cubierto)     AS total_pacientes
FROM   factura
GROUP  BY estado_pago;
