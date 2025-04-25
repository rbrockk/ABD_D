# Sistema de Gestión de Créditos de Consumo

Este repositorio contiene un sistema diseñado para la gestión eficiente y segura de créditos de consumo en instituciones financieras. Incluye funcionalidades para administrar clientes, sucursales, solicitudes de crédito, pagos, estados financieros y reportes.

---

## Tabla de Contenidos
1. [Descripción General](#descripción-general)
2. [Características](#características)
3. [Diseño de la Base de Datos](#diseño-de-la-base-de-datos)
4. [Requisitos del Sistema](#requisitos-del-sistema)
5. [Instalación](#instalación)
6. [Uso](#uso)
7. [Contribuciones](#contribuciones)
8. [Licencia](#licencia)
9. [Contacto](#contacto)

---

## Descripción General

El **Sistema de Gestión de Créditos de Consumo** es una solución que permite a las instituciones financieras organizar y gestionar toda la información relevante sobre créditos de consumo. Desde el registro de clientes hasta el manejo de transacciones y reportes, este sistema está diseñado para optimizar las operaciones financieras y garantizar la integridad de los datos.

---

## Características

- Gestión de clientes utilizando su RFC como identificador único.
- Administración de sucursales con llaves derivadas basadas en ubicación (CP, calle, colonia).
- Generación de IDs derivados para solicitudes, créditos, transacciones y estados financieros.
- Cálculo de intereses y amortizaciones.
- Generación de reportes detallados:
  - Créditos activos y vencidos.
  - Historial de pagos.
  - Estados financieros por cliente y periodo.
- Soporte para múltiples sucursales y configuraciones financieras.

---

## Diseño de la Base de Datos

El sistema utiliza un esquema relacional con las siguientes tablas principales:
1. **Banco**: Gestión de bancos y sus sucursales.
2. **Sucursal**: Identificada por CP, calle y colonia.
3. **Clientes**: Identificados por su RFC.
4. **Solicitudes de Crédito**: Identificadas por RFC y un folio único.
5. **Créditos**: Identificados por el día de inicio y el nombre del cliente.
6. **Transacciones**: Identificadas por el crédito y un número único.
7. **Estado de Cuenta**: Identificados por RFC y periodo (mes/año).
8. **Historial de Estados**: Cambios en solicitudes y créditos.
9. **Configuración Financiera**: Tasas de interés y penalizaciones.

---

## Requisitos del Sistema

- **Gestor de Base de Datos:** PostgreSQL 13+
- **Lenguaje:** SQL
- **Entorno de Desarrollo:** Compatible con cualquier herramienta de gestión SQL como pgAdmin, DBeaver o CLI de PostgreSQL.

---

## Instalación

Sigue estos pasos para implementar el sistema en tu entorno:

1. **Clona este repositorio**:
   ```bash
   git clone https://github.com/rbrockk/sistema-gestion-creditos.git
   cd sistema-gestion-creditos
   ```

2. **Crea la base de datos en PostgreSQL**:
   Conéctate a PostgreSQL y ejecuta:
   ```sql
   CREATE DATABASE sistema_creditos;
   ```

3. **Ejecuta el script SQL**:
   Importa el archivo `credito_bd_completa.sql` en tu base de datos. Por ejemplo:
   ```bash
   psql -U tu_usuario -d sistema_creditos -f credito_bd_completa.sql
   ```

4. **Verifica las tablas y datos iniciales**:
   Revisa que todas las tablas estén creadas correctamente y que los datos de prueba estén disponibles.

---

## Uso

### Consultas Básicas

1. **Ver todos los clientes registrados**:
   ```sql
   SELECT * FROM credito.Clientes;
   ```

2. **Obtener el historial de transacciones de un cliente**:
   ```sql
   SELECT t.* 
   FROM credito.Transacciones t
   JOIN credito.Creditos c ON t.id_credito = c.id_credito
   WHERE c.RFC_cliente = 'ABC123456789';
   ```

3. **Generar reporte de créditos activos**:
   ```sql
   SELECT * 
   FROM credito.Creditos 
   WHERE estado_credito = 'Activo';
   ```

### Personalización

Puedes agregar nuevos datos de prueba o realizar migraciones adicionales para expandir la funcionalidad del sistema.

---

## Contribuciones

Contribuciones son bienvenidas. Sigue estos pasos para colaborar:

1. Haz un fork de este repositorio.
2. Crea una rama para tus cambios:
   ```bash
   git checkout -b feature/nueva-funcionalidad
   ```
3. Realiza tus cambios y haz un commit:
   ```bash
   git commit -m "Agregada nueva funcionalidad"
   ```
4. Envía un pull request con una descripción detallada de los cambios.

---

## Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo `LICENSE` para más información.

---

## Contacto

Para preguntas o soporte, contacta a:

- **Nombre:** Roberto Flores
- **Email:** 
- **GitHub:** [rbrockk](https://github.com/rbrockk)
