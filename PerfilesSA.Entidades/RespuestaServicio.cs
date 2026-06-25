using System.Runtime.Serialization;

namespace PerfilesSA.Entidades
{
    [DataContract]
    public class RespuestaServicio
    {
        [DataMember]
        public bool Exito { get; set; }

        [DataMember]
        public string Mensaje { get; set; }

        [DataMember]
        public int IdGenerado { get; set; }

        public static RespuestaServicio Ok(string mensaje = "Operación realizada correctamente.", int idGenerado = 0)
        {
            return new RespuestaServicio { Exito = true, Mensaje = mensaje, IdGenerado = idGenerado };
        }

        public static RespuestaServicio Error(string mensaje)
        {
            return new RespuestaServicio { Exito = false, Mensaje = mensaje, IdGenerado = 0 };
        }
    }
}