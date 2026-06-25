using System;
using System.Collections.Generic;
using PerfilesSA.Contratos;
using PerfilesSA.DAL;
using PerfilesSA.Entidades;

namespace PerfilesSA.Servicios
{
    public class ServicioEmpleado : IServicioEmpleado
    {
        private readonly EmpleadoDAL _empleadoDAL;

        public ServicioEmpleado()
        {
            _empleadoDAL = new EmpleadoDAL();
        }

        public RespuestaServicio InsertarEmpleado(Empleado empleado)
        {
            try
            {
                string mensajeError;
                if (!empleado.EsValido(out mensajeError))
                {
                    return RespuestaServicio.Error(mensajeError);
                }

                int idGenerado = _empleadoDAL.Insertar(empleado);
                return RespuestaServicio.Ok("Empleado registrado correctamente.", idGenerado);
            }
            catch (Exception ex)
            {
                return RespuestaServicio.Error("Error al registrar empleado: " + ex.Message);
            }
        }

        public RespuestaServicio ActualizarEmpleado(Empleado empleado)
        {
            try
            {
                string mensajeError;
                if (!empleado.EsValido(out mensajeError))
                {
                    return RespuestaServicio.Error(mensajeError);
                }

                _empleadoDAL.Actualizar(empleado);
                return RespuestaServicio.Ok("Empleado actualizado correctamente.");
            }
            catch (Exception ex)
            {
                return RespuestaServicio.Error("Error al actualizar empleado: " + ex.Message);
            }
        }

        public RespuestaServicio CambiarEstadoEmpleado(int idEmpleado, bool activo)
        {
            try
            {
                _empleadoDAL.CambiarEstado(idEmpleado, activo);
                string accion = activo ? "activado" : "inactivado";
                return RespuestaServicio.Ok("Empleado " + accion + " correctamente.");
            }
            catch (Exception ex)
            {
                return RespuestaServicio.Error("Error al cambiar estado del empleado: " + ex.Message);
            }
        }

        public Empleado ObtenerEmpleadoPorId(int idEmpleado)
        {
            Empleado empleado = _empleadoDAL.ObtenerPorId(idEmpleado);
            CalcularValoresEnTiempoReal(empleado);
            return empleado;
        }

        public List<Empleado> ObtenerTodosLosEmpleados()
        {
            List<Empleado> empleados = _empleadoDAL.ObtenerTodos();
            foreach (Empleado empleado in empleados)
            {
                CalcularValoresEnTiempoReal(empleado);
            }
            return empleados;
        }

        public List<Empleado> ObtenerReporteEmpleados(int? idDepartamento, DateTime? fechaDesde, DateTime? fechaHasta)
        {
            return _empleadoDAL.ObtenerReporte(idDepartamento, fechaDesde, fechaHasta);
        }

        private void CalcularValoresEnTiempoReal(Empleado empleado)
        {
            if (empleado == null) return;

            empleado.Edad = empleado.CalcularEdad();
            empleado.AntiguedadAnios = empleado.CalcularAntiguedad();
        }
    }
}