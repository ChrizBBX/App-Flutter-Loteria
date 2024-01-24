using AutoMapper;
using FluentValidation.Results;
using LoteriaApp.WebApi.Data.EntityContext;
using LoteriaApp.WebApi.Utility;
using Microsoft.EntityFrameworkCore;
using Numerito.API.Data;
using Numerito.API.Data.Entities;
using Numerito.API.Services.Cierres.CierreDtos;
using Numerito.API.Utility;
using Numerito.API.Utitily.Scaffolding;
using static Numerito.API.Data.Entities.Venta;
using static Numerito.API.Utitily.Scaffolding.Cierre;

namespace Numerito.API.Services.Cierres
{
    public class CierreService
    {
        private readonly NumeritoContext _context;
        private readonly CierreRules _cierreRules;
        private readonly IMapper _mapper;

        public CierreService(NumeritoContext context, CierreRules cierreRules,IMapper mapper)
        {
            _context = context;
            _cierreRules = cierreRules;
            _mapper = mapper;
        }
        public Result<string> AgregarCierre(CierreDto entidad)
        {
            var cierre = _mapper.Map<Cierre>(entidad);
            CierreValidations validator = new CierreValidations();
            ValidationResult validationResult = validator.Validate(cierre);

            if (!validationResult.IsValid)
            {
                IEnumerable<string> Errors = validationResult.Errors.Select(s => s.ErrorMessage);
                string menssageValidation = string.Join(Environment.NewLine, Errors);
                return Result<string>.Fault(menssageValidation, OutputMessage.FaultEntityUsuario);
            }

            var listaCierres = _context.Cierres.AsQueryable().ToList();
            var listaUsuarios = _context.Usuarios.AsQueryable().ToList();
            var listaNumeros = _context.Numeros.AsQueryable().ToList();

            var validaciones = _cierreRules.AgregarCierreValidaciones(listaCierres, listaUsuarios, listaNumeros, cierre);
            if (!validaciones.Ok)
                return Result<string>.Fault(validaciones.Message);

            _context.Cierres.Add(cierre);
            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessInsertCierre);
        }
    }
}
