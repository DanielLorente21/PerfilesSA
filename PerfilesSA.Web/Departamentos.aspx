<%@ Page Title="Departamentos" Language="C#" AutoEventWireup="true" CodeBehind="Departamentos.aspx.cs" Inherits="PerfilesSA.Web.Departamentos" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Gestión de Departamentos - PERFILES, S.A.</title>
    <link rel="stylesheet" type="text/css" href="Styles/Site.css" />
</head>
<body>
    <form id="formDepartamentos" runat="server">
        <div class="contenedor">
            <h1>Gestión de Departamentos</h1>

            <div class="panel-formulario">
                <h2>Nuevo / Editar Departamento</h2>

                <asp:HiddenField ID="hfIdDepartamento" runat="server" Value="0" />

                <div class="campo">
                    <label for="txtNombreDepartamento">Nombre del Departamento:</label>
                    <asp:TextBox ID="txtNombreDepartamento" runat="server" CssClass="input-texto" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvNombre" runat="server"
                        ControlToValidate="txtNombreDepartamento"
                        ErrorMessage="El nombre del departamento es obligatorio."
                        CssClass="mensaje-error"
                        Display="Dynamic" />
                </div>

                <div class="campo-acciones">
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="boton boton-primario" OnClick="btnGuardar_Click" />
                    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="boton boton-secundario" OnClick="btnLimpiar_Click" CausesValidation="false" />
                </div>

                <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje"></asp:Label>
            </div>

            <div class="panel-tabla">
                <h2>Departamentos Registrados</h2>

                <asp:GridView ID="gvDepartamentos" runat="server"
                    AutoGenerateColumns="false"
                    CssClass="tabla-datos"
                    DataKeyNames="IdDepartamento"
                    OnRowCommand="gvDepartamentos_RowCommand"
                    EmptyDataText="No hay departamentos registrados.">
                    <Columns>
                        <asp:BoundField DataField="IdDepartamento" HeaderText="ID" />
                        <asp:BoundField DataField="NombreDepartamento" HeaderText="Departamento" />
                        <asp:TemplateField HeaderText="Estado">
                            <ItemTemplate>
                                <span class='<%# (bool)Eval("Activo") ? "etiqueta-activo" : "etiqueta-inactivo" %>'>
                                    <%# (bool)Eval("Activo") ? "Activo" : "Inactivo" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEditar" runat="server"
                                     CommandName="Editar"
                                    CommandArgument='<%# Eval("IdDepartamento") %>'
                                    CssClass="enlace-accion"
                                    CausesValidation="false">Editar</asp:LinkButton>
                                |
                                <asp:LinkButton ID="lnkCambiarEstado" runat="server"
                                    CommandName="CambiarEstado"
                                    CommandArgument='<%# Eval("IdDepartamento") %>'
                                    CssClass="enlace-accion"
                                    CausesValidation="false"
                                    OnClientClick="return confirm('¿Confirma que desea cambiar el estado de este departamento? Si lo deshabilita, sus empleados pasarán a inactivos.');">
                                    <%# (bool)Eval("Activo") ? "Deshabilitar" : "Habilitar" %>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <p><a href="Empleados.aspx">Ir a Empleados</a> | <a href="Reportes.aspx">Ir a Reportes</a></p>
        </div>
    </form>
</body>
</html>