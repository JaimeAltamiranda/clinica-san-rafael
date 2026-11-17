-- =====================================================================
-- PROYECTO: Sistema de Base de Datos Relacional - Clínica Médica San Rafael
-- FASE 3.1 : Actualización de registros (DML - UPDATE ... SET ... WHERE)
-- ARCHIVO  : 04_dml_update.sql
-- EJECUTAR : conectado a "clinica_db", después de 03_dml_insercion.sql
-- =====================================================================
-- Cada bloque sigue el patrón:  ANTES (SELECT) -> UPDATE -> DESPUÉS (SELECT)
-- para poder tomar captura del cambio. Las pruebas que deben fallar están
-- dentro de bloques DO ... EXCEPTION, que capturan el error y lo muestran
-- como NOTICE (pestaña "Messages" en pgAdmin) sin detener el script.
-- =====================================================================

-- ---------------------------------------------------------------------
-- U1. Ajuste de precios: la gerencia aumenta 10 % la tarifa de Cardiología
--     por la compra de un nuevo electrocardiógrafo.
-- ---------------------------------------------------------------------
SELECT nombre, tarifa_consulta FROM especialidad WHERE nombre = 'Cardiología';  -- antes: 80.00

UPDATE especialidad
SET    tarifa_consulta = ROUND(tarifa_consulta * 1.10, 2)
WHERE  nombre = 'Cardiología';

SELECT nombre, tarifa_consulta FROM especialidad WHERE nombre = 'Cardiología';  -- después: 88.00
-- Las facturas ya emitidas de Cardiología conservan 80.00 (RN13).

-- ---------------------------------------------------------------------
-- U2. Cambio de dirección y teléfono: el paciente Miguel Torres se mudó.
-- ---------------------------------------------------------------------
SELECT cedula, nombre, apellido, telefono, direccion FROM paciente WHERE cedula = '8-930-6672';

UPDATE paciente
SET    direccion = 'Villa Lucre, San Miguelito, Panamá',
       telefono  = '6699-4521'
WHERE  cedula = '8-930-6672';

SELECT cedula, nombre, apellido, telefono, direccion FROM paciente WHERE cedula = '8-930-6672';

-- ---------------------------------------------------------------------
-- U3. Afiliación a un seguro: la paciente Sofía Castillo (particular)
--     ahora está asegurada con Salud Segura.
-- ---------------------------------------------------------------------
UPDATE paciente
SET    id_aseguradora = (SELECT id_aseguradora FROM aseguradora WHERE nombre = 'Salud Segura')
WHERE  cedula = '3-721-4456';

SELECT p.nombre, p.apellido, a.nombre AS aseguradora
FROM   paciente p
LEFT   JOIN aseguradora a ON a.id_aseguradora = p.id_aseguradora
WHERE  p.cedula = '3-721-4456';

-- ---------------------------------------------------------------------
-- U4. Cambio de estado de un usuario: el Dr. Ricardo Pinzón se retira.
--     Se marca inactivo (no se borra: tiene historial) y sus citas
--     programadas se reasignan al Dr. Alberto Quintero (misma especialidad).
-- ---------------------------------------------------------------------
UPDATE medico
SET    activo = FALSE
WHERE  licencia = 'CAR-3055';

UPDATE cita
SET    id_medico = (SELECT id_medico FROM medico WHERE licencia = 'CAR-3012')
WHERE  id_medico = (SELECT id_medico FROM medico WHERE licencia = 'CAR-3055')
  AND  estado    = 'Programada';

SELECT m.nombre || ' ' || m.apellido AS medico, m.activo,
       COUNT(c.id_cita) FILTER (WHERE c.estado = 'Programada') AS citas_programadas
FROM   medico m
LEFT   JOIN cita c ON c.id_medico = m.id_medico
WHERE  m.id_especialidad = (SELECT id_especialidad FROM especialidad WHERE nombre = 'Cardiología')
GROUP  BY m.id_medico, m.nombre, m.apellido, m.activo;

-- ---------------------------------------------------------------------
-- U5. Cancelación de cita: María González cancela su revisión de lunar.
-- ---------------------------------------------------------------------
UPDATE cita
SET    estado = 'Cancelada'
WHERE  id_paciente = (SELECT id_paciente FROM paciente WHERE cedula = '8-845-1203')
  AND  fecha_hora  = '2026-11-20 10:00';

SELECT id_cita, fecha_hora, motivo, estado FROM cita WHERE id_cita = 10;

-- ---------------------------------------------------------------------
-- U6. Registro de pagos: se cobran dos facturas pendientes.
-- ---------------------------------------------------------------------
SELECT id_factura, id_cita, monto_total, monto_cubierto, metodo_pago, estado_pago
FROM   factura WHERE estado_pago = 'Pendiente';                 -- antes: 3 pendientes

UPDATE factura SET estado_pago = 'Pagada', metodo_pago = 'Yappy'   WHERE id_cita = 4;
UPDATE factura SET estado_pago = 'Pagada', metodo_pago = 'Tarjeta' WHERE id_cita = 6;

SELECT id_factura, id_cita, monto_total, monto_cubierto, metodo_pago, estado_pago
FROM   factura WHERE estado_pago = 'Pendiente';                 -- después: 1 pendiente

-- ---------------------------------------------------------------------
-- U7. Descuento de inventario: la farmacia despacha la receta de la
--     consulta 2. UPDATE ... FROM (propio de PostgreSQL) resta del stock
--     la cantidad recetada de cada medicamento de esa consulta.
-- ---------------------------------------------------------------------
SELECT nombre, presentacion, stock FROM medicamento WHERE nombre = 'Losartán';  -- antes: 250

UPDATE medicamento m
SET    stock = m.stock - r.cantidad
FROM   receta_detalle r
WHERE  r.id_medicamento = m.id_medicamento
  AND  r.id_consulta    = 2;

SELECT nombre, presentacion, stock FROM medicamento WHERE nombre = 'Losartán';  -- después: 220

-- ---------------------------------------------------------------------
-- U8. Nuevo convenio: Protección Total sube su cobertura de 70 % a 75 %.
-- ---------------------------------------------------------------------
UPDATE aseguradora
SET    porcentaje_cobertura = 75.00
WHERE  nombre = 'Protección Total';

SELECT nombre, porcentaje_cobertura FROM aseguradora ORDER BY id_aseguradora;

-- ---------------------------------------------------------------------
-- U9. Integridad referencial ON UPDATE CASCADE: se recodifica la
--     especialidad Dermatología (4 -> 40). PostgreSQL actualiza solo la
--     FK de cada médico de esa especialidad.
-- ---------------------------------------------------------------------
SELECT nombre, apellido, id_especialidad FROM medico WHERE licencia = 'DER-4005';  -- antes: 4

UPDATE especialidad
SET    id_especialidad = 40
WHERE  nombre = 'Dermatología';

SELECT nombre, apellido, id_especialidad FROM medico WHERE licencia = 'DER-4005';  -- después: 40

-- ---------------------------------------------------------------------
-- U10. Actualizaciones que las restricciones RECHAZAN (deben fallar).
-- ---------------------------------------------------------------------

-- a) CHECK: el stock no puede quedar negativo (RN11).
DO $$
BEGIN
    UPDATE medicamento SET stock = -5 WHERE nombre = 'Salbutamol';
    RAISE NOTICE 'U10a: el UPDATE se ejecutó (no debería ocurrir)';
EXCEPTION WHEN check_violation THEN
    RAISE NOTICE 'U10a rechazado por CHECK: %', SQLERRM;
END $$;

-- b) CHECK: una cita solo admite los cuatro estados definidos (RN06).
DO $$
BEGIN
    UPDATE cita SET estado = 'Pospuesta' WHERE id_cita = 11;
    RAISE NOTICE 'U10b: el UPDATE se ejecutó (no debería ocurrir)';
EXCEPTION WHEN check_violation THEN
    RAISE NOTICE 'U10b rechazado por CHECK: %', SQLERRM;
END $$;

-- c) UNIQUE: el Dr. Quintero ya tiene una cita el 24/11 a las 09:00;
--    mover la cita 12 a esa hora crearía un choque de horario (RN05).
DO $$
BEGIN
    UPDATE cita SET fecha_hora = '2026-11-24 09:00' WHERE id_cita = 12;
    RAISE NOTICE 'U10c: el UPDATE se ejecutó (no debería ocurrir)';
EXCEPTION WHEN unique_violation THEN
    RAISE NOTICE 'U10c rechazado por UNIQUE: %', SQLERRM;
END $$;

-- d) FOREIGN KEY: no se puede asignar un médico que no existe.
DO $$
BEGIN
    UPDATE cita SET id_medico = 999 WHERE id_cita = 11;
    RAISE NOTICE 'U10d: el UPDATE se ejecutó (no debería ocurrir)';
EXCEPTION WHEN foreign_key_violation THEN
    RAISE NOTICE 'U10d rechazado por FOREIGN KEY: %', SQLERRM;
END $$;

-- Para ver el error tal como lo muestra PostgreSQL (captura de pantalla),
-- ejecute una de estas sentencias por separado:
-- UPDATE medicamento SET stock = -5 WHERE nombre = 'Salbutamol';
-- UPDATE cita SET estado = 'Pospuesta' WHERE id_cita = 11;
