using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using PerfilesSA.Entidades;

namespace PerfilesSA.DAL
{
    public class DepartamentoDAL
    {
        public int Insertar(Departamento departamento)
        {
            using (SqlConnection conexion = Conexion.ObtenerConexion())
            using (SqlCommand comando = new SqlCommand("SP_Departamento_Insertar", conexion))
            {
                comando.CommandType = CommandType.StoredProcedure;

                comando.Parameters.AddWithValue("@NombreDepartamento", departamento.NombreDepartamento);

                SqlParameter parametroSalida = new SqlParameter("@IdDepartamentoOut", SqlDbType.Int);
                parametroSalida.Direction = ParameterDirection.Output;
                comando.Parameters.Add(parametroSalida);

                conexion.Open();
                comando.ExecuteNonQuery();

                return Convert.ToInt32(parametroSalida.Value);
            }
        }

        public void Actualizar(Departamento departamento)
        {
            using (SqlConnection conexion = Conexion.ObtenerConexion())
            using (SqlCommand comando = new SqlCommand("SP_Departamento_Actualizar", conexion))
            {
                comando.CommandType = CommandType.StoredProcedure;

                comando.Parameters.AddWithValue("@IdDepartamento", departamento.IdDepartamento);
                comando.Parameters.AddWithValue("@NombreDepartamento", departamento.NombreDepartamento);

                conexion.Open();
                comando.ExecuteNonQuery();
            }
        }

        public void CambiarEstado(int idDepartamento, bool activo)
        {
            using (SqlConnection conexion = Conexion.ObtenerConexion())
            using (SqlCommand comando = new SqlCommand("SP_Departamento_CambiarEstado", conexion))
            {
                comando.CommandType = CommandType.StoredProcedure;

                comando.Parameters.AddWithValue("@IdDepartamento", idDepartamento);
                comando.Parameters.AddWithValue("@Activo", activo);

                conexion.Open();
                comando.ExecuteNonQuery();
            }
        }

        public List<Departamento> ObtenerTodos()
        {
            List<Departamento> lista = new List<Departamento>();

            using (SqlConnection conexion = Conexion.ObtenerConexion())
            using (SqlCommand comando = new SqlCommand("SP_Departamento_ObtenerTodos", conexion))
            {
                comando.CommandType = CommandType.StoredProcedure;

                conexion.Open();
                using (SqlDataReader lector = comando.ExecuteReader())
                {
                    while (lector.Read())
                    {
                        lista.Add(MapearDepartamento(lector));
                    }
                }
            }

            return lista;
        }

        public List<Departamento> ObtenerActivos()
        {
            List<Departamento> lista = new List<Departamento>();

            using (SqlConnection conexion = Conexion.ObtenerConexion())
            using (SqlCommand comando = new SqlCommand("SP_Departamento_ObtenerActivos", conexion))
            {
                comando.CommandType = CommandType.StoredProcedure;

                conexion.Open();
                using (SqlDataReader lector = comando.ExecuteReader())
                {
                    while (lector.Read())
                    {
                        Departamento departamento = new Departamento
                        {
                            IdDepartamento = Convert.ToInt32(lector["IdDepartamento"]),
                            NombreDepartamento = lector["NombreDepartamento"].ToString()
                        };
                        lista.Add(departamento);
                    }
                }
            }

            return lista;
        }

        public Departamento ObtenerPorId(int idDepartamento)
        {
            using (SqlConnection conexion = Conexion.ObtenerConexion())
            using (SqlCommand comando = new SqlCommand("SP_Departamento_ObtenerPorId", conexion))
            {
                comando.CommandType = CommandType.StoredProcedure;
                comando.Parameters.AddWithValue("@IdDepartamento", idDepartamento);

                conexion.Open();
                using (SqlDataReader lector = comando.ExecuteReader())
                {
                    if (lector.Read())
                    {
                        return MapearDepartamento(lector);
                    }
                }
            }

            return null;
        }

        private Departamento MapearDepartamento(SqlDataReader lector)
        {
            return new Departamento
            {
                IdDepartamento = Convert.ToInt32(lector["IdDepartamento"]),
                NombreDepartamento = lector["NombreDepartamento"].ToString(),
                Activo = Convert.ToBoolean(lector["Activo"]),
                FechaCreacion = Convert.ToDateTime(lector["FechaCreacion"])
            };
        }
    }
}