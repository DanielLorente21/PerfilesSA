using System.Configuration;
using System.Data.SqlClient;

namespace PerfilesSA.DAL
{
    public static class Conexion
    {
        public static SqlConnection ObtenerConexion()
        {
            string cadena = ConfigurationManager.ConnectionStrings["PerfilesSA_DB"].ConnectionString;
            return new SqlConnection(cadena);
        }
    }
}