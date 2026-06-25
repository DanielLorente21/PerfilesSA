<%@ Page Title="Reporte de Empleados" Language="C#" AutoEventWireup="true" CodeBehind="Reportes.aspx.cs" Inherits="PerfilesSA.Web.Reportes" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reporte de Empleados - PERFILES, S.A.</title>
    <link rel="stylesheet" type="text/css" href="Styles/Site.css" />
</head>
<body>
    <form id="formReportes" runat="server">
        <div class="contenedor">
            <h1>Reporte de Empleados por Departamento</h1>

            <div class="panel-formulario">
                <h2>Filtros</h2>

                <div class="campo">
                    <label for="ddlDepartamentoFiltro">Departamento:</label>
                    <asp:DropDownList ID="ddlDepartamentoFiltro" runat="server" CssClass="input-select"
                        DataTextField="NombreDepartamento" DataValueField="IdDepartamento">
                    </asp:DropDownList>
                </div>

                <div class="campo">
                    <label for="txtFechaDesde">Fecha de Ingreso - Desde:</label>
                    <asp:TextBox ID="txtFechaDesde" runat="server" CssClass="input-texto" TextMode="Date"></asp:TextBox>
                </div>

                <div class="campo">
                    <label for="txtFechaHasta">Fecha de Ingreso - Hasta:</label>
                    <asp:TextBox ID="txtFechaHasta" runat="server" CssClass="input-texto" TextMode="Date"></asp:TextBox>
                </div>

                <div class="campo-acciones">
                    <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="boton boton-primario" OnClick="btnFiltrar_Click" />
                    <asp:Button ID="btnLimpiarFiltros" runat="server" Text="Quitar filtros" CssClass="boton boton-secundario" OnClick="btnLimpiarFiltros_Click" />
                </div>
            </div>

            <div class="panel-tabla">
                <h2>Resultados</h2>

                <asp:GridView ID="gvReporte" runat="server"
                    AutoGenerateColumns="false"
                    CssClass="tabla-datos"
                    EmptyDataText="No hay empleados que coincidan con el filtro seleccionado.">
                    <Columns>
                        <asp:BoundField DataField="Nombres" HeaderText="Nombres" />
                        <asp:BoundField DataField="DPI" HeaderText="DPI" />
                        <asp:BoundField DataField="Edad" HeaderText="Edad" />
                        <asp:BoundField DataField="FechaIngreso" HeaderText="Fecha de Ingreso" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="AntiguedadAnios" HeaderText="Antigüedad (años)" />
                        <asp:BoundField DataField="NombreDepartamento" HeaderText="Departamento" />
                        <asp:TemplateField HeaderText="Estado">
                            <ItemTemplate>
                                <span class='<%# (bool)Eval("Activo") ? "etiqueta-activo" : "etiqueta-inactivo" %>'>
                                    <%# (bool)Eval("Activo") ? "Activo" : "Inactivo" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <p><a href="Empleados.aspx">Ir a Empleados</a> | <a href="Departamentos.aspx">Ir a Departamentos</a></p>
        </div>
    </form>
</body>
</html>