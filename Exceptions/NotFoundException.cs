namespace Dedo.Common.Exceptions;

public class NotFoundException : BusinessException
{
    public NotFoundException(string message) : base(message, 404)
    {
    }

    public NotFoundException(string entityName, object key) 
        : base($"{entityName} con ID '{key}' no fue encontrado.", 404)
    {
    }
}

