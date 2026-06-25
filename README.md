# PerfilesSA — Sistema de Control Administrativo de Empleados

Prueba técnica para **Developer** en PRECREDIT (bajo SSASA), para el cliente **PERFILES, S.A.**

Sistema de control administrativo de empleados por departamento, desarrollado en **C# .NET Framework 4.8** siguiendo los requerimientos del cliente: sin ORM (ADO.NET puro con Stored Procedures), ASP.NET Web Forms (no MVC), y un servicio web SOAP como capa de backend.

---

## Tecnologías utilizadas

| Capa | Tecnología |
|---|---|
| Frontend | ASP.NET Web Forms (.NET Framework 4.8) |
| Backend / Servicio Web | WCF (Windows Communication Foundation) — SOAP |
| Acceso a datos | ADO.NET puro (sin ORM) |
| Base de datos | SQL Server — Stored Procedures |
| Lenguaje | C# |
| Estilos | CSS personalizado + Bootstrap |

---

## Estructura del proyecto

```
PerfilesSA/
│
├── PerfilesSA.Entidades/      → Clases del modelo (Persona, Empleado, Departamento, RespuestaServicio)
├── PerfilesSA.DAL/            → Acceso a datos con ADO.NET puro (llama a los Stored Procedures)
├── PerfilesSA.Contratos/      → Interfaces del servicio WCF ([ServiceContract] / [OperationContract])
├── PerfilesSA.ServicioWeb/    → Implementación del servicio WCF (SOAP)
├── PerfilesSA.Web/            → Frontend en ASP.NET Web Forms (consume el servicio WCF)
├── Database/                  → Scripts SQL (tablas y stored procedures)
│   ├── 01_Tablas.sql
│   ├── 02_SP_Departamento.sql
│   ├── 03_SP_Empleado.sql
│   └── Script_Completo.sql    → Los tres anteriores unidos, listo para ejecutar de un solo paso
│
└── PerfilesSA.slnx            → Archivo de solución de Visual Studio
```

---

## Instrucciones de instalación

### Requisitos previos
- Visual Studio 2022 o superior, con el workload **"Desarrollo web y ASP.NET"** instalado
- Componente individual **"Windows Communication Foundation"** (Visual Studio Installer → Componentes individuales)
- SQL Server (local o remoto) y SQL Server Management Studio (SSMS)

### Paso 1: Clonar el repositorio
```bash
git clone https://github.com/DanielLorente21/PerfilesSA.git
```

### Paso 2: Crear la base de datos
1. Abre SSMS y conéctate a tu instancia de SQL Server
2. Abre el archivo `Database/Script_Completo.sql`
3. Ejecútalo completo (esto crea la base de datos `PerfilesSA_DB`, las tablas, índices y los 11 Stored Procedures)

### Paso 3: Configurar el connection string
En **dos** archivos `Web.config` (uno en `PerfilesSA.ServicioWeb`, otro en `PerfilesSA.Web`) verifica que la cadena de conexión apunte a tu servidor SQL, por ejemplo:
```xml
<connectionStrings>
  <add name="PerfilesSA_DB" connectionString="Data Source=localhost;Initial Catalog=PerfilesSA_DB;Integrated Security=True" providerName="System.Data.SqlClient" />
</connectionStrings>
```

### Paso 4: Abrir la solución y restaurar paquetes
1. Abre `PerfilesSA.slnx` en Visual Studio
2. Click derecho en la solución → **"Restaurar paquetes NuGet"**
3. Compila la solución completa (**Compilación → Recompilar solución**) y confirma 0 errores

### Paso 5: Ejecutar el servicio web (WCF)
1. Click derecho en el proyecto `PerfilesSA.ServicioWeb` → **"Establecer como proyecto de inicio"**
2. Ejecuta (F5) — debería abrir el navegador mostrando la página de prueba del servicio WCF
3. Anota el puerto que asigna (ej. `http://localhost:PUERTO`)

### Paso 6: Ejecutar el sitio web (Web Forms)
1. Si las referencias de servicio (`Connected Services`) apuntan a un puerto distinto al actual, actualízalas: click derecho sobre cada referencia de servicio dentro de `PerfilesSA.Web` → **"Actualizar referencia de servicio"**
2. Click derecho en el proyecto `PerfilesSA.Web` → **"Establecer como proyecto de inicio"**
3. Ejecuta (F5)

> **Nota:** los puertos de IIS Express pueden variar entre máquinas. Si el sitio no logra conectarse al servicio web, lo primero a revisar es que la URL del servicio en las referencias coincida con el puerto real en el que está corriendo `PerfilesSA.ServicioWeb`.

---

## Decisiones técnicas

### ¿Por qué WCF/SOAP y no una Web API REST?
El requerimiento pedía explícitamente un servicio web como capa de backend, dentro de un ecosistema **ASP.NET Web Forms clásico** sobre **.NET Framework**. WCF es la tecnología nativa de ese ecosistema: se integra de forma directa con Web Forms mediante "Connected Services", soporta contratos fuertemente tipados con `[ServiceContract]`/`[OperationContract]`, y es el estándar que un sistema de esa época/stack usaría de forma natural. Una Web API REST habría sido una opción más moderna, pero menos alineada con el resto de restricciones del proyecto (Web Forms, no MVC, no ORM).

### ¿Por qué ADO.NET puro en vez de un ORM (Entity Framework, Dapper, etc.)?
Fue una restricción explícita del requerimiento. Sin ORM, todo el acceso a datos pasa por **Stored Procedures**, lo cual:
- Centraliza la lógica de validación de negocio crítica (unicidad de DPI, nombre de departamento, existencia de FK) en la base de datos
- Da control total sobre el SQL ejecutado, sin overhead de un mapeador
- Es un patrón muy común en sistemas administrativos/financieros heredados, que es justo el tipo de sistema que un cliente como PERFILES, S.A. probablemente mantiene

### Separación en capas (Entidades / DAL / Contratos / ServicioWeb / Web)
Se aplicó una arquitectura en capas clásica:
- **Entidades**: solo datos, sin lógica de acceso — se reutilizan tanto en el servidor (DAL, ServicioWeb) como en el cliente (Web), evitando duplicar clases
- **DAL**: única capa que toca ADO.NET y los Stored Procedures — si cambiara el motor de base de datos, solo esta capa se modificaría
- **Contratos**: interfaces que definen el "qué" del servicio, independientes del "cómo" se implementa
- **ServicioWeb**: implementación real del contrato, hace de puente entre el mundo WCF y el DAL
- **Web**: capa de presentación, no conoce el DAL directamente — todo pasa por el servicio web

Esto sigue el principio de **responsabilidad única (S de SOLID)**: cada proyecto tiene una sola razón para cambiar.

### Herencia y polimorfismo: `Persona` → `Empleado`
`Persona` es una clase base abstracta con los datos comunes a cualquier persona (Nombres, DPI, FechaNacimiento, Sexo) y un método `CalcularEdad()` y `EsValido()` marcados como `virtual`. `Empleado` hereda de `Persona` y añade los datos propios de un empleado (FechaIngreso, Departamento, etc.), sobrescribiendo `EsValido()` con `override` para agregar sus propias reglas de validación además de las heredadas.

Esto aplica el principio de **sustitución de Liskov (L de SOLID)**: en cualquier lugar donde se espere un `Persona`, un `Empleado` puede usarse sin romper el comportamiento esperado. También deja la puerta abierta a futuras clases (ej. `Cliente`, `Proveedor`) que reutilicen la misma base sin duplicar código.

### ¿Por qué la edad y la antigüedad se calculan al vuelo y no se guardan en una columna?
Guardar la edad o los años de antigüedad como un valor fijo en la base de datos los volvería datos **obsoletos al día siguiente** — la edad de una persona cambia cada año automáticamente, no por una acción del usuario. Calcularlos con `DATEDIFF`/`DATEADD` directamente en el Stored Procedure, en el momento de la consulta, garantiza que el dato mostrado siempre es exacto, sin necesidad de procesos batch que actualicen esas columnas periódicamente. La fórmula además ajusta correctamente el caso en que el cumpleaños/aniversario de este año todavía no ha ocurrido, evitando el error común de sumar un año de más.

### ¿Cómo funciona la cascada de inactivación de empleados?
Es el requisito de negocio más sensible del sistema: al deshabilitar un departamento, todos sus empleados deben quedar inactivos automáticamente, sin que el usuario tenga que hacerlo manualmente uno por uno.

El Stored Procedure `SP_Departamento_CambiarEstado` envuelve la operación en una **transacción** (`BEGIN TRANSACTION` / `COMMIT` / `ROLLBACK`): primero actualiza el estado del departamento, y si el nuevo estado es inactivo, en la misma transacción actualiza también a `Activo = 0` todos los empleados de ese departamento. Si cualquier paso falla, el `ROLLBACK` en el bloque `CATCH` revierte todo el conjunto, evitando que el departamento quede inactivo con empleados que siguieron activos (una inconsistencia de datos grave en un sistema administrativo real).

### Validaciones en capas
Las validaciones no viven en un solo lugar, sino que se refuerzan en cada capa:
- **JavaScript** en el navegador (cálculo de edad/antigüedad en tiempo real, primera línea de defensa para UX)
- **Validadores de ASP.NET** (`RequiredFieldValidator`, `RegularExpressionValidator` para el formato de DPI) antes de enviar el postback
- **Stored Procedures** como última línea de defensa (unicidad de DPI/nombre, existencia de departamento activo) — porque el servidor nunca debe confiar ciegamente en lo que validó el cliente

