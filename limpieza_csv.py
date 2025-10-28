import pandas as pd
from datetime import datetime
import oracledb 
import sys

ORACLE_USER = "system"
ORACLE_PASS = "1234"
ORACLE_DSN = "localhost:1521/xepdb1"
archivo_csv_entrada = 'ventas_grandes.csv'
# ------------------------------------------------------------------

def ejecutar_etl_completo(): 
    filas_validas_limpias = []
    filas_a_cargar = []      
    filas_errores = [] 

# --------------------------------------------------------
# EXTRACCIÓN Y LIMPIEZA DE FORMATO

    print("--- 1. EXTRACCIÓN Y LIMPIEZA DE FORMATO ---")
    
    try:
        df = pd.read_csv(archivo_csv_entrada, dtype=str)
    except FileNotFoundError:
        print(f"Error. No se encontró el archivo '{archivo_csv_entrada}'.")
        sys.exit(1)

    for index, fila in df.iterrows():
        razon_rechazo = None 
        
        try:
            # Validaciones de formato y nulos
            if pd.isna(fila['IdVenta']) or str(fila['IdVenta']).strip() == '':
                raise ValueError("IdVenta no puede ser nulo.")
            id_venta_limpio = int(fila['IdVenta'])
            
            if pd.isna(fila['IdCliente']) or str(fila['IdCliente']).strip() == '':
                raise ValueError("IdCliente no puede ser nulo.")
            id_cliente_limpio = int(fila['IdCliente'])
            
            if pd.isna(fila['Monto']) or str(fila['Monto']).strip() == '':
                raise ValueError("Monto no puede ser nulo.")
            monto_limpio = float(fila['Monto'])
            
            if pd.isna(fila['FechaVenta']) or str(fila['FechaVenta']).strip() == '':
                raise ValueError("FechaVenta no puede ser nula.")
            fecha_limpia = datetime.strptime(fila['FechaVenta'], '%Y-%m-%d').date()

            fila_limpia = {
                'IdVenta': id_venta_limpio,
                'IdCliente': id_cliente_limpio,
                'FechaVenta': fecha_limpia,
                'Monto': monto_limpio,
                'Producto': fila['Producto']
            }
            filas_validas_limpias.append(fila_limpia)

        except ValueError as e:
            razon_rechazo = str(e)
            fila_error = fila.to_dict()
            fila_error['Razon_Rechazo'] = razon_rechazo
            filas_errores.append(fila_error)
        except Exception as e:
            razon_rechazo = f"Error inesperado: {str(e)}"
            fila_error = fila.to_dict()
            fila_error['Razon_Rechazo'] = razon_rechazo
            filas_errores.append(fila_error)

    print(f"Premera fase de validación completa. Válidos para la siguiente fase: {len(filas_validas_limpias)}. Errores de Formato: {len(filas_errores)}")


# 2. VALIDACIÓN DE INTEGRIDAD Y DUPLICADOS 
    connection = None 
    cursor = None

    ids_en_batch = set()
    
    try:
        print("\n--- 2. VALIDACIÓN DE NEGOCIO (Paso 2) ---")
        
        connection = oracledb.connect(user=ORACLE_USER, password=ORACLE_PASS, dsn=ORACLE_DSN)
        cursor = connection.cursor()
        
        sql_check_cliente = "SELECT COUNT(*) FROM Clientes WHERE IdCliente = :cliente_id"
        sql_check_duplicado_db = "SELECT COUNT(*) FROM Ventas WHERE IdVenta = :venta_id" 

        for fila in filas_validas_limpias: 
            razon_rechazo = None
            
            cursor.execute(sql_check_cliente, {'cliente_id': fila['IdCliente']})
            cliente_existe = cursor.fetchone()[0]

            if cliente_existe == 0:
                razon_rechazo = f"IdCliente {fila['IdCliente']} no existe en la tabla Clientes (Falla Integridad)."

            if not razon_rechazo:
                cursor.execute(sql_check_duplicado_db, {'venta_id': fila['IdVenta']})
                es_duplicado_db = cursor.fetchone()[0]

                if es_duplicado_db > 0:
                    razon_rechazo = f"IdVenta {fila['IdVenta']} ya existe en la BD (Duplicado)."

            if not razon_rechazo:
                if fila['IdVenta'] in ids_en_batch:
                    razon_rechazo = f"IdVenta {fila['IdVenta']} está duplicado en el archivo CSV (Duplicado de Batch)."
                else:
                    ids_en_batch.add(fila['IdVenta'])

            if razon_rechazo:
                fila['Razon_Rechazo'] = razon_rechazo
                filas_errores.append(fila)
            else:
                filas_a_cargar.append(fila)

        print(f"Registros listos para carga final: {len(filas_a_cargar)}.")
        
# 3. CARGA FINAL A LAS TABLAS EN LA BD 

        
        print("\n--- CARGA DE DESTINO ---")

        # 3.A. Cargar datos válidos en la tabla ventas
        if filas_a_cargar:
            datos_ventas_final = [
                (f['IdVenta'], f['IdCliente'], f['FechaVenta'], f['Monto'], f['Producto'])
                for f in filas_a_cargar
            ]
            sql_insert_ventas = """
            INSERT INTO Ventas (IdVenta, IdCliente, FechaVenta, Monto, Producto)
            VALUES (:1, :2, :3, :4, :5)
            """
            cursor.executemany(sql_insert_ventas, datos_ventas_final)
            print(f"Se cargaron {len(datos_ventas_final)} registros en 'Ventas' con éxito.")
        else:
            print("No hay registros válidos para cargar en la tabla 'Ventas'.")

        #Carga de rrores finales en la tabla Ventas_ETL_Errores
        if filas_errores:
            errores_para_db = []
            for error in filas_errores:
                errores_para_db.append((
                    str(error.get('IdVenta')) if error.get('IdVenta') is not None else None,
                    str(error.get('IdCliente')) if error.get('IdCliente') is not None else None,
                    str(error.get('FechaVenta')) if error.get('FechaVenta') is not None else None,
                    str(error.get('Monto')) if error.get('Monto') is not None else None,
                    error.get('Producto'),
                    error.get('Razon_Rechazo')
                ))
            
            sql_insert_errores = """
            INSERT INTO Ventas_ETL_Errores (IdVenta_Origen, IdCliente_Origen, FechaVenta_Origen, Monto_Origen, Producto_Origen, Razon_Rechazo)
            VALUES (:1, :2, :3, :4, :5, :6)
            """
            cursor.executemany(sql_insert_errores, errores_para_db)
            print(f"Se cargaron {len(errores_para_db)} errores en 'Ventas_ETL_Errores' con éxito.")

        # COMMIT FINAL: Confirma todas las inserciones
        connection.commit()
        print("Proceso ETL completado y transacción confirmada.")

    except oracledb.Error as e: 
        print(f"ERROR CRÍTICO DE BD: {e}")
        if connection:
            connection.rollback()
            print("Se realizó ROLLBACK. Ningún dato fue guardado.")
    except Exception as e:
        print(f"ERROR INESPERADO: {e}")
        
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()
            print("Conexión a Oracle cerrada.")

if __name__ == "__main__":
    ejecutar_etl_completo()