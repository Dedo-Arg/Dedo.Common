# 📦 Dedo.Common - Configuración como Paquete NuGet

## ✅ Configuración Completada

Tu proyecto **Dedo.Common** ahora está configurado como un paquete NuGet que se publicará automáticamente en GitHub Packages.

### Archivos Creados/Modificados:

1. **Dedo.Common.csproj** - Actualizado con información correcta del repositorio
2. **nuget.config** - Configuración del feed de GitHub Packages
3. **.github/workflows/publish-nuget.yml** - Pipeline de CI/CD para publicación automática
4. **publish-package.ps1** - Script PowerShell para publicación manual
5. **NUGET_SETUP.md** - Documentación para consumidores del paquete

## 🚀 Próximos Pasos

### 1. Configurar GitHub Repository

Asegúrate de que tu repositorio en GitHub tenga:
- El nombre correcto: `battistoniramiro/Dedo.Common`
- Packages habilitado (se habilitará automáticamente al publicar)

### 2. Commit y Push

```bash
git add .
git commit -m "Configure Dedo.Common as NuGet package"
git push origin rbattistoni/main
```

Esto disparará automáticamente el workflow de GitHub Actions que publicará el paquete.

### 3. Verificar la Publicación

Después del push:
1. Ve a tu repositorio en GitHub
2. Ve a la pestaña "Actions" para ver el workflow corriendo
3. Una vez completado, ve a "Packages" en tu perfil de GitHub
4. Deberías ver `Dedo.Common` publicado

### 4. (Opcional) Publicación Manual

Si prefieres publicar manualmente:

```powershell
# Configura tu GitHub Token como variable de entorno
$env:GITHUB_TOKEN = "tu_personal_access_token"

# Ejecuta el script
.\publish-package.ps1 -Version "1.0.0"
```

### 5. Crear Personal Access Token

Para usar el paquete en otros proyectos, necesitarás un Personal Access Token (PAT):

1. Ve a: https://github.com/settings/tokens
2. Click en "Generate new token (classic)"
3. Selecciona los scopes:
   - ✅ `read:packages` (para descargar paquetes)
   - ✅ `write:packages` (para publicar paquetes)
4. Copia el token generado

### 6. Estructura Recomendada de Repositorios

Para tener ambos paquetes (Contracts y Common) accesibles desde un solo feed, te recomiendo:

#### Opción A: Mantener repositorios separados (Actual)
```
https://github.com/battistoniramiro/Dedo.Common
https://github.com/battistoniramiro/Dedo.Contracts
```

Ambos publicarán al mismo feed:
```
https://nuget.pkg.github.com/battistoniramiro/index.json
```

#### Opción B: Crear un mono-repositorio
```
Dedo.Packages/
├── src/
│   ├── Dedo.Common/
│   │   └── Dedo.Common.csproj
│   └── Dedo.Contracts/
│       └── Dedo.Contracts.csproj
├── .github/
│   └── workflows/
│       └── publish-nuget.yml
└── Dedo.Packages.sln
```

## 📖 Uso del Paquete en Otros Proyectos

### Configurar el feed (una sola vez):

```bash
dotnet nuget add source "https://nuget.pkg.github.com/battistoniramiro/index.json" \
  --name "github-battistoniramiro" \
  --username "TU_USUARIO_GITHUB" \
  --password "TU_GITHUB_PAT" \
  --store-password-in-clear-text
```

### Instalar el paquete:

```bash
dotnet add package Dedo.Common
dotnet add package Dedo.Contracts
```

## 🔄 Versionado y Nuevas Publicaciones

### Publicar una nueva versión:

1. Actualiza el `<Version>` en `Dedo.Common.csproj`:
   ```xml
   <Version>1.0.1</Version>
   ```

2. Commit y push:
   ```bash
   git add Dedo.Common.csproj
   git commit -m "Bump version to 1.0.1"
   git push
   ```

3. El paquete se publicará automáticamente

### Publicar también en NuGet.org:

Si quieres que tus paquetes estén en NuGet.org (público):

1. Crea un tag con la versión:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. Configura el secret `NUGET_API_KEY` en tu repositorio de GitHub:
   - Settings > Secrets and variables > Actions
   - New repository secret
   - Name: `NUGET_API_KEY`
   - Value: Tu API key de NuGet.org

## 🎯 Feed Único para Múltiples Paquetes

**Importante**: Tanto `Dedo.Common` como `Dedo.Contracts` estarán disponibles desde el mismo feed:

```
https://nuget.pkg.github.com/battistoniramiro/index.json
```

No necesitas agregar múltiples feeds. GitHub Packages organiza todos tus paquetes bajo tu usuario/organización.

## ❓ Troubleshooting

### Error 401 al descargar paquetes:
- Verifica que tu PAT tenga el scope `read:packages`
- Verifica que las credenciales estén configuradas correctamente

### Error 409 al publicar:
- El paquete con esa versión ya existe
- Incrementa la versión en el .csproj

### Workflow falla en GitHub Actions:
- Verifica que GITHUB_TOKEN tenga permisos (ya está configurado en el workflow)
- Revisa los logs en la pestaña Actions

## 📚 Recursos Adicionales

- Ver `NUGET_SETUP.md` para instrucciones detalladas de configuración
- Documentación de GitHub Packages: https://docs.github.com/en/packages
