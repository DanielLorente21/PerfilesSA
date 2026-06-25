using System.Collections.Generic;
using System.ServiceModel;
using PerfilesSA.Entidades;

namespace PerfilesSA.Contratos
{
    [ServiceContract]
    public interface IServicioEmpleado
    {
        [OperationContract]
        RespuestaServicio InsertarEmpleado(Empleado empleado);

        [OperationContract]
        RespuestaServicio ActualizarEmpleado(Empleado empleado);

        [OperationContract]
        RespuestaServicio CambiarEstadoEmpleado(int idEmpleado, bool activo);

        [OperationContract]
        Empleado ObtenerEmpleadoPorId(int idEmpleado);

        [OperationContract]
        List<Empleado> ObtenerTodosLosEmpleados();

        [OperationContract]
        List<Empleado> ObtenerReporteEmpleados(int? idDepartamento, System.DateTime? fechaDesde, System.DateTime? fechaHasta);
    }
}