namespace Dedo.Common.Exceptions;

public class BusinessException : Exception
{
    public int StatusCode { get; set; }
    public List<string> Errors { get; set; } = new();

    public BusinessException(string message, int statusCode = 400) : base(message)
    {
        StatusCode = statusCode;
    }

    public BusinessException(string message, List<string> errors, int statusCode = 400) : base(message)
    {
        StatusCode = statusCode;
        Errors = errors;
    }
}

