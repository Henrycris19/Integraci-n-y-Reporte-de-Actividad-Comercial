# Integraci-n-y-Reporte-de-Actividad-Comercial
1. Integración y Reporte de Actividad Comercial
  1.1 Descripción del Proyecto
  Este repositorio contiene la solución a la prueba técnica para Ingeniero de Desarrollo CRM.
  
  El objetivo es diseñar una solución completa y funcional que integre datos de un sistema CRM (almacenados en una base de datos Oracle SQL) y un archivo plano (.csv) de ventas externas. La solución     incluye la extracción, transformación y carga (ETL) de los datos, el manejo de errores, un reporte visual parametrizado y una API para exponer la productividad de los ejecutivos.
  
  1.2. Stack de Tecnologías
  Base de Datos: Oracle SQL
  
  Lenguaje (ETL y API): Python 3
  
  ETL (Librerías): pandas, oracledb
  
  API (Framework): Flask
  
  Reporte y Visualización: Power BI Desktop
2. Características y Componentes de la Solución
  El proyecto está dividido en las 5 partes de la prueba:

  2.1. Parte 1: Consulta de Productividad (Consulta_productividad.sql)
  Se diseñó una consulta SQL avanzada (Oracle) en Consulta_productividad.sql que combina las tablas Ejecutivos, Visitas, Clientes y Ventas para calcular KPIs de productividad. Esta consulta utiliza   subconsultas (LEFT JOIN a tablas derivadas) para calcular métricas de eficiencia, como TotalVisitas, MontoTotalVentas y ValorPromedioPorVisita.

  2.2. Parte 2: Proceso ETL (limpieza_csv.py)
  Un script de Python (limpieza_csv.py) que gestiona la carga del archivo ventas_grandes.csv (200 registros) en la tabla Ventas de Oracle.
  
  Este ETL es robusto y maneja 3 niveles de errores:
  
  Errores de Formato (Paso 1): Rechaza registros con tipos de datos incorrectos (ej. 'ABC' en un monto) o valores nulos obligatorios.
  
  Errores de Integridad (Paso 2): Usa LOOKUP (consultas SELECT COUNT(*)) para rechazar ventas si el IdCliente no existe en la BD.
  
  Errores de Duplicados (Paso 2): Rechaza ventas si el IdVenta ya existe en la tabla Ventas (error ORA-00001) o si el IdVenta viene duplicado dentro del mismo archivo CSV.
  
  Los registros rechazados se almacenan en la tabla Ventas_ETL_Errores con una descripción clara del motivo del rechazo.
  
  2.3. Parte 3: Reporte Parametrizado (Reportes y visuales Power BI (Parte 3 y 5).pbix)
  Un dashboard en Power BI Desktop (Reportes y visuales Power BI (Parte 3 y 5).pbix) que se conecta directamente a la base de datos Oracle mediante consultas SQL.
  
  Datos: El reporte carga 3 datasets: la consulta principal (combinada), una lista de ejecutivos (para el filtro) y una lista de productos (para el filtro).
  
  Parametrización: El usuario puede filtrar dinámicamente el reporte por Ejecutivo, Producto y Rango de Fechas.
  
  KPIs: Muestra los indicadores clave (Total Ventas, Total Visitas, Promedio Venta), los cuales se recalculan según los filtros seleccionados.
  
  2.4. Parte 4: Módulo de Desarrollo (api.py)
  Un microservicio web (API) construido con Flask que expone la consulta de productividad de la Parte 1.
  
  Endpoint: GET /api/productividad
  
  Funcionalidad: Se conecta a Oracle, ejecuta la consulta de productividad y devuelve los resultados en formato JSON.
  
  2.5. Parte 5: Visuales Avanzados (Reportes y visuales Power BI (Parte 3 y 5).pbix)
  El reporte de Power BI incluye visualizaciones avanzadas para destacar tendencias y comparativas:
  
  Tendencia (Gráfico de Líneas): Muestra Total Ventas y Total Visitas a lo largo del tiempo, utilizando un eje Y secundario para manejar la diferencia de escalas.
  
  Comparativa (Gráfico Combinado): Muestra las Ventas (Columnas) vs. las Visitas (Línea) por cada ejecutivo, permitiendo un análisis de eficiencia.
  
  Composición (Treemap): Muestra la distribución de ventas por Producto.

3. Guía de Instalación y Ejecución
  3.1. Prerrequisitos
  Acceso a una base de datos Oracle (el proyecto está configurado para system/1234@localhost:1521/xepdb1).
  
  Python 3.x instalado.
  
  Power BI Desktop instalado.
  
  3.2. Configuración del Entorno
  Base de Datos:
  
  Los scripts SQL necesarios están incluidos en la raíz del proyecto. Ejecute en Oracle:
  
  El contenido de estructura_db.sql (para crear las tablas Ejecutivos, Clientes, Visitas, Ventas y Ventas_ETL_Errores).
  
  El contenido de data_db.sql (para poblar las tablas con los datos iniciales de ejecutivos, clientes y visitas).
  
  Entorno Python:
  
  Instale las librerías necesarias:
  
  pip install pandas oracledb Flask
  
  3.3. Ejecución de la Solución
  Ejecutar el ETL (Cargar Ventas):
  
  Asegúrese de que el archivo ventas_grandes.csv (200 registros) esté en la misma carpeta que limpieza_csv.py.
  
  Ejecute el script ETL:
  
  python limpieza_csv.py
  
  El script procesará los 200 registros, cargará los válidos en Ventas y los erróneos en Ventas_ETL_Errores.
  
  Ejecutar la API:
  
  Ejecute el servidor Flask:
  
  python api.py
  El servidor se iniciará en http://127.0.0.1:5000.
  
  Ver el Reporte:
  
  Abra el archivo Reportes y visuales Power BI (Parte 3 y 5).pbix en Power BI Desktop.
  
  En la pestaña "Inicio", haga clic en Actualizar (Refresh).
  
  Power BI cargará los datos procesados por el ETL y poblará todas las visualizaciones.

4. Estructura del Proyecto

/Integracion-CRM-Prueba/
|
├── api.py                            # (Parte 4) Microservicio Flask
├── limpieza_csv.py                   # (Parte 2) Script de ETL
├── Reportes y visuales Power BI (Parte 3 y 5).pbix # (Parte 3 y 5) Archivo de Power BI
├── ventas_grandes.csv                # (Parte 2) Archivo de carga (200 registros)
├── estructura_db.sql                 # SQL: CREATE TABLE para la BD
├── Consulta_productividad.sql        # (Parte 1) Consulta SQL de productividad
├── data_db.sql                       # SQL: INSERTs con los datos iniciales
└── README.md                         # Este archivo
