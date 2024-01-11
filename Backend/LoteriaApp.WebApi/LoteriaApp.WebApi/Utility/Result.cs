using Microsoft.OpenApi.Any;

namespace LoteriaApp.WebApi.Utility
{
    public class Result<Type>
    {
        public bool Ok { get; set; }

        public string Code { get; set; }

        public string Message { get; set; }

        public Type Data { get; set; } = default(Type);
        public static Result<Type> Success()
        {
            return Success("");
        }

        public static Result<Type> Success(string Message)
        {
            return new Result<Type>
            {
                Ok = true,
                Message = Message
            };
        }

        public static Result<Type> Success<Type>(Type data)
        {
            return Success(data, "", "");
        }

        public static Result<Type> Success<AnyType>(Type data)
        {
            return Success(data);
        }

        public static Result<Type> Success<Type>(Type data, string Message, string codigo)
        {
            return Result<Type>.Success(data, Message, codigo);
        }

        public static Result<Type> Fault<Type>(string Message = "", string codigoError = "", Type data = default(Type))
        {
            return Result<Type>.Fault(Message, codigoError, data);
        }

        public static Result<Type> Success(Type data)
        {
            return Success(data, "");
        }

        public static Result<Type> Success(Type data, string Message, string Code = "")
        {
            return new Result<Type>
            {
                Ok = true,
                Message = Message,
                Data = data,
                Code = Code
            };
        }

        public static Result<string> Fault(string Message, string CodeError)
        {
            return new Result<string>
            {
                Ok = false,
                Message = Message,
                Code = CodeError
            };
        }

        public static Result<Type> Fault(string Message = "", string CodeError = "", Type data = default(Type))
        {
            return new Result<Type>
            {
                Ok = false,
                Message = Message,
                Code = CodeError,
                Data = data
            };
        }

    }
}

