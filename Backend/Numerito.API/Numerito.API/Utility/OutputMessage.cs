namespace LoteriaApp.WebApi.Utility
{
    public class OutputMessage
    {
        #region Usuarios
        public const string SuccessInsertUsuario = "El usuario se ha agregado exitosamente";
        public const string FaultEntityUsuario = "Hay campos vacios o la entidad es invalida";
        public const string FaultLogin = "El usuario o contraseña es incorrecto";
        public const string FaultUsuarioNotExists = "El Usuario seleccionado no existe";
        #endregion

        #region Personas
        public const string FaultPersonaNotExists = "La persona seleccionada no existe";
        #endregion
    }
}
