<%@ Page Title="Empleados" Language="C#" AutoEventWireup="true" CodeBehind="Empleados.aspx.cs" Inherits="PerfilesSA.Web.Empleados" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Gestión de Empleados - PERFILES, S.A.</title>
    <link rel="stylesheet" type="text/css" href="Styles/Site.css" />
    <script type="text/javascript" src="Scripts/empleados.js"></script>
</head>
<body>
    <form id="formEmpleados" runat="server">
        <div class="contenedor">
            <h1>Gestión de Empleados</h1>

            <div class="panel-formulario">
                <h2>Nuevo / Editar Empleado</h2>

                <asp:HiddenField ID="hfIdEmpleado" runat="server" Value="0" />

                <div class="campo">
                    <label for="txtNombres">Nombres:</label>
                    <asp:TextBox ID="txtNombres" runat="server" CssClass="input-texto" MaxLength="150"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvNombres" runat="server"
                        ControlToValidate="txtNombres"
                        ErrorMessage="El nombre es obligatorio."
                        CssClass="mensaje-error" Display="Dynamic" />
                </div>

                <div class="campo">
                    <label for="txtDPI">DPI:</label>
                    <asp:TextBox ID="txtDPI" runat="server" CssClass="input-texto" MaxLength="13"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDPI" runat="server"
                        ControlToValidate="txtDPI"
                        ErrorMessage="El DPI es obligatorio."
                        CssClass="mensaje-error" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revDPI" runat="server"
                        ControlToValidate="txtDPI"
                        ValidationExpression="\d{13}"
                        ErrorMessage="El DPI debe tener exactamente 13 dígitos numéricos."
                        CssClass="mensaje-error" Display="Dynamic" />
                </div>

                <div class="campo">
                    <label for="txtFechaNacimiento">Fecha de Nacimiento:</label>
                    <asp:TextBox ID="txtFechaNacimiento" runat="server" CssClass="input-texto" TextMode="Date"
                        onchange="calcularEdadEnPantalla(this.value)"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvFechaNacimiento" runat="server"
                        ControlToValidate="txtFechaNacimiento"
                        ErrorMessage="La fecha de nacimiento es obligatoria."
                        CssClass="mensaje-error" Display="Dynamic" />
                    <span>Edad: <span id="spanEdadCalculada">--</span> años</span>
                </div>

                <div class="campo">
                    <label for="ddlSexo">Sexo:</label>
                    <asp:DropDownList ID="ddlSexo" runat="server" CssClass="input-select">
                        <asp:ListItem Text="-- Seleccione --" Value="" />
                        <asp:ListItem Text="Masculino" Value="M" />
                        <asp:ListItem Text="Femenino" Value="F" />
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvSexo" runat="server"
                        ControlToValidate="ddlSexo"
                        ErrorMessage="Debe seleccionar el sexo."
                        CssClass="mensaje-error" Display="Dynamic" />
                </div>

                <div class="campo">
                    <label for="txtFechaIngreso">Fecha de Ingreso:</label>
                    <asp:TextBox ID="txtFechaIngreso" runat="server" CssClass="input-texto" TextMode="Date"
                        onchange="calcularAntiguedadEnPantalla(this.value)"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvFechaIngreso" runat="server"
                        ControlToValidate="txtFechaIngreso"
                        ErrorMessage="La fecha de ingreso es obligatoria."
                        CssClass="mensaje-error" Display="Dynamic" />
                    <span>Antigüedad: <span id="spanAntiguedadCalculada">--</span> años</span>
                </div>

                <div class="campo">
                    <label for="txtDireccion">Dirección (opcional):</label>
                    <asp:TextBox ID="txtDireccion" runat="server" CssClass="input-texto" MaxLength="250"></asp:TextBox>
                </div>

                <div class="campo">
                    <label for="txtNIT">NIT (opcional):</label>
                    <asp:TextBox ID="txtNIT" runat="server" CssClass="input-texto" MaxLength="15"></asp:TextBox>
                </div>

                <div class="campo">
                    <label for="ddlDepartamento">Departamento:</label>
                    <asp:DropDownList ID="ddlDepartamento" runat="server" CssClass="input-select"
                        DataTextField="NombreDepartamento" DataValueField="IdDepartamento">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvDepartamento" runat="server"
                        ControlToValidate="ddlDepartamento"
                        ErrorMessage="Debe seleccionar un departamento."
                        CssClass="mensaje-error" Display="Dynamic"
                        InitialValue="" />
                </div>

                <div class="campo-acciones">
                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="boton boton-primario" OnClick="btnGuardar_Click" />
                    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="boton boton-secundario" OnClick="btnLimpiar_Click" CausesValidation="false" />
                </div>

                <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje"></asp:Label>
            </div>

            <div class="panel-tabla">
                <h2>Empleados Registrados</h2>

                <asp:GridView ID="gvEmpleados" runat="server"
                    AutoGenerateColumns="false"
                    CssClass="tabla-datos"
                    DataKeyNames="IdEmpleado"
                    OnRowCommand="gvEmpleados_RowCommand"
                    EmptyDataText="No hay empleados registrados.">
                    <Columns>
                        <asp:BoundField DataField="IdEmpleado" HeaderText="ID" />
                        <asp:BoundField DataField="Nombres" HeaderText="Nombres" />
                        <asp:BoundField DataField="DPI" HeaderText="DPI" />
                        <asp:BoundField DataField="Edad" HeaderText="Edad" />
                        <asp:BoundField DataField="AntiguedadAnios" HeaderText="Antigüedad (años)" />
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
                                
                             
                                <asp:LinkButton ID="LinkButton1" runat="server"
                                CommandName="Editar"
                                CommandArgument='<%# Eval("IdEmpleado") %>'
                                CssClass="enlace-accion"
                                CausesValidation="false">Editar</asp:LinkButton>
                            |
                            <asp:LinkButton ID="lnkCambiarEstado" runat="server"
                                CommandName="CambiarEstado"
                                CommandArgument='<%# Eval("IdEmpleado") %>'
                                CssClass="enlace-accion"
                                CausesValidation="false"
                                OnClientClick="return confirm('¿Confirma el cambio de estado de este empleado?');">
                                <%# (bool)Eval("Activo") ? "Inactivar" : "Activar" %>
                            </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <p><a href="Departamentos.aspx">Ir a Departamentos</a> | <a href="Reportes.aspx">Ir a Reportes</a></p>
        </div>
    </form>
</body>
</html>