# 🚀 Azure DevOps Project Bootstrapper

Este repositorio contiene un script de automatización en PowerShell para crear y configurar proyectos en **Azure DevOps** desde cero. Ideal para equipos que quieran estandarizar y acelerar el proceso de creación de nuevos repos.

## 🧰 ¿Qué hace este script?

`bootstrap.ps1` automatiza la configuración inicial de un proyecto en Azure DevOps. Incluye:

- 🔨 Creación del proyecto en Azure DevOps
- 📦 Configuración del repositorio principal
- 📁 Inclusión de archivos base (`.gitignore`, `NuGet.Config`, etc.)
- 🔒 Aplicación de políticas de ramas (ej: PRs obligatorios en `main`)
- ⚙️ Generación de un pipeline inicial (`azure-pipelines.yml`)
- 💾 Commit inicial + push automático

## 🚦 Requisitos

Antes de ejecutar el script, asegúrate de tener:

- PowerShell 7+
- Acceso a Azure DevOps (con permisos para crear proyectos/repositorios)
- Una **Personal Access Token (PAT)** válida para autenticarte

## 🧪 Cómo usarlo

### 1. Clona este repositorio

```bash```
git clone https://github.com/tu-org/bootstrap-azure-devops.git
cd bootstrap-azure-devops


Puedes usar parámetros interactivos o editar el script para usar valores por defecto:

```powershell
./bootstrap.ps1
```

O, si prefieres pasar los parámetros directamente:

```powershell
./bootstrap.ps1 -Organization "https://dev.azure.com/mi-organizacion" `
                -ProjectName "NuevoProyecto" `
                -RepositoryName "mi-repo" `
                -PersonalAccessToken "miPATseguro"
```

### 3. Parámetros disponibles

| Parámetro              | Descripción                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `-Organization`        | URL de tu organización en Azure DevOps (ej: `https://dev.azure.com/acme`)  |
| `-ProjectName`         | Nombre del nuevo proyecto a crear                                           |
| `-RepositoryName`      | Nombre del repositorio principal                                            |
| `-PersonalAccessToken` | Tu Personal Access Token para autenticarte en Azure DevOps                  |
| `-Visibility`          | (Opcional) Privacidad del proyecto: `private` o `public`                    |
| `-DefaultBranch`       | (Opcional) Rama principal (por defecto: `main`)                             |

### 4. Resultado esperado

Después de ejecutar el script, tendrás:

- Un proyecto nuevo en Azure DevOps
- Un repositorio Git inicializado con archivos base
- Políticas de ramas configuradas
- Un pipeline YAML listo para CI/CD
- Todo ello ya *pusheado* y listo para trabajar 💼

## 📝 Ejemplo de uso completo

```powershell
./bootstrap.ps1 -Organization "https://dev.azure.com/miempresa" `
                -ProjectName "InventarioAPI" `
                -RepositoryName "inventario" `
                -PersonalAccessToken "xyz1234abcTOKEN" `
                -Visibility "private"
```

## 🛟 Soporte

Este script está pensado como un punto de partida. Si necesitas soporte para configuraciones más avanzadas (múltiples repos, plantillas de pipelines, etc.), siéntete libre de abrir un *issue* o hacer un *fork*.

## 📄 Licencia

MIT © [Tu Nombre o Organización]
