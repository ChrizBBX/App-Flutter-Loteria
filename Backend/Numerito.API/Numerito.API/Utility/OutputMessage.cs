﻿namespace LoteriaApp.WebApi.Utility
{
    public class OutputMessage
    {
        #region General
        public const string Error = "Ha ocurrido un error";
        #endregion
        #region Usuarios
        public const string SuccessDisableUsuario = "El usuario se ha desactivado exitosamente";
        public const string SuccessInsertUsuario = "El usuario se ha agregado exitosamente";
        public const string SuccessUpdateUsuario = "El usuario se ha editado exitosamente";
        public const string FaultEntityUsuario = "Hay campos vacios o la entidad es invalida";
        public const string FaultLogin = "El usuario o contraseña es incorrecto";
        public const string FaultUsuarioNotExists = "El Usuario seleccionado no existe";
        #endregion
        #region Personas
        public const string FaultPersonaNotExists = "La persona seleccionada no existe";
        #endregion
        #region Ventas
        public const string SuccessInsertVenta = "La venta de ha realizado exitosamente";
        #endregion
        #region Metodos de Pago
        public const string FaultMetodoPagoNotExists = "El metodo de pago no existe";
        #endregion
        #region Numeros
        public const string FaultNumeroNotExists = "El numero seleccionado no existe";
        public const string FaultNumeroLimit = "Limite del numero excedido";
        #endregion
        #region Sucursales
        public const string FaultSucursalNotExists = "La sucursal seleccionada no existe";
        #endregion
    }
}
