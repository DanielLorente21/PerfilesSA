using System;
using System.Runtime.Serialization;

namespace PerfilesSA.Entidades
{
    [DataContract]
    public class Empleado : Persona
    {
        [DataMember]
        public int IdEmpleado { get; set; }

        // Nombres, DPI, FechaNacimiento y Sexo ya están marcados con [DataMember]
        // en la clase base Persona, por lo que no es necesario redeclararlos aquí.

        [DataMember]
        public DateTime FechaIngreso { get; set; }

        [DataMember]
        public string Direccion { get; set; }

        [DataMember]
        public string NIT { get; set; }

        [DataMember]
        public int IdDepartamento { get; set; }

        [DataMember]
        public string NombreDepartamento { get; set; }

        [DataMember]
        public bool Activo { get; set; }

        [DataMember]
        public int Edad { get; set; }

        [DataMember]
        public int AntiguedadAnios { get; set; }

        public int CalcularAntiguedad()
        {
            DateTime hoy = DateTime.Today;
            int anios = hoy.Year - FechaIngreso.Year;

            if (FechaIngreso.Date > hoy.AddYears(-anios))
            {
                anios--;
            }

            return anios;
        }

        public override bool EsValido(out string mensajeError)
        {
            if (!base.EsValido(out mensajeError))
            {
                return false;
            }

            if (IdDepartamento <= 0)
            {
                mensajeError = "Debe seleccionar un departamento.";
                return false;
            }

            if (FechaIngreso > DateTime.Today)
            {
                mensajeError = "La fecha de ingreso no puede ser futura.";
                return false;
            }

            if (FechaIngreso < FechaNacimiento)
            {
                mensajeError = "La fecha de ingreso no puede ser anterior a la fecha de nacimiento.";
                return false;
            }

            return true;
        }
    }
}