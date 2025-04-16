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

#### Parámetros disponibles

| Parámetro              | Descripción                                                                    |
|------------------------|--------------------------------------------------------------------------------|
| `-ProjectName`         | Nombre del nuevo proyecto en Azure DevOps                                      |
| `-SourceRepoName`      | Nombre del repositorio original (por ejemplo, en TFS)                          |
| `-SolutionFile`        | Archivo `.sln` principal del proyecto                                          |
| `-TemplateFilesPath`   | Ruta a los archivos base (`.gitignore`, `NuGet.Config`, `azure-pipelines.yml`) |
| `-RepoFilesPath`       | Ruta donde están los archivos del nuevo repositorio                            |
| `-OrganizationUrl`     | URL de tu organización en Azure DevOps (ejemplo: `https://dev.azure.com/acme`) |
| `-SonarToken`          | Token de autenticación para SonarQube                                          |
| `-SonarUrl`            | URL base de tu servidor SonarQube                                              |

## 📊 Resultado esperado

Después de ejecutar el script, obtendrás:

- Un **nuevo proyecto** creado en Azure DevOps.
- Un **repositorio Git** inicializado con los archivos base (como `.gitignore`, `NuGet.Config`, etc.).
- **Políticas de ramas** configuradas, como reglas de aprobación y estrategias de fusión.
- Un **pipeline YAML** listo para CI/CD que puedes usar para automatizar la construcción y despliegue de tu aplicación.
- Un **grupo de variables** en el pipeline configurado para las credenciales de despliegue.
- **Proyectos en SonarQube** creados para los distintos entornos (`PRO`, `PRE`, `DEV`), con las ramas correspondientes configuradas.
- Todo ello ya **pusheado** al repositorio en Azure DevOps, listo para comenzar a trabajar con tu equipo.

Esto crea una base sólida para tu proyecto, automatizando tanto la configuración del repositorio, las políticas de ramas, el pipeline de CI/CD y el análisis de calidad con SonarQube.


