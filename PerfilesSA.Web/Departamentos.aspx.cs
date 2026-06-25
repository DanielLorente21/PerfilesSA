using System;
using PerfilesSA.Entidades;
using PerfilesSA.Web.ServiceReference1;
using PerfilesSA.Web.ServiceReference2;

namespace PerfilesSA.Web
{
    public partial class Departamentos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarDepartamentos();
            }
        }

        private void CargarDepartamentos()
        {
            using (ServicioDepartamentoClient cliente = new ServicioDepartamentoClient())
            {
                var departamentos = cliente.ObtenerTodosLosDepartamentos();
                gvDepartamentos.DataSource = departamentos;
                gvDepartamentos.DataBind();
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            int idDepartamento = Convert.ToInt32(hfIdDepartamento.Value);

            Departamento departamento = new Departamento
            {
                IdDepartamento = idDepartamento,
                NombreDepartamento = txtNombreDepartamento.Text.Trim()
            };

            using (ServicioDepartamentoClient cliente = new ServicioDepartamentoClient())
            {
                RespuestaServicio respuesta;

                if (idDepartamento == 0)
                {
                    respuesta = cliente.InsertarDepartamento(departamento);
                }
                else
                {
                    respuesta = cliente.ActualizarDepartamento(departamento);
                }

                MostrarMensaje(respuesta.Mensaje, respuesta.Exito);

                if (respuesta.Exito)
                {
                    LimpiarFormulario();
                    CargarDepartamentos();
                }
            }
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }

        protected void gvDepartamentos_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int idDepartamento = Convert.ToInt32(e.CommandArgument);

            using (ServicioDepartamentoClient cliente = new ServicioDepartamentoClient())
            {
                if (e.CommandName == "Editar")
                {
                    Departamento departamento = cliente.ObtenerDepartamentoPorId(idDepartamento);
                    if (departamento != null)
                    {
                        hfIdDepartamento.Value = departamento.IdDepartamento.ToString();
                        txtNombreDepartamento.Text = departamento.NombreDepartamento;
                    }
                }
                else if (e.CommandName == "CambiarEstado")
                {
                    Departamento departamento = cliente.ObtenerDepartamentoPorId(idDepartamento);
                    bool nuevoEstado = !departamento.Activo;

                    RespuestaServicio respuesta = cliente.CambiarEstadoDepartamento(idDepartamento, nuevoEstado);
                    MostrarMensaje(respuesta.Mensaje, respuesta.Exito);
                    CargarDepartamentos();
                }
            }
        }

        private void LimpiarFormulario()
        {
            hfIdDepartamento.Value = "0";
            txtNombreDepartamento.Text = string.Empty;
        }

        private void MostrarMensaje(string mensaje, bool exito)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = exito ? "mensaje mensaje-exito" : "mensaje mensaje-error-fondo";
        }
    }
}