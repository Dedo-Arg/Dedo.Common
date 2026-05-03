using Dedo.Contracts.Enums;
using Npgsql;

namespace Dedo.Common.Database;

public static class NpgsqlEnumSetup
{
    public static NpgsqlDataSource CreateDataSource(string connectionString)
    {
        var builder = new NpgsqlDataSourceBuilder(connectionString);
        RegisterEnums(builder);
        return builder.Build();
    }

    public static NpgsqlDataSourceBuilder RegisterEnums(
        NpgsqlDataSourceBuilder builder)
    {
        builder.MapEnum<UserRole>("user_role");
        builder.MapEnum<VerificationStatus>("verification_status");
        builder.MapEnum<PaymentStatus>("payment_status");
        builder.MapEnum<TokenStatus>("token_status");
        builder.MapEnum<OperationStatus>("operation_status");
        builder.MapEnum<BiometricMatchResult>("biometric_match_result");
        builder.MapEnum<AuditEventType>("audit_event_type");
        builder.MapEnum<NotificationChannel>("notification_channel");
        builder.MapEnum<RiskLevel>("risk_level");
        builder.MapEnum<FraudAction>("fraud_action");
        builder.MapEnum<FraudRuleType>("fraud_rule_type");

        return builder;
    }
}