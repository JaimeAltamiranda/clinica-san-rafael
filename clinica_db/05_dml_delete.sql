-- =====================================================================
-- PROYECTO: Sistema de Base de Datos Relacional - Clínica Médica San Rafael
-- FASE 3.2 : Eliminación de registros (DML - DELETE FROM ... WHERE)
-- ARCHIVO  : 05_dml_delete.sql
-- EJECUTAR : conectado a "clinica_db", después de 04_dml_update.sql
-- =====================================================================
-- Se demuestran las tres reglas de integridad referencial usadas:
--   RESTRICT  -> el DELETE se rechaza si hay registros dependientes
--                (error 23001 restrict_violation, capturado en los bloques DO).
--   SET NULL  -> el DELETE procede y la FK de los dependientes queda NULL.
--   CASCADE   -> el DELETE procede y los dependientes se eliminan también.
-- =====================================================================

-- ---------------------------------------------------------------------
-- D1. Eliminación simple: se depuran las citas canceladas, que no tienen
--     consulta ni factura asociada (la cita 10, cancelada en U5).
-- ---------------------------------------------------------------------
SELECT id_cita, fecha_hora, motivo, estado FROM cita WHERE estado = 'Cancelada';

DELETE FROM cita
WHERE  estado = 'Cancelada';

SELECT COUNT(*) AS citas_canceladas_restantes FROM cita WHERE estado = 'Cancelada';  -- 0

-- ---------------------------------------------------------------------
-- D2. Paciente duplicado sin historial: Daniel Moreno se registró por error
--     y nunca tuvo citas, así que puede eliminarse.
-- ---------------------------------------------------------------------
DELETE FROM paciente
WHERE  cedula = '8-1055-2210';

SELECT COUNT(*) AS existe_daniel FROM paciente WHERE cedula = '8-1055-2210';  -- 0

-- ---------------------------------------------------------------------
-- D3. ON DELETE RESTRICT (paciente -> cita): María González tiene citas,
--     por eso PostgreSQL impide eliminarla (RN08).
-- ---------------------------------------------------------------------
DO $$
BEGIN
    DELETE FROM paciente WHERE cedula = '8-845-1203';
    RAISE NOTICE 'D3: se eliminó la paciente (no debería ocurrir)';
EXCEPTION WHEN restrict_violation OR foreign_key_violation THEN
    RAISE NOTICE 'D3 bloqueado por ON DELETE RESTRICT: %', SQLERRM;
END $$;

-- ---------------------------------------------------------------------
-- D4. ON DELETE RESTRICT (especialidad -> medico): Cardiología tiene
--     médicos asignados y no se puede borrar (RN03). Neurología no tiene
--     médicos, por lo que su eliminación sí procede.
-- ---------------------------------------------------------------------
DO $$
BEGIN
    DELETE FROM especialidad WHERE nombre = 'Cardiología';
    RAISE NOTICE 'D4: se eliminó Cardiología (no debería ocurrir)';
EXCEPTION WHEN restrict_violation OR foreign_key_violation THEN
    RAISE NOTICE 'D4 bloqueado por ON DELETE RESTRICT: %', SQLERRM;
END $$;

DELETE FROM especialidad
WHERE  nombre = 'Neurología';

SELECT id_especialidad, nombre FROM especialidad ORDER BY id_especialidad;

-- ---------------------------------------------------------------------
-- D5. ON DELETE SET NULL (aseguradora -> paciente): Vida Plena Seguros
--     termina su convenio. Sus pacientes quedan como particulares (RN04).
-- ---------------------------------------------------------------------
SELECT p.nombre, p.apellido, p.id_aseguradora
FROM   paciente p
WHERE  p.id_aseguradora = (SELECT id_aseguradora FROM aseguradora WHERE nombre = 'Vida Plena Seguros');
-- antes: Carlos Martínez y Lucía Herrera con id_aseguradora = 5

DELETE FROM aseguradora
WHERE  nombre = 'Vida Plena Seguros';

SELECT nombre, apellido, id_aseguradora
FROM   paciente
WHERE  cedula IN ('8-1002-3345', '9-703-1188');
-- después: id_aseguradora = NULL (particulares)

-- ---------------------------------------------------------------------
-- D6. ON DELETE SET NULL (consultorio -> cita): el consultorio C-301 se
--     clausura por remodelación. Sus citas se conservan sin consultorio
--     para ser reubicadas (RN10).
-- ---------------------------------------------------------------------
SELECT id_cita, fecha_hora, id_consultorio FROM cita
WHERE  id_consultorio = (SELECT id_consultorio FROM consultorio WHERE numero = 'C-301');
-- antes: citas 11 y 12 en el consultorio 6

DELETE FROM consultorio
WHERE  numero = 'C-301';

SELECT id_cita, fecha_hora, id_consultorio FROM cita WHERE id_cita IN (11, 12);
-- después: id_consultorio = NULL

-- ---------------------------------------------------------------------
-- D7. ON DELETE CASCADE (consulta -> receta_detalle): la consulta 5 se
--     registró con datos equivocados. Al eliminarla, PostgreSQL elimina
--     automáticamente sus 2 líneas de receta (RN09).
-- ---------------------------------------------------------------------
SELECT COUNT(*) AS lineas_receta_consulta_5 FROM receta_detalle WHERE id_consulta = 5;  -- antes: 2

DELETE FROM consulta
WHERE  id_consulta = 5;

SELECT COUNT(*) AS lineas_receta_consulta_5 FROM receta_detalle WHERE id_consulta = 5;  -- después: 0

-- ---------------------------------------------------------------------
-- D8. ON DELETE RESTRICT (cita -> consulta / factura): la cita 1 ya fue
--     atendida y facturada; no puede eliminarse.
-- ---------------------------------------------------------------------
DO $$
BEGIN
    DELETE FROM cita WHERE id_cita = 1;
    RAISE NOTICE 'D8: se eliminó la cita (no debería ocurrir)';
EXCEPTION WHEN restrict_violation OR foreign_key_violation THEN
    RAISE NOTICE 'D8 bloqueado por ON DELETE RESTRICT: %', SQLERRM;
END $$;

-- ---------------------------------------------------------------------
-- D9. Medicamentos: la Ranitidina (sin existencias y nunca recetada) se
--     retira del catálogo. El Paracetamol aparece en recetas y no puede
--     eliminarse (ON DELETE RESTRICT).
-- ---------------------------------------------------------------------
DELETE FROM medicamento
WHERE  nombre = 'Ranitidina';

DO $$
BEGIN
    DELETE FROM medicamento WHERE nombre = 'Paracetamol';
    RAISE NOTICE 'D9: se eliminó el Paracetamol (no debería ocurrir)';
EXCEPTION WHEN restrict_violation OR foreign_key_violation THEN
    RAISE NOTICE 'D9 bloqueado por ON DELETE RESTRICT: %', SQLERRM;
END $$;

-- Para ver el error tal como lo muestra PostgreSQL (captura de pantalla),
-- ejecute una de estas sentencias por separado:
-- DELETE FROM paciente WHERE cedula = '8-845-1203';
-- DELETE FROM especialidad WHERE nombre = 'Cardiología';
