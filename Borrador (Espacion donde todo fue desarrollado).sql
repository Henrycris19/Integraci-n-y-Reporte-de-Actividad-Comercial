CREATE TABLE Ejecutivos (
    IdEjecutivo NUMBER(10) PRIMARY KEY,
    Nombre VARCHAR2(50) NOT NULL,
    Apellido VARCHAR2(50) NOT NULL
);

CREATE TABLE Clientes (
    IdCliente NUMBER(10) PRIMARY KEY,
    Nombre VARCHAR2(50) NOT NULL,
    Apellido VARCHAR2(50) NOT NULL,
    Direccion VARCHAR2(100),
    Telefono VARCHAR2(15)
);

CREATE TABLE Visitas (
    IdVisita NUMBER(10) PRIMARY KEY,
    IdCliente NUMBER(10) NOT NULL,
    IdEjecutivo NUMBER(10) NOT NULL,
    FechaVisita DATE NOT NULL,
    Resultado VARCHAR2(255),
    
    -- Definición de Claves Foráneas (FK)
    CONSTRAINT FK_Visitas_Clientes
        FOREIGN KEY (IdCliente)
        REFERENCES Clientes(IdCliente),
        
    CONSTRAINT FK_Visitas_Ejecutivos
        FOREIGN KEY (IdEjecutivo)
        REFERENCES Ejecutivos(IdEjecutivo)
);

CREATE TABLE Ventas (
    IdVenta NUMBER(10) PRIMARY KEY,
    IdCliente NUMBER(10) NOT NULL,
    FechaVenta DATE NOT NULL,
    Monto NUMBER(10, 2) NOT NULL,
    Producto VARCHAR2(100),
    
    -- Definición de Clave Foránea (FK)
    CONSTRAINT FK_Ventas_Clientes
        FOREIGN KEY (IdCliente)
        REFERENCES Clientes(IdCliente)
);

----Tabla para almacenar registros rechazados por el ETL
CREATE TABLE Ventas_ETL_Errores (
    IdVenta_Origen VARCHAR2(100), -- Mantener como VARCHAR por si el ID es inválido
    IdCliente_Origen VARCHAR2(100),
    FechaVenta_Origen VARCHAR2(100),
    Monto_Origen VARCHAR2(100),
    Producto_Origen VARCHAR2(100),
    Razon_Rechazo VARCHAR2(500),
    Fecha_Proceso DATE DEFAULT SYSDATE
);

----Datos ejecutivos
INSERT INTO Ejecutivos (IdEjecutivo, Nombre, Apellido) VALUES (101, 'Ana', 'García');
INSERT INTO Ejecutivos (IdEjecutivo, Nombre, Apellido) VALUES (102, 'Luis', 'Ramírez');
INSERT INTO Ejecutivos (IdEjecutivo, Nombre, Apellido) VALUES (103, 'Sofía', 'Martínez');
INSERT INTO Ejecutivos (IdEjecutivo, Nombre, Apellido) VALUES (104, 'Carlos', 'Valdez');
INSERT INTO Ejecutivos (IdEjecutivo, Nombre, Apellido) VALUES (105, 'María', 'Jiménez');
INSERT INTO Ejecutivos (IdEjecutivo, Nombre, Apellido) VALUES (106, 'Fernando', 'Reyes');
INSERT INTO Ejecutivos (IdEjecutivo, Nombre, Apellido) VALUES (107, 'Laura', 'Díaz');
INSERT INTO Ejecutivos (IdEjecutivo, Nombre, Apellido) VALUES (108, 'Miguel', 'Santana');
INSERT INTO Ejecutivos (IdEjecutivo, Nombre, Apellido) VALUES (109, 'Patricia', 'Núñez');
INSERT INTO Ejecutivos (IdEjecutivo, Nombre, Apellido) VALUES (110, 'Javier', 'Peralta');

----Datos Clientes
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (1, 'TechCorp', 'SA', 'Av. Central 100', '8095551234');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (2, 'Comercial Beta', 'SRL', 'C/Industria 5', '8095555678');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (3, 'Logística XYZ', 'SAS', 'Zona Franca 20', '8095559012');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (4, 'Ferretería El Sol', 'C por A', 'Carr. Vieja 45', '8095553456');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (5, 'Importadora del Caribe', 'SRL', 'Av. 27 de Febrero 300', '8095551111');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (6, 'Grupo Sol', 'SAS', 'C/ Max Henríquez Ureña 50', '8095552222');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (7, 'Manufactura Local', 'EIRL', 'Autopista Duarte Km 10', '8095553333');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (8, 'Servicios Digitales', 'SRL', 'Av. Sarasota 12', '8095554444');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (9, 'Constructora Fuerte', 'SA', 'Av. Luperón 105', '8095555555');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (10, 'Plásticos del Este', 'C por A', 'Zona Franca San Isidro', '8095556666');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (11, 'Agropecuaria Nacional', 'SAS', 'Carretera Mella Km 14', '8095557777');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (12, 'Inversiones Alfa', 'SRL', 'Av. Rómulo Betancourt 500', '8095558888');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (13, 'Comercio Global', 'SAS', 'C/ Roberto Pastoriza 150', '8095559999');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (14, 'Tekno Soluciones', 'EIRL', 'Plaza Central, Piso 3', '8095550000');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (15, 'Transporte Veloz', 'SA', 'Av. Charles de Gaulle 25', '8095551010');
INSERT INTO Clientes (IdCliente, Nombre, Apellido, Direccion, Telefono) VALUES (16, 'Alimentos Frescos', 'SRL', 'Merca Santo Domingo L-10', '8095552020');

----Datos Visitas
-- Visitas de Ana García (101)
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1001, 1, 101, DATE '2025-09-01', 'Presentación de producto A');
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1002, 1, 101, DATE '2025-09-15', 'Cierre de negociación');

-- Visitas de Luis Ramírez (102)
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1003, 2, 102, DATE '2025-09-05', 'Reunión inicial, potencial alto');
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1004, 3, 102, DATE '2025-09-20', 'Seguimiento de crédito');

-- Visitas de Sofía Martínez (103)
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1005, 4, 103, DATE '2025-10-01', 'Cotización de servicio B');
-- Asignando 15 nuevas visitas a los nuevos ejecutivos y clientes

-- Visitas de Carlos Valde
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1006, 5, 104, DATE '2025-10-01', 'Primera reunión, presentación de servicios');
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1007, 6, 104, DATE '2025-10-03', 'Seguimiento de cotización');

-- Visitas de María Jiménez
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1008, 7, 105, DATE '2025-10-02', 'Llamada de prospección exitosa');
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1009, 8, 105, DATE '2025-10-05', 'Reunión de levantamiento de requisitos');
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1010, 9, 105, DATE '2025-10-07', 'Cliente interesado en financiamiento');

-- Visitas de Fernando Reye
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1011, 10, 106, DATE '2025-10-04', 'Visita a instalaciones del cliente');

-- Visitas de Laura Díaz
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1012, 11, 107, DATE '2025-10-06', 'Presentación de plataforma digital');
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1013, 12, 107, DATE '2025-10-08', 'Revisión de documentos');

-- Visitas de Miguel Santana
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1014, 13, 108, DATE '2025-10-09', 'Cliente solicita re-cotización');
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1015, 14, 108, DATE '2025-10-10', 'Negociación en curso');

-- Visitas de Patricia Núñez
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1016, 15, 109, DATE '2025-10-11', 'Demostración de producto');
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1017, 16, 109, DATE '2025-10-13', 'Cliente confirma interés');

-- Visitas de Javier Peralta
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1018, 5, 110, DATE '2025-10-14', 'Segunda visita, análisis de crédito');
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1019, 7, 110, DATE '2025-10-15', 'Cliente solicita reunión de cierre');
INSERT INTO Visitas (IdVisita, IdCliente, IdEjecutivo, FechaVisita, Resultado) VALUES (1020, 10, 110, DATE '2025-10-16', 'Pendiente por firma de contrato');


----Datos Ventas
-- Ventas de Cliente TechCorp (1) - Asociadas a Ana (101)
INSERT INTO Ventas (IdVenta, IdCliente, FechaVenta, Monto, Producto) VALUES (2001, 1, DATE '2025-09-16', 50000.00, 'Línea de Crédito');
INSERT INTO Ventas (IdVenta, IdCliente, FechaVenta, Monto, Producto) VALUES (2002, 1, DATE '2025-10-01', 15000.00, 'Préstamo PYME');
-- Venta de Cliente Comercial Beta (2) - Asociada a Luis (102)
INSERT INTO Ventas (IdVenta, IdCliente, FechaVenta, Monto, Producto) VALUES (2003, 2, DATE '2025-09-10', 80000.00, 'Fideicomiso');
-- Venta de Cliente Ferretería El Sol (4) - Asociada a Sofía (103)
INSERT INTO Ventas (IdVenta, IdCliente, FechaVenta, Monto, Producto) VALUES (2004, 4, DATE '2025-10-05', 10000.00, 'Microcrédito');

----selects 
Select * from ejecutivos;
Select * from clientes;
Select * from visitas;
Select * from ventas;
select * from ventas_etl_errores;

----consulta de productividad
SELECT
    E.IdEjecutivo,
    E.Nombre || ' ' || E.Apellido AS NombreEjecutivo, -- Usa || para concatenar en Oracle
    COUNT(DISTINCT V.IdVisita) AS TotalVisitas,
    SUM(VE.Monto) AS MontoTotalVentas,
    -- Calcular Promedio de Ventas por Cliente
    CASE
        WHEN COUNT(DISTINCT VE.IdCliente) = 0 THEN 0
        ELSE SUM(VE.Monto) / COUNT(DISTINCT VE.IdCliente)
    END AS PromedioVentasPorCliente
FROM
    Ejecutivos E
LEFT JOIN
    Visitas V ON E.IdEjecutivo = V.IdEjecutivo
LEFT JOIN
    Ventas VE ON V.IdCliente = VE.IdCliente
GROUP BY
    E.IdEjecutivo, E.Nombre, E.Apellido
ORDER BY
    MontoTotalVentas DESC, TotalVisitas DESC;
    
SELECT
    E.IdEjecutivo,
    E.Nombre || ' ' || E.Apellido AS NombreEjecutivo,
    
    -- Totales Absolutos
    T_VISITAS.TotalVisitas,
    T_VENTAS.MontoTotalVentas,
    T_VENTAS.TotalVentasRealizadas,

    CASE
        WHEN T_VENTAS.TotalClientesConVenta > 0 THEN T_VISITAS.TotalVisitas / T_VENTAS.TotalClientesConVenta
        ELSE 0
    END AS VisitasPorClienteConVenta,
    
    -- Mide el valor promedio por visita (eficacia)
    CASE
        WHEN T_VISITAS.TotalVisitas > 0 THEN T_VENTAS.MontoTotalVentas / T_VISITAS.TotalVisitas
        ELSE 0
    END AS ValorPromedioPorVisita,
    

    T_VENTAS.PromedioMontoVenta,
    T_VENTAS.PromedioVentasPorCliente

FROM
    Ejecutivos E
    
-- Subconsulta para calcular Total de Visitas (T_VISITAS)
LEFT JOIN (
    SELECT
        IdEjecutivo,
        COUNT(IdVisita) AS TotalVisitas
    FROM
        Visitas
    GROUP BY
        IdEjecutivo
) T_VISITAS ON E.IdEjecutivo = T_VISITAS.IdEjecutivo
    
-- Subconsulta para calcular Métricas de Ventas (T_VENTAS)
LEFT JOIN (
    SELECT
        V.IdEjecutivo,
        SUM(VE.Monto) AS MontoTotalVentas,
        COUNT(VE.IdVenta) AS TotalVentasRealizadas,
        AVG(VE.Monto) AS PromedioMontoVenta,
        COUNT(DISTINCT VE.IdCliente) AS TotalClientesConVenta,
        
        -- Promedio de Ventas por Cliente
        CASE
            WHEN COUNT(DISTINCT VE.IdCliente) > 0 THEN SUM(VE.Monto) / COUNT(DISTINCT VE.IdCliente)
            ELSE 0
        END AS PromedioVentasPorCliente
    FROM
        Visitas V
    JOIN
        Ventas VE ON V.IdCliente = VE.IdCliente
    GROUP BY
        V.IdEjecutivo
) T_VENTAS ON E.IdEjecutivo = T_VENTAS.IdEjecutivo

ORDER BY
    T_VENTAS.MontoTotalVentas DESC, T_VISITAS.TotalVisitas DESC;
