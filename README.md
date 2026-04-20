# Dedo.Common

Librería común compartida entre microservicios del sistema DEDO.

## Características

- **Models**: Modelos base y DTOs compartidos
  - BaseEntity: Entidad base con Id, CreatedAt, UpdatedAt, IsDeleted
  - ApiResponse<T>: Modelo de respuesta API genérico

- **Exceptions**: Excepciones personalizadas
  - BusinessException: Excepción base de negocio
  - NotFoundException: Excepción para recursos no encontrados

- **Extensions**: Métodos de extensión útiles
  - StringExtensions: Extensiones para strings
  - ServiceCollectionExtensions: Extensiones para DI

- **Interfaces**: Contratos comunes
  - IRepository<T>: Interfaz de repositorio genérico
  - IUnitOfWork: Interfaz de Unit of Work

- **Constants**: Constantes compartidas
  - ApiConstants: Constantes de API
  - ErrorMessages: Mensajes de error

## Instalación

```bash
dotnet add package Dedo.Common
```

## Uso

```csharp
using Dedo.Common.Models;
using Dedo.Common.Exceptions;
using Dedo.Common.Extensions;

// Usar BaseEntity
public class Product : BaseEntity
{
    public string Name { get; set; }
    public decimal Price { get; set; }
}

// Usar ApiResponse
var response = new ApiResponse<Product>
{
    Success = true,
    Data = product,
    Message = "Producto obtenido exitosamente"
};

// Usar excepciones personalizadas
throw new NotFoundException("Product", productId);
```

## Versionamiento

Este proyecto utiliza [Semantic Versioning](https://semver.org/).

## Licencia

MIT
