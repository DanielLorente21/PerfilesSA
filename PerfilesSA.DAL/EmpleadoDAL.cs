using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using PerfilesSA.Entidades;

namespace PerfilesSA.DAL
{
    public class EmpleadoDAL
    {
        public int Insertar(Empleado empleado)
        {
            using (SqlConnection conexion = Conexion.ObtenerConexion())
            using (SqlCommand comando = new SqlCommand("SP_Empleado_Insertar", conexion))
            {
                comando.CommandType = CommandType.StoredProcedure;
                AgregarParametros(comando, empleado);

                SqlParameter parametroSalida = new SqlParameter("@IdEmpleadoOut", SqlDbType.Int);
                parametroSalida.Direction = ParameterDirection.Output;
                comando.Parameters.Add(parametroSalida);

                conexion.Open();
                comando.ExecuteNonQuery();

                return Convert.ToInt32(parametroSalida.Value);
            }
        }

        public void Actualizar(Empleado empleado)
        {
            using (SqlConnection conexion = Conexion.ObtenerConexion())
            using (SqlCommand comando = new SqlCommand("SP_Empleado_Actualizar", conexion))
            {
                comando.CommandType = CommandType.StoredProcedure;
                comando.Parameters.AddWithValue("@IdEmpleado", empleado.IdEmpleado);
                AgregarParametros(comando, empleado);

                conexion.Open();
                comando.ExecuteNonQuery();
            }
        }

        public void CambiarEstado(int idEmpleado, bool activo)
        {
            using (SqlConnection conexion = Conexion.ObtenerConexion())
            using (SqlCommand comando = new SqlCommand("SP_Empleado_CambiarEstado", conexion))
            {
                comando.CommandType = CommandType.StoredProcedure;
                comando.Parameters.AddWithValue("@IdEmpleado", idEmpleado);
                comando.Parameters.AddWithValue("@Activo", activo);

                conexion.Open();
                comando.ExecuteNonQuery();
            }
        }

        public Empleado ObtenerPorId(int idEmpleado)
        {
            using (SqlConnection conexion = Conexion.ObtenerConexion())
            using (SqlCommand comando = new SqlCommand("SP_Empleado_ObtenerPorId", conexion))
            {
                comando.CommandType = CommandType.StoredProcedure;
                comando.Parameters.AddWithValue("@IdEmpleado", idEmpleado);

                conexion.Open();
                using (SqlDataReader lector = comando.ExecuteReader())
                {
                    if (lector.Read())
                    {
                        return MapearEmpleado(lector);
                    }
                }
            }

            return null;
        }

        public List<Empleado> ObtenerTodos()
        {
            List<Empleado> lista = new List<Empleado>();

            using (SqlConnection conexion = Conexion.ObtenerConexion())
            using (SqlCommand comando = new SqlCommand("SP_Empleado_ObtenerTodos", conexion))
            {
                comando.CommandType = CommandType.StoredProcedure;

                conexion.Open();
                using (SqlDataReader lector = comando.ExecuteReader())
                {
                    while (lector.Read())
                    {
                        lista.Add(MapearEmpleado(lector));
                    }
                }
            }

            return lista;
        }

        public List<Empleado> ObtenerReporte(int? idDepartamento, DateTime? fechaDesde, DateTime? fechaHasta)
        {
            List<Empleado> lista = new List<Empleado>();

            using (SqlConnection conexion = Conexion.ObtenerConexion())
            using (SqlCommand comando = new SqlCommand("SP_Empleado_ReportePorDepartamento", conexion))
            {
                comando.CommandType = CommandType.StoredProcedure;

                comando.Parameters.AddWithValue("@IdDepartamento", (object)idDepartamento ?? DBNull.Value);
                comando.Parameters.AddWithValue("@FechaIngresoDesde", (object)fechaDesde ?? DBNull.Value);
                comando.Parameters.AddWithValue("@FechaIngresoHasta", (object)fechaHasta ?? DBNull.Value);

                conexion.Open();
                using (SqlDataReader lector = comando.ExecuteReader())
                {
                    while (lector.Read())
                    {
                        Empleado empleado = new Empleado
                        {
                            IdEmpleado = Convert.ToInt32(lector["IdEmpleado"]),
                            Nombres = lector["Nombres"].ToString(),
                            DPI = lector["DPI"].ToString(),
                            FechaNacimiento = Convert.ToDateTime(lector["FechaNacimiento"]),
                            FechaIngreso = Convert.ToDateTime(lector["FechaIngreso"]),
                            NombreDepartamento = lector["NombreDepartamento"].ToString(),
                            Activo = Convert.ToBoolean(lector["Activo"]),
                            Edad = Convert.ToInt32(lector["Edad"]),
                            AntiguedadAnios = Convert.ToInt32(lector["AntiguedadAnios"])
                        };
                        lista.Add(empleado);
                    }
                }
            }

            return lista;
        }

        private void AgregarParametros(SqlCommand comando, Empleado empleado)
        {
            comando.Parameters.AddWithValue("@Nombres", empleado.Nombres);
            comando.Parameters.AddWithValue("@DPI", empleado.DPI);
            comando.Parameters.AddWithValue("@FechaNacimiento", empleado.FechaNacimiento);
            comando.Parameters.AddWithValue("@Sexo", empleado.Sexo.ToString());
            comando.Parameters.AddWithValue("@FechaIngreso", empleado.FechaIngreso);
            comando.Parameters.AddWithValue("@Direccion", string.IsNullOrEmpty(empleado.Direccion) ? (object)DBNull.Value : empleado.Direccion);
            comando.Parameters.AddWithValue("@NIT", string.IsNullOrEmpty(empleado.NIT) ? (object)DBNull.Value : empleado.NIT);
            comando.Parameters.AddWithValue("@IdDepartamento", empleado.IdDepartamento);
        }

        private Empleado MapearEmpleado(SqlDataReader lector)
        {
            return new Empleado
            {
                IdEmpleado = Convert.ToInt32(lector["IdEmpleado"]),
                Nombres = lector["Nombres"].ToString(),
                DPI = lector["DPI"].ToString(),
                FechaNacimiento = Convert.ToDateTime(lector["FechaNacimiento"]),
                Sexo = Convert.ToChar(lector["Sexo"]),
                FechaIngreso = Convert.ToDateTime(lector["FechaIngreso"]),
                Direccion = lector["Direccion"] == DBNull.Value ? null : lector["Direccion"].ToString(),
                NIT = lector["NIT"] == DBNull.Value ? null : lector["NIT"].ToString(),
                IdDepartamento = Convert.ToInt32(lector["IdDepartamento"]),
                NombreDepartamento = lector["NombreDepartamento"].ToString(),
                Activo = Convert.ToBoolean(lector["Activo"]),
                Edad = Convert.ToInt32(lector["Edad"]),
                AntiguedadAnios = Convert.ToInt32(lector["AntiguedadAnios"])
            };
        }
    }
}