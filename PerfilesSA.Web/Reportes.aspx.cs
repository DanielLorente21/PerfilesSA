using System;
using PerfilesSA.Entidades;
using PerfilesSA.Web.ServiceReference1;
using PerfilesSA.Web.ServiceReference2;

namespace PerfilesSA.Web
{
    public partial class Reportes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarDepartamentosFiltro();
                CargarReporte(null, null, null);
            }
        }

        private void CargarDepartamentosFiltro()
        {
            using (ServicioDepartamentoClient cliente = new ServicioDepartamentoClient())
            {
                var departamentos = cliente.ObtenerTodosLosDepartamentos();
                ddlDepartamentoFiltro.DataSource = departamentos;
                ddlDepartamentoFiltro.DataBind();
                ddlDepartamentoFiltro.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Todos --", ""));
            }
        }

        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            int? idDepartamento = string.IsNullOrEmpty(ddlDepartamentoFiltro.SelectedValue)
                ? (int?)null
                : Convert.ToInt32(ddlDepartamentoFiltro.SelectedValue);

            DateTime? fechaDesde = string.IsNullOrEmpty(txtFechaDesde.Text)
                ? (DateTime?)null
                : Convert.ToDateTime(txtFechaDesde.Text);

            DateTime? fechaHasta = string.IsNullOrEmpty(txtFechaHasta.Text)
                ? (DateTime?)null
                : Convert.ToDateTime(txtFechaHasta.Text);

            CargarReporte(idDepartamento, fechaDesde, fechaHasta);
        }

        protected void btnLimpiarFiltros_Click(object sender, EventArgs e)
        {
            ddlDepartamentoFiltro.SelectedIndex = 0;
            txtFechaDesde.Text = string.Empty;
            txtFechaHasta.Text = string.Empty;
            CargarReporte(null, null, null);
        }

        private void CargarReporte(int? idDepartamento, DateTime? fechaDesde, DateTime? fechaHasta)
        {
            using (ServicioEmpleadoClient cliente = new ServicioEmpleadoClient())
            {
                var resultado = cliente.ObtenerReporteEmpleados(idDepartamento, fechaDesde, fechaHasta);
                gvReporte.DataSource = resultado;
                gvReporte.DataBind();
            }
        }
    }
}