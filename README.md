# 🚀 Automatización de Migración de TFS a Git para Proyectos de Azure DevOps

Este repositorio contiene un script de automatización en PowerShell para crear y configurar proyectos en **Azure DevOps** desde cero. Ideal para equipos que quieran estandarizar y acelerar el proceso de creación de nuevos repos.

## 🧰 ¿Qué hace este script?

`script_automation.ps1` automatiza la configuración inicial de un proyecto en Azure DevOps. Incluye:

- 🔨 Creación del proyecto en Azure DevOps
- 📦 Configuración del repositorio principal
- 📁 Inclusión de archivos base (`.gitignore`, `NuGet.Config`, etc.)
- 🔒 Aplicación de políticas de ramas (ej: PRs obligatorios en `main`)
- ⚙️ Generación de un pipeline inicial (`azure-pipelines.yml`)
- 💾 Commit inicial + push automático

## 📁 Estructura del repositorio

```bash
bootstrap-azure-devops/
│
├── script_automation.ps1     # Script principal de automatización
├── azure-pipelines.yml       # Pipeline base para CI/CD
├── .gitignore                # Archivos que no se deben incluir en Git
├── NuGet.Config              # Configuración para fuentes de paquetes NuGet
├── README.md                 # Este archivo con documentación
└── resources/                # Archivos auxiliares, plantillas y configuraciones adicionales
    ├── branch-policies.json  # Políticas de rama para aplicar automáticamente
    └── templates/            # Plantillas opcionales para pipelines, repos, etc.
```

> 💡 Puedes modificar esta estructura según las necesidades de tu organización.


## 🚦 Requisitos

Antes de ejecutar el script, asegúrate de tener:

- PowerShell 7+
- Acceso a Azure DevOps (con permisos para crear proyectos/repositorios)
- Una **Personal Access Token (PAT)** válida para autenticarte

## 🧪 Cómo usarlo

### 1. Clona este repositorio

```bash
git clone https://github.com/tu-org/tfs-to-git-migration.git
cd tfs-to-git-migration
```

### 2. Ejecuta el script

#### ✅ Opción 1: Ejecutar con valores por defecto

```powershell

Si ya has configurado los valores por defecto dentro del script, simplemente ejecútalo así:

./script_automation.ps1
```

#### 🛠️ Opción 2: Ejecutar pasando parámetros manualmente

```powershell

./script_automation.ps1 `
    -ProjectName "ERP" `
    -SourceRepoName "ERP.Web.OLD" `
    -SolutionFile "ERP.sln" `
    -TemplateFilesPath "C:\Plantillas" `
    -RepoFilesPath "C:\Projects\ERP\ERP.Web" `
    -OrganizationUrl "https://dev.azure.com/mi-org" `
    -SonarToken "squ_abc123456789" `
    -SonarUrl "https://sonarqube.miempresa.com"
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

## 🛟 Soporte

Este script está pensado como un punto de partida. Si necesitas soporte para configuraciones más avanzadas (múltiples repos, plantillas de pipelines, etc.), siéntete libre de abrir un *issue* o hacer un *fork*.

## 📄 Licencia

MIT © Héctor Sandoval Cordón
