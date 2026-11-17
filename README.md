# Sistema de Gestión - Clínica Médica San Rafael

Proyecto final de INF 224, Metodología de Proyectos Informáticos.
Universidad de Panamá, Facultad de Informática, Electrónica y Comunicación.

## Descripción
Sistema web para gestionar pacientes, médicos, citas, consultas,
recetas y facturación de la Clínica Médica San Rafael, sobre la base
de datos clinica_db en PostgreSQL (10 tablas en Tercera Forma Normal).

## Equipo
| Integrante | Rol |
|---|---|
| José Zorrilla | Product Owner y desarrolladora |
| Jaime Altamiranda | Scrum Master y desarrollador |
| Elías Martínez | Desarrollador |
| Bryan Ríos | Desarrollador |

## Metodología
Scrum, con 6 sprints de 2 semanas (2 de noviembre de 2026 al 12 de
febrero de 2027). El backlog y el tablero se gestionan en Jira.

## Estructura del repositorio
- `sql/` scripts de la base de datos, en orden de ejecución (01 a 06)
- `docs/` informe del proyecto y diagrama entidad-relación

## Cómo crear la base de datos
1. Ejecutar `sql/01_crear_base_de_datos.sql` conectado a la base postgres.
2. Conectarse a clinica_db y ejecutar los scripts 02 a 06 en orden.

## Estado
- Sprint 0 (base de datos y entorno): completado
- Sprint 1 (pacientes y catálogos): en ejecución
