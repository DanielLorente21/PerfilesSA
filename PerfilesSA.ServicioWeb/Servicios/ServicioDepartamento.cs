using System;
using System.Collections.Generic;
using PerfilesSA.Contratos;
using PerfilesSA.DAL;
using PerfilesSA.Entidades;

namespace PerfilesSA.Servicios
{
    public class ServicioDepartamento : IServicioDepartamento
    {
        private readonly DepartamentoDAL _departamentoDAL;

        public ServicioDepartamento()
        {
            _departamentoDAL = new DepartamentoDAL();
        }

        public RespuestaServicio InsertarDepartamento(Departamento departamento)
        {
            try
            {
                string mensajeError;
                if (!departamento.EsValido(out mensajeError))
                {
                    return RespuestaServicio.Error(mensajeError);
                }

                int idGenerado = _departamentoDAL.Insertar(departamento);
                return RespuestaServicio.Ok("Departamento registrado correctamente.", idGenerado);
            }
            catch (Exception ex)
            {
                return RespuestaServicio.Error("Error al registrar departamento: " + ex.Message);
            }
        }

        public RespuestaServicio ActualizarDepartamento(Departamento departamento)
        {
            try
            {
                string mensajeError;
                if (!departamento.EsValido(out mensajeError))
                {
                    return RespuestaServicio.Error(mensajeError);
                }

                _departamentoDAL.Actualizar(departamento);
                return RespuestaServicio.Ok("Departamento actualizado correctamente.");
            }
            catch (Exception ex)
            {
                return RespuestaServicio.Error("Error al actualizar departamento: " + ex.Message);
            }
        }

        public RespuestaServicio CambiarEstadoDepartamento(int idDepartamento, bool activo)
        {
            try
            {
                _departamentoDAL.CambiarEstado(idDepartamento, activo);
                string accion = activo ? "habilitado" : "deshabilitado";
                string detalle = activo ? "" : " Los empleados asignados a este departamento fueron inactivados automáticamente.";
                return RespuestaServicio.Ok("Departamento " + accion + " correctamente." + detalle);
            }
            catch (Exception ex)
            {
                return RespuestaServicio.Error("Error al cambiar estado del departamento: " + ex.Message);
            }
        }

        public Departamento ObtenerDepartamentoPorId(int idDepartamento)
        {
            return _departamentoDAL.ObtenerPorId(idDepartamento);
        }

        public List<Departamento> ObtenerTodosLosDepartamentos()
        {
            return _departamentoDAL.ObtenerTodos();
        }

        public List<Departamento> ObtenerDepartamentosActivos()
        {
            return _departamentoDAL.ObtenerActivos();
        }
    }
}