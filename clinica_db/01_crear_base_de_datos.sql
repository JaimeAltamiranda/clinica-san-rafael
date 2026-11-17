-- =====================================================================
-- PROYECTO: Sistema de Base de Datos Relacional - Clínica Médica San Rafael
-- FASE 2.1 : Creación de la base de datos (DDL)
-- SGBD     : PostgreSQL 14 o superior
-- ARCHIVO  : 01_crear_base_de_datos.sql
-- EJECUTAR : conectado a la base "postgres".
-- IMPORTANTE (pgAdmin): CREATE DATABASE no puede ejecutarse junto con
-- otras sentencias en el mismo bloque. Este archivo contiene SOLO esa
-- sentencia para que funcione al presionar F5.
-- =====================================================================

-- Si necesita empezar desde cero, ejecute primero (sola) esta línea:
-- DROP DATABASE IF EXISTS clinica_db;

-- Crea la base de datos con codificación UTF-8 para admitir tildes y ñ.
CREATE DATABASE clinica_db
    WITH ENCODING = 'UTF8'
         TEMPLATE = template0;

-- ---------------------------------------------------------------------
-- Siguiente paso:
--   * En pgAdmin 4 : clic derecho en "Databases" -> Refresh, seleccione
--                    "clinica_db", abra una NUEVA Query Tool sobre ella
--                    y ejecute 02_ddl_tablas.sql
--   * En psql      : \c clinica_db   y luego  \i 02_ddl_tablas.sql
-- ---------------------------------------------------------------------
