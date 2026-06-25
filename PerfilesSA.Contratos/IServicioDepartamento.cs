using System.Collections.Generic;
using System.ServiceModel;
using PerfilesSA.Entidades;

namespace PerfilesSA.Contratos
{
    [ServiceContract]
    public interface IServicioDepartamento
    {
        [OperationContract]
        RespuestaServicio InsertarDepartamento(Departamento departamento);

        [OperationContract]
        RespuestaServicio ActualizarDepartamento(Departamento departamento);

        [OperationContract]
        RespuestaServicio CambiarEstadoDepartamento(int idDepartamento, bool activo);

        [OperationContract]
        Departamento ObtenerDepartamentoPorId(int idDepartamento);

        [OperationContract]
        List<Departamento> ObtenerTodosLosDepartamentos();

        [OperationContract]
        List<Departamento> ObtenerDepartamentosActivos();
    }
}