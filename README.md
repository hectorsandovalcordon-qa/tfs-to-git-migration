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

```bash
git clone https://github.com/tu-org/bootstrap-azure-devops.git
cd bootstrap-azure-devops

### 2. Ejecuta el script

Puedes usar parámetros interactivos o editar el script para usar valores por defecto:

```powershell
./bootstrap.ps1

