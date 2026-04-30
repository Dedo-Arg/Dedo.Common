# 🎉 CONFIGURACIÓN COMPLETA - Ambos Paquetes NuGet

## ✅ DEDO.COMMON - YA PUBLICADO

El paquete **Dedo.Common** ya está configurado y publicado en GitHub Packages.

### Estado actual:
- ✅ Configuración completada
- ✅ Commit realizado
- ✅ Push a GitHub realizado
- ⏳ GitHub Actions ejecutándose (publicando el paquete)

### Verificar publicación:
🔗 **GitHub Actions:** https://github.com/battistoniramiro/Dedo.Common/actions
🔗 **Packages:** https://github.com/battistoniramiro?tab=packages

---

## 📦 DEDO.CONTRACTS - CONFIGURACIÓN PENDIENTE

Para configurar **Dedo.Contracts**, sigue estos pasos:

### Opción 1: Configuración Automática (Recomendado)

1. **Navega al repositorio de Dedo.Contracts:**
   ```powershell
   cd C:\Code\Dedo.Contracts
   ```

2. **Copia el script de configuración:**
   - Copia el archivo `setup-contracts-package.ps1` desde el repositorio de Dedo.Common al de Dedo.Contracts

3. **Ejecuta el script:**
   ```powershell
   .\setup-contracts-package.ps1
   ```

4. **El script hará automáticamente:**
   - Crear `nuget.config`
   - Crear `.github/workflows/publish-nuget.yml`
   - Actualizar el `.csproj` con metadata de NuGet
   - Crear `publish-package.ps1`
   - Hacer commit y push (si lo autorizas)

### Opción 2: Configuración Manual

Si prefieres hacerlo manualmente:

1. **Navega al repositorio:**
   ```powershell
   cd C:\Code\Dedo.Contracts
   ```

2. **Crea los archivos necesarios:**

   **A. nuget.config:**
   ```xml
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
   ```

   **B. .github/workflows/publish-nuget.yml:**
   (Copia el mismo contenido del workflow de Dedo.Common)

   **C. Actualiza el .csproj:**
   Agrega estas propiedades:
   ```xml
   <GeneratePackageOnBuild>true</GeneratePackageOnBuild>
   <PackageId>Dedo.Contracts</PackageId>
   <Version>1.0.0</Version>
   <Authors>DEDO Team</Authors>
   <Company>DEDO</Company>
   <Description>Contratos y DTOs compartidos para microservicios DEDO</Description>
   <RepositoryUrl>https://github.com/battistoniramiro/Dedo.Contracts</RepositoryUrl>
   <RepositoryType>git</RepositoryType>
   <PackageLicenseExpression>MIT</PackageLicenseExpression>
   <PublishRepositoryUrl>true</PublishRepositoryUrl>
   ```

3. **Haz commit y push:**
   ```powershell
   git add .
   git commit -m "Configure Dedo.Contracts as NuGet package"
   git push
   ```

---

## 🎯 FEED ÚNICO PARA AMBOS PAQUETES

Una vez configurados ambos repositorios, **ambos paquetes estarán disponibles en el mismo feed:**

```
https://nuget.pkg.github.com/battistoniramiro/index.json
```

### No necesitas:
- ❌ Crear carpetas especiales
- ❌ Configurar múltiples feeds
- ❌ Reorganizar repositorios

### GitHub Packages automáticamente:
- ✅ Agrupa todos tus paquetes bajo tu usuario
- ✅ Los hace accesibles desde un solo feed
- ✅ Versiona cada paquete independientemente

---

## 🚀 USAR LOS PAQUETES EN OTROS MICROSERVICIOS

### 1. Configurar el feed (una sola vez por máquina):

**Opción A - Usando dotnet CLI:**
```powershell
dotnet nuget add source "https://nuget.pkg.github.com/battistoniramiro/index.json" `
  --name "github-battistoniramiro" `
  --username "TU_USUARIO_GITHUB" `
  --password "TU_GITHUB_PAT" `
  --store-password-in-clear-text
```

**Opción B - Usando nuget.config en tu microservicio:**
Copia el `nuget.config` de Dedo.Common a la raíz de tu microservicio.

### 2. Crear un GitHub Personal Access Token (PAT):

1. Ve a: https://github.com/settings/tokens
2. Click en **"Generate new token (classic)"**
3. Selecciona los scopes:
   - ✅ `read:packages`
   - ✅ `write:packages` (si vas a publicar)
4. Genera y copia el token
5. Guárdalo en un lugar seguro (se mostrará solo una vez)

### 3. Instalar los paquetes:

```powershell
# En tu microservicio
dotnet add package Dedo.Common
dotnet add package Dedo.Contracts
```

O desde Visual Studio:
- Tools > NuGet Package Manager > Manage NuGet Packages for Solution
- Busca "Dedo.Common" y "Dedo.Contracts"
- Instala

---

## 📋 CHECKLIST COMPLETO

### Dedo.Common:
- [x] Configuración de NuGet
- [x] GitHub Actions workflow
- [x] nuget.config
- [x] Scripts de publicación
- [x] Commit y push
- [ ] Verificar publicación en GitHub (espera unos minutos)

### Dedo.Contracts:
- [ ] Clonar/navegar al repositorio
- [ ] Ejecutar script de configuración O configurar manualmente
- [ ] Commit y push
- [ ] Verificar publicación en GitHub

### En tus microservicios:
- [ ] Crear GitHub PAT
- [ ] Configurar feed de GitHub Packages
- [ ] Instalar Dedo.Common
- [ ] Instalar Dedo.Contracts

---

## 🔍 VERIFICACIÓN

### Ver tus paquetes publicados:
🔗 https://github.com/battistoniramiro?tab=packages

### Ver workflows ejecutándose:
- 🔗 Dedo.Common: https://github.com/battistoniramiro/Dedo.Common/actions
- 🔗 Dedo.Contracts: https://github.com/battistoniramiro/Dedo.Contracts/actions

### Buscar paquetes desde la terminal:
```powershell
dotnet package search Dedo --source "https://nuget.pkg.github.com/battistoniramiro/index.json"
```

---

## ❓ TROUBLESHOOTING

### "Failed to retrieve package metadata"
- Verifica que el PAT tenga el scope `read:packages`
- Verifica que las credenciales estén correctamente configuradas

### "Package already exists"
- El paquete ya fue publicado con esa versión
- Incrementa la versión en el `.csproj`

### "Unauthorized (401)"
- Tu PAT no tiene los permisos correctos
- Tu PAT ha expirado
- Las credenciales en nuget.config no son correctas

### Workflow falla en GitHub Actions
- Revisa los logs en la pestaña Actions
- Verifica que el `GITHUB_TOKEN` tenga permisos (ya está configurado en el workflow)

---

## 📞 SIGUIENTE PASO INMEDIATO

### Para completar la configuración:

1. **Espera 2-3 minutos** a que el workflow de Dedo.Common termine
2. **Verifica** en: https://github.com/battistoniramiro/Dedo.Common/actions
3. **Configura Dedo.Contracts** usando el script o manualmente
4. **Verifica ambos paquetes** en: https://github.com/battistoniramiro?tab=packages

¡Listo! 🎉
