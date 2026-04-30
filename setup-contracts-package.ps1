# Script para configurar Dedo.Contracts como paquete NuGet
# Este script debe ejecutarse desde el directorio raíz del repositorio Dedo.Contracts

$ErrorActionPreference = "Stop"

Write-Host "📦 Configurando Dedo.Contracts como paquete NuGet" -ForegroundColor Cyan

# Definir la ruta del repositorio Contracts
$contractsPath = Read-Host "Ingresa la ruta completa del repositorio Dedo.Contracts (ejemplo: C:\Code\Dedo.Contracts)"

if (-not (Test-Path $contractsPath)) {
    Write-Host "❌ La ruta especificada no existe: $contractsPath" -ForegroundColor Red
    exit 1
}

Set-Location $contractsPath

# Verificar que existe el archivo .csproj
$csprojFile = Get-ChildItem -Filter "*.csproj" | Select-Object -First 1
if (-not $csprojFile) {
    Write-Host "❌ No se encontró archivo .csproj en: $contractsPath" -ForegroundColor Red
    exit 1
}

Write-Host "`n✅ Encontrado: $($csprojFile.Name)" -ForegroundColor Green

# Crear nuget.config
Write-Host "`n📝 Creando nuget.config..." -ForegroundColor Yellow
$nugetConfigContent = @"
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
    <add key="github" value="https://nuget.pkg.github.com/battistoniramiro/index.json" />
  </packageSources>
  <packageSourceCredentials>
    <github>
      <add key="Username" value="battistoniramiro" />
      <add key="ClearTextPassword" value="%GITHUB_TOKEN%" />
    </github>
  </packageSourceCredentials>
</configuration>
"@
Set-Content "nuget.config" $nugetConfigContent

# Crear directorio .github/workflows si no existe
if (-not (Test-Path ".github\workflows")) {
    New-Item -ItemType Directory -Path ".github\workflows" -Force | Out-Null
}

# Crear workflow de GitHub Actions
Write-Host "📝 Creando GitHub Actions workflow..." -ForegroundColor Yellow
$workflowContent = @"
name: Publish NuGet Package

on:
  push:
    branches: [ main, master ]
    tags:
      - 'v*'
  workflow_dispatch:

jobs:
  build-and-publish:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: Setup .NET
      uses: actions/setup-dotnet@v4
      with:
        dotnet-version: '8.0.x'

    - name: Restore dependencies
      run: dotnet restore

    - name: Build
      run: dotnet build --configuration Release --no-restore

    - name: Pack
      run: dotnet pack --configuration Release --no-build --output ./artifacts

    - name: Publish to GitHub Packages
      run: dotnet nuget push "./artifacts/*.nupkg" --source "https://nuget.pkg.github.com/battistoniramiro/index.json" --api-key `${{ secrets.GITHUB_TOKEN }} --skip-duplicate

    - name: Publish to NuGet.org (only on tags)
      if: startsWith(github.ref, 'refs/tags/v')
      run: dotnet nuget push "./artifacts/*.nupkg" --source "https://api.nuget.org/v3/index.json" --api-key `${{ secrets.NUGET_API_KEY }} --skip-duplicate
"@
Set-Content ".github\workflows\publish-nuget.yml" $workflowContent

# Actualizar .csproj con información de NuGet
Write-Host "📝 Actualizando $($csprojFile.Name)..." -ForegroundColor Yellow
[xml]$csproj = Get-Content $csprojFile.FullName

# Buscar o crear PropertyGroup para package metadata
$propertyGroup = $csproj.Project.PropertyGroup | Where-Object { $_.GeneratePackageOnBuild -or $_.PackageId }
if (-not $propertyGroup) {
    $propertyGroup = $csproj.CreateElement("PropertyGroup")
    $csproj.Project.AppendChild($propertyGroup) | Out-Null
}

# Función para agregar o actualizar elemento
function Set-PropertyElement($parent, $name, $value) {
    $element = $parent.SelectSingleNode($name)
    if (-not $element) {
        $element = $csproj.CreateElement($name)
        $parent.AppendChild($element) | Out-Null
    }
    $element.InnerText = $value
}

# Configurar propiedades de NuGet
Set-PropertyElement $propertyGroup "GeneratePackageOnBuild" "true"
Set-PropertyElement $propertyGroup "PackageId" "Dedo.Contracts"
Set-PropertyElement $propertyGroup "Version" "1.0.0"
Set-PropertyElement $propertyGroup "Authors" "DEDO Team"
Set-PropertyElement $propertyGroup "Company" "DEDO"
Set-PropertyElement $propertyGroup "Product" "Dedo.Contracts Library"
Set-PropertyElement $propertyGroup "Description" "Contratos y DTOs compartidos para microservicios DEDO"
Set-PropertyElement $propertyGroup "PackageTags" "dedo;contracts;dto;microservices;shared"
Set-PropertyElement $propertyGroup "RepositoryUrl" "https://github.com/battistoniramiro/Dedo.Contracts"
Set-PropertyElement $propertyGroup "RepositoryType" "git"
Set-PropertyElement $propertyGroup "PackageLicenseExpression" "MIT"
Set-PropertyElement $propertyGroup "PackageProjectUrl" "https://github.com/battistoniramiro/Dedo.Contracts"
Set-PropertyElement $propertyGroup "PublishRepositoryUrl" "true"

$csproj.Save($csprojFile.FullName)

# Crear script de publicación
Write-Host "📝 Creando script de publicación..." -ForegroundColor Yellow
$publishScriptContent = @"
# Script para publicar Dedo.Contracts a GitHub Packages
# Uso: .\publish-package.ps1 -Version "1.0.1" [-GitHubToken "tu_token"]

param(
    [Parameter(Mandatory=`$true)]
    [string]`$Version,

    [Parameter(Mandatory=`$false)]
    [string]`$GitHubToken = `$env:GITHUB_TOKEN,

    [Parameter(Mandatory=`$false)]
    [switch]`$SkipBuild
)

`$ErrorActionPreference = "Stop"

Write-Host "🚀 Publicando Dedo.Contracts v`$Version a GitHub Packages" -ForegroundColor Cyan

if ([string]::IsNullOrEmpty(`$GitHubToken)) {
    Write-Host "❌ Error: GitHub Token no configurado." -ForegroundColor Red
    Write-Host "Configura la variable de entorno GITHUB_TOKEN o pasa el parámetro -GitHubToken" -ForegroundColor Yellow
    exit 1
}

# Actualizar versión en .csproj
Write-Host "``n📝 Actualizando versión en .csproj..." -ForegroundColor Yellow
`$csprojFile = Get-ChildItem -Filter "*.csproj" | Select-Object -First 1
[xml]`$csproj = Get-Content `$csprojFile.FullName
`$versionNode = `$csproj.Project.PropertyGroup.Version
if (`$versionNode) {
    `$versionNode = `$Version
} else {
    `$propertyGroup = `$csproj.Project.PropertyGroup | Select-Object -First 1
    `$versionElement = `$csproj.CreateElement("Version")
    `$versionElement.InnerText = `$Version
    `$propertyGroup.AppendChild(`$versionElement) | Out-Null
}
`$csproj.Save(`$csprojFile.FullName)

# Limpiar artifacts
Write-Host "``n🧹 Limpiando artifacts..." -ForegroundColor Yellow
if (Test-Path ".\artifacts") {
    Remove-Item ".\artifacts" -Recurse -Force
}
New-Item -ItemType Directory -Path ".\artifacts" | Out-Null

if (-not `$SkipBuild) {
    Write-Host "``n📦 Restaurando dependencias..." -ForegroundColor Yellow
    dotnet restore
    if (`$LASTEXITCODE -ne 0) { exit `$LASTEXITCODE }

    Write-Host "``n🔨 Compilando proyecto..." -ForegroundColor Yellow
    dotnet build --configuration Release --no-restore
    if (`$LASTEXITCODE -ne 0) { exit `$LASTEXITCODE }
}

Write-Host "``n📦 Creando paquete NuGet..." -ForegroundColor Yellow
dotnet pack --configuration Release --output .\artifacts `$(if (`$SkipBuild) { "--no-build" } else { "" })
if (`$LASTEXITCODE -ne 0) { exit `$LASTEXITCODE }

Write-Host "``n🚀 Publicando a GitHub Packages..." -ForegroundColor Yellow
`$package = Get-ChildItem ".\artifacts\*.nupkg" | Select-Object -First 1
dotnet nuget push `$package.FullName ``
    --source "https://nuget.pkg.github.com/battistoniramiro/index.json" ``
    --api-key `$GitHubToken ``
    --skip-duplicate

if (`$LASTEXITCODE -eq 0) {
    Write-Host "``n✅ Paquete Dedo.Contracts v`$Version publicado exitosamente!" -ForegroundColor Green
} else {
    Write-Host "``n❌ Error al publicar el paquete" -ForegroundColor Red
    exit `$LASTEXITCODE
}
"@
Set-Content "publish-package.ps1" $publishScriptContent

Write-Host "`n✅ Configuración completada!" -ForegroundColor Green
Write-Host "`n📋 Próximos pasos:" -ForegroundColor Cyan
Write-Host "1. Revisa los cambios en los archivos" -ForegroundColor White
Write-Host "2. Ejecuta: git add ." -ForegroundColor White
Write-Host "3. Ejecuta: git commit -m 'Configure Dedo.Contracts as NuGet package'" -ForegroundColor White
Write-Host "4. Ejecuta: git push" -ForegroundColor White
Write-Host "`n💡 El paquete se publicará automáticamente después del push" -ForegroundColor Yellow

# Preguntar si quiere hacer commit y push ahora
$response = Read-Host "`n¿Deseas hacer commit y push ahora? (s/n)"
if ($response -eq 's' -or $response -eq 'S') {
    Write-Host "`n📤 Haciendo commit y push..." -ForegroundColor Yellow
    git add .
    git commit -m "Configure Dedo.Contracts as NuGet package for GitHub Packages"
    git push

    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n✅ ¡Listo! El workflow de GitHub Actions publicará el paquete." -ForegroundColor Green
        Write-Host "Verifica en: https://github.com/battistoniramiro/Dedo.Contracts/actions" -ForegroundColor Cyan
    }
}
"@
Set-Content "setup-contracts-package.ps1" $publishScriptContent
