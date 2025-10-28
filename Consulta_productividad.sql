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
