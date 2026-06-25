using System;
using System.Runtime.Serialization;

namespace PerfilesSA.Entidades
{
    [DataContract]
    public class Departamento
    {
        [DataMember]
        public int IdDepartamento { get; set; }

        [DataMember]
        public string NombreDepartamento { get; set; }

        [DataMember]
        public bool Activo { get; set; }

        [DataMember]
        public DateTime FechaCreacion { get; set; }

        public bool EsValido(out string mensajeError)
        {
            mensajeError = string.Empty;

            if (string.IsNullOrWhiteSpace(NombreDepartamento))
            {
                mensajeError = "El nombre del departamento es obligatorio.";
                return false;
            }

            if (NombreDepartamento.Length > 100)
            {
                mensajeError = "El nombre del departamento no puede exceder 100 caracteres.";
                return false;
            }

            return true;
        }
    }
}