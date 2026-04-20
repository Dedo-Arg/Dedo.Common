# Script para publicar Dedo.Common a GitHub Packages
# Uso: .\publish-package.ps1 -Version "1.0.1" [-GitHubToken "tu_token"]

param(
    [Parameter(Mandatory=$true)]
    [string]$Version,

    [Parameter(Mandatory=$false)]
    [string]$GitHubToken = $env:GITHUB_TOKEN,

    [Parameter(Mandatory=$false)]
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"

Write-Host "🚀 Publicando Dedo.Common v$Version a GitHub Packages" -ForegroundColor Cyan

# Verificar token
if ([string]::IsNullOrEmpty($GitHubToken)) {
    Write-Host "❌ Error: GitHub Token no configurado." -ForegroundColor Red
    Write-Host "Configura la variable de entorno GITHUB_TOKEN o pasa el parámetro -GitHubToken" -ForegroundColor Yellow
    exit 1
}

# Actualizar versión en .csproj
Write-Host "`n📝 Actualizando versión en .csproj..." -ForegroundColor Yellow
$csprojPath = "Dedo.Common.csproj"
$csproj = Get-Content $csprojPath -Raw
$csproj = $csproj -replace '<Version>.*?</Version>', "<Version>$Version</Version>"
Set-Content $csprojPath $csproj -NoNewline

# Limpiar artifacts anteriores
Write-Host "`n🧹 Limpiando artifacts anteriores..." -ForegroundColor Yellow
if (Test-Path ".\artifacts") {
    Remove-Item ".\artifacts" -Recurse -Force
}
New-Item -ItemType Directory -Path ".\artifacts" | Out-Null

# Restaurar dependencias
if (-not $SkipBuild) {
    Write-Host "`n📦 Restaurando dependencias..." -ForegroundColor Yellow
    dotnet restore
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    # Build
    Write-Host "`n🔨 Compilando proyecto..." -ForegroundColor Yellow
    dotnet build --configuration Release --no-restore
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

# Pack
Write-Host "`n📦 Creando paquete NuGet..." -ForegroundColor Yellow
dotnet pack --configuration Release --output .\artifacts $(if ($SkipBuild) { "--no-build" } else { "" })
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# Publish a GitHub Packages
Write-Host "`n🚀 Publicando a GitHub Packages..." -ForegroundColor Yellow
$package = Get-ChildItem ".\artifacts\*.nupkg" | Select-Object -First 1
dotnet nuget push $package.FullName `
    --source "https://nuget.pkg.github.com/battistoniramiro/index.json" `
    --api-key $GitHubToken `
    --skip-duplicate

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Paquete Dedo.Common v$Version publicado exitosamente!" -ForegroundColor Green
    Write-Host "`n📌 Para usar este paquete en otros proyectos:" -ForegroundColor Cyan
    Write-Host "   dotnet add package Dedo.Common --version $Version" -ForegroundColor White
    Write-Host "`n💡 Tip: No olvides hacer commit y push de los cambios de versión" -ForegroundColor Yellow
    Write-Host "   git add Dedo.Common.csproj" -ForegroundColor Gray
    Write-Host "   git commit -m 'Bump version to $Version'" -ForegroundColor Gray
    Write-Host "   git push" -ForegroundColor Gray
} else {
    Write-Host "`n❌ Error al publicar el paquete" -ForegroundColor Red
    exit $LASTEXITCODE
}
