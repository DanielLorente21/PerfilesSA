using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;

namespace PerfilesSA.Web
{
    public class Global : HttpApplication
    {
       
    
void Application_Start(object sender, EventArgs e)
        {
            // Código que se ejecuta al iniciar la aplicación.
            System.Web.UI.ScriptManager.ScriptResourceMapping.AddDefinition("jquery", new System.Web.UI.ScriptResourceDefinition
            {
                Path = "https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.7.1.min.js",
                DebugPath = "https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.7.1.js"
            });
        }
    }
}