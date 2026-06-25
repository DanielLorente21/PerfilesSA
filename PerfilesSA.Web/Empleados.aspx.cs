using System;
using PerfilesSA.Entidades;
using PerfilesSA.Web.ServiceReference1;
using PerfilesSA.Web.ServiceReference2;

namespace PerfilesSA.Web
{
    public partial class Empleados : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarDepartamentosActivos();
                CargarEmpleados();
            }
        }

        private void CargarDepartamentosActivos()
        {
            using (ServicioDepartamentoClient cliente = new ServicioDepartamentoClient())
            {
                var departamentos = cliente.ObtenerDepartamentosActivos();
                ddlDepartamento.DataSource = departamentos;
                ddlDepartamento.DataBind();
                ddlDepartamento.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Seleccione --", ""));
            }
        }

        private void CargarEmpleados()
        {
            using (ServicioEmpleadoClient cliente = new ServicioEmpleadoClient())
            {
                var empleados = cliente.ObtenerTodosLosEmpleados();
                gvEmpleados.DataSource = empleados;
                gvEmpleados.DataBind();
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            int idEmpleado = Convert.ToInt32(hfIdEmpleado.Value);

            Empleado empleado = new Empleado
            {
                IdEmpleado = idEmpleado,
                Nombres = txtNombres.Text.Trim(),
                DPI = txtDPI.Text.Trim(),
                FechaNacimiento = Convert.ToDateTime(txtFechaNacimiento.Text),
                Sexo = ddlSexo.SelectedValue[0],
                FechaIngreso = Convert.ToDateTime(txtFechaIngreso.Text),
                Direccion = string.IsNullOrWhiteSpace(txtDireccion.Text) ? null : txtDireccion.Text.Trim(),
                NIT = string.IsNullOrWhiteSpace(txtNIT.Text) ? null : txtNIT.Text.Trim(),
                IdDepartamento = Convert.ToInt32(ddlDepartamento.SelectedValue)
            };

            using (ServicioEmpleadoClient cliente = new ServicioEmpleadoClient())
            {
                RespuestaServicio respuesta;

                if (idEmpleado == 0)
                {
                    respuesta = cliente.InsertarEmpleado(empleado);
                }
                else
                {
                    respuesta = cliente.ActualizarEmpleado(empleado);
                }

                MostrarMensaje(respuesta.Mensaje, respuesta.Exito);

                if (respuesta.Exito)
                {
                    LimpiarFormulario();
                    CargarEmpleados();
                }
            }
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            LimpiarFormulario();
        }

        protected void gvEmpleados_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int idEmpleado = Convert.ToInt32(e.CommandArgument);

            using (ServicioEmpleadoClient cliente = new ServicioEmpleadoClient())
            {
                if (e.CommandName == "Editar")
                {
                    Empleado empleado = cliente.ObtenerEmpleadoPorId(idEmpleado);
                    if (empleado != null)
                    {
                        hfIdEmpleado.Value = empleado.IdEmpleado.ToString();
                        txtNombres.Text = empleado.Nombres;
                        txtDPI.Text = empleado.DPI;
                        txtFechaNacimiento.Text = empleado.FechaNacimiento.ToString("yyyy-MM-dd");
                        ddlSexo.SelectedValue = empleado.Sexo.ToString();
                        txtFechaIngreso.Text = empleado.FechaIngreso.ToString("yyyy-MM-dd");
                        txtDireccion.Text = empleado.Direccion;
                        txtNIT.Text = empleado.NIT;
                        ddlDepartamento.SelectedValue = empleado.IdDepartamento.ToString();
                    }
                }
                else if (e.CommandName == "CambiarEstado")
                {
                    Empleado empleado = cliente.ObtenerEmpleadoPorId(idEmpleado);
                    bool nuevoEstado = !empleado.Activo;

                    RespuestaServicio respuesta = cliente.CambiarEstadoEmpleado(idEmpleado, nuevoEstado);
                    MostrarMensaje(respuesta.Mensaje, respuesta.Exito);
                    CargarEmpleados();
                }
            }
        }

        private void LimpiarFormulario()
        {
            hfIdEmpleado.Value = "0";
            txtNombres.Text = string.Empty;
            txtDPI.Text = string.Empty;
            txtFechaNacimiento.Text = string.Empty;
            ddlSexo.SelectedIndex = 0;
            txtFechaIngreso.Text = string.Empty;
            txtDireccion.Text = string.Empty;
            txtNIT.Text = string.Empty;
            ddlDepartamento.SelectedIndex = 0;
        }

        private void MostrarMensaje(string mensaje, bool exito)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = exito ? "mensaje mensaje-exito" : "mensaje mensaje-error-fondo";
        }
    }
}