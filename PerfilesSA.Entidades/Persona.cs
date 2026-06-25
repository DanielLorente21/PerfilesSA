using System;
using System.Runtime.Serialization;

namespace PerfilesSA.Entidades
{
    [DataContract]
    public abstract class Persona
    {
        [DataMember]
        public virtual string Nombres { get; set; }

        [DataMember]
        public virtual string DPI { get; set; }

        [DataMember]
        public virtual DateTime FechaNacimiento { get; set; }

        [DataMember]
        public virtual char Sexo { get; set; }

        public virtual int CalcularEdad()
        {
            DateTime hoy = DateTime.Today;
            int edad = hoy.Year - FechaNacimiento.Year;

            if (FechaNacimiento.Date > hoy.AddYears(-edad))
            {
                edad--;
            }

            return edad;
        }

        public virtual bool EsValido(out string mensajeError)
        {
            mensajeError = string.Empty;

            if (string.IsNullOrWhiteSpace(Nombres))
            {
                mensajeError = "El nombre es obligatorio.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(DPI) || DPI.Length != 13)
            {
                mensajeError = "El DPI debe tener 13 dígitos.";
                return false;
            }

            if (Sexo != 'M' && Sexo != 'F')
            {
                mensajeError = "El sexo debe ser 'M' o 'F'.";
                return false;
            }

            if (FechaNacimiento >= DateTime.Today)
            {
                mensajeError = "La fecha de nacimiento no es válida.";
                return false;
            }

            return true;
        }
    }
}