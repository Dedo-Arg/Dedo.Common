using System.Text.RegularExpressions;
using Microsoft.EntityFrameworkCore;

namespace Dedo.Common.Database;

/// <summary>
/// DbContext base para todos los microservicios de DEDO.
/// Aplica snake_case automáticamente en tablas, columnas, claves e índices.
/// Cada microservicio hereda e implementa su propio Schema:
///   protected override string Schema => "user_service";
/// </summary>
public abstract class DedoDbContext : DbContext
{
    protected abstract string Schema { get; }

    protected DedoDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        modelBuilder.HasDefaultSchema(Schema);
        ApplySnakeCaseConvention(modelBuilder);
    }

    private static readonly Regex SnakeCaseRegex =
        new(@"([a-z0-9])([A-Z])", RegexOptions.Compiled);

    private static string ToSnakeCase(string name) =>
        SnakeCaseRegex.Replace(name, "$1_$2").ToLowerInvariant();

    private static void ApplySnakeCaseConvention(ModelBuilder modelBuilder)
    {
        foreach (var entity in modelBuilder.Model.GetEntityTypes())
        {
            var tableName = entity.GetTableName();
            if (tableName is not null)
                entity.SetTableName(ToSnakeCase(tableName));

            foreach (var prop in entity.GetProperties())
            {
                var col = prop.GetColumnName();
                if (col is not null)
                    prop.SetColumnName(ToSnakeCase(col));
            }

            foreach (var key in entity.GetKeys())
            {
                var keyName = key.GetName();
                if (keyName is not null)
                    key.SetName(ToSnakeCase(keyName));
            }

            foreach (var fk in entity.GetForeignKeys())
            {
                var fkName = fk.GetConstraintName();
                if (fkName is not null)
                    fk.SetConstraintName(ToSnakeCase(fkName));
            }

            foreach (var idx in entity.GetIndexes())
            {
                var idxName = idx.GetDatabaseName();
                if (idxName is not null)
                    idx.SetDatabaseName(ToSnakeCase(idxName));
            }
        }
    }
}