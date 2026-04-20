# Configuración de NuGet Feed para paquetes DEDO

Este repositorio publica paquetes NuGet a GitHub Packages bajo el usuario `battistoniramiro`.

## Paquetes disponibles

Este feed incluye:
- **Dedo.Common** - Librería común compartida para microservicios DEDO
- **Dedo.Contracts** - Contratos y DTOs compartidos

## Configuración del Feed

### Opción 1: Usar nuget.config en tu proyecto

Copia el archivo `nuget.config` a la raíz de tu solución o crea uno con el siguiente contenido:

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
    <add key="github-dedo" value="https://nuget.pkg.github.com/battistoniramiro/index.json" />
  </packageSources>
  <packageSourceCredentials>
    <github-dedo>
      <add key="Username" value="TU_USUARIO_GITHUB" />
      <add key="ClearTextPassword" value="TU_GITHUB_TOKEN" />
    </github-dedo>
  </packageSourceCredentials>
</configuration>
```

### Opción 2: Configurar globalmente

En Windows, edita: `%AppData%\NuGet\NuGet.Config`

En Linux/Mac, edita: `~/.nuget/NuGet/NuGet.Config`

### Opción 3: Usar Visual Studio

1. Ir a **Tools > Options > NuGet Package Manager > Package Sources**
2. Agregar una nueva fuente:
   - **Name**: `GitHub DEDO Packages`
   - **Source**: `https://nuget.pkg.github.com/battistoniramiro/index.json`

### Autenticación

Para acceder a GitHub Packages necesitas un Personal Access Token (PAT) con permisos `read:packages`.

#### Crear un PAT:
1. Ve a GitHub Settings > Developer settings > Personal access tokens > Tokens (classic)
2. Generate new token
3. Selecciona el scope `read:packages` (y `write:packages` si vas a publicar)
4. Copia el token

#### Configurar credenciales:
```bash
dotnet nuget add source "https://nuget.pkg.github.com/battistoniramiro/index.json" \
  --name "github-dedo" \
  --username "TU_USUARIO" \
  --password "TU_PAT" \
  --store-password-in-clear-text
```

## Usar los paquetes

Una vez configurado el feed, puedes instalar los paquetes normalmente:

```bash
dotnet add package Dedo.Common
dotnet add package Dedo.Contracts
```

O desde Visual Studio usando el Package Manager.

## Publicación automática

Este repositorio está configurado con GitHub Actions para publicar automáticamente:
- A GitHub Packages en cada push a `main` o `rbattistoni/main`
- A NuGet.org cuando se crea un tag con formato `v*` (ejemplo: `v1.0.0`)

## Versionado

Para publicar una nueva versión:
1. Actualiza la versión en `Dedo.Common.csproj`
2. Commit y push los cambios
3. (Opcional) Crea un tag para publicar también en NuGet.org:
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```
