import oracledb
from flask import Flask, jsonify
import sys 

print("--- SCRIPT DE API CARGADO CORRECTAMENTE ---")

# --- CONFIGURACIÓN DE LA APP Y LA BD ---
app = Flask(__name__) 

ORACLE_USER = "system"
ORACLE_PASS = "1234"
ORACLE_DSN = "localhost:1521/xepdb1"

# --- CONSULTA SQL DE PRODUCTIVIDAD ---
SQL_PRODUCTIVIDAD = """
SELECT
    E.IdEjecutivo,
    E.Nombre || ' ' || E.Apellido AS NombreEjecutivo,
    COALESCE(T_VISITAS.TotalVisitas, 0) AS TotalVisitas,
    COALESCE(T_VENTAS.MontoTotalVentas, 0) AS MontoTotalVentas,
    COALESCE(T_VENTAS.TotalVentasRealizadas, 0) AS TotalVentasRealizadas,
    CASE
        WHEN T_VENTAS.TotalClientesConVenta > 0 THEN T_VISITAS.TotalVisitas / T_VENTAS.TotalClientesConVenta
        ELSE 0
    END AS VisitasPorClienteConVenta,
    CASE
        WHEN T_VISITAS.TotalVisitas > 0 THEN T_VENTAS.MontoTotalVentas / T_VISITAS.TotalVisitas
        ELSE 0
    END AS ValorPromedioPorVisita,
    COALESCE(T_VENTAS.PromedioMontoVenta, 0) AS PromedioMontoVenta,
    COALESCE(T_VENTAS.PromedioVentasPorCliente, 0) AS PromedioVentasPorCliente
FROM
    Ejecutivos E
LEFT JOIN (
    SELECT
        IdEjecutivo,
        COUNT(IdVisita) AS TotalVisitas
    FROM
        Visitas
    GROUP BY
        IdEjecutivo
) T_VISITAS ON E.IdEjecutivo = T_VISITAS.IdEjecutivo
LEFT JOIN (
    SELECT
        V.IdEjecutivo,
        SUM(VE.Monto) AS MontoTotalVentas,
        COUNT(VE.IdVenta) AS TotalVentasRealizadas,
        AVG(VE.Monto) AS PromedioMontoVenta,
        COUNT(DISTINCT VE.IdCliente) AS TotalClientesConVenta,
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
    MontoTotalVentas DESC
"""

# --- DEFINICIÓN DEL ENDPOINT DE LA API ---

@app.route('/api/productividad', methods=['GET'])
def get_productividad():
    """
    Este endpoint se conecta a Oracle, ejecuta la consulta 
    de productividad y devuelve los resultados en JSON.
    """
    connection = None
    cursor = None
    resultados_json = []

    try:
        connection = oracledb.connect(user=ORACLE_USER, password=ORACLE_PASS, dsn=ORACLE_DSN)
        cursor = connection.cursor()
        
        cursor.execute(SQL_PRODUCTIVIDAD)
        
        columnas = [desc[0] for desc in cursor.description]
        
        for fila in cursor.fetchall():
            resultados_json.append(dict(zip(columnas, fila)))
            
        return jsonify(resultados_json)

    except oracledb.Error as e:
        print(f"Error de Oracle: {e}")
        return jsonify({"error": f"Error de base de datos: {e}"}), 500
    except Exception as e:
        print(f"Error inesperado: {e}")
        return jsonify({"error": f"Error interno del servidor: {e}"}), 500
        
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()

# --- EJECUTAR EL SERVIDOR ---

if __name__ == '__main__':
    print("--- INICIANDO SERVIDOR WEB (http://127.0.0.1:5000) ---")
    app.run(debug=True, port=5000)