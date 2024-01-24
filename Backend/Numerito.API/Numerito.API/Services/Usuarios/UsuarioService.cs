﻿using AutoMapper;
using FluentValidation;
using FluentValidation.Results;
using LoteriaApp.WebApi.Data.EntityContext;
using LoteriaApp.WebApi.Services.Usuarios.UsuarioDto;
using LoteriaApp.WebApi.Utility;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Any;
using Numerito.API.Data;
using Numerito.API.Data.Entities;
using Numerito.API.Services.Usuarios.UsuariosDto;
using Numerito.API.Utility;
using static Numerito.API.Data.Entities.Usuario;

namespace Numerito.API.Services.Usuarios
{
    public class UsuarioService
    {
        private readonly NumeritoContext _context;
        private readonly UsuarioRules _rules;
        private readonly IMapper _mapper;

        public UsuarioService(NumeritoContext loteriaContext, UsuarioRules rules, IMapper mapper)
        {
            _context = loteriaContext;
            _rules = rules;
            _mapper = mapper;
        }

        public Result<List<UsuarioDto>> Login(UsuarioDtoL entidad)
        {
            Encrypt encrypt = new Encrypt();
            var password = encrypt.HashPassword(entidad.Contrasena);

            var result = (from usuario in _context.Usuarios.AsQueryable()
                          where usuario.NombreUsuario == entidad.NombreUsuario && usuario.Contrasena == password
                          select new UsuarioDto
                          {
                              UsuarioId = usuario.UsuarioId,
                              NombreUsuario = usuario.NombreUsuario,
                              PersonaId = usuario.PersonaId,
                              Admin = usuario.Admin,
                          }
                          ).ToList();

            if (result.Count < 1)
                return Result<List<UsuarioDto>>.Fault(OutputMessage.FaultLogin);

            return Result<List<UsuarioDto>>.Success(result);
        }

        public Result<string> AgregarUsuarios(UsuarioDtoC entidad)
        {
            Encrypt encrypt = new Encrypt();
            var password = encrypt.HashPassword(entidad.Contrasena);

            Usuario usuario = new Usuario()
            {
                NombreUsuario = entidad.NombreUsuario,
                Contrasena = password,
                PersonaId = entidad.PersonaId,
                SucursalId = entidad.SucursalId,

                UsuarioCreacion = entidad.UsuarioCreacion,
                FechaCreacion = DateTime.Now,
                Admin = true
            };

            UsuarioValidations validator = new UsuarioValidations();
            validator.RuleFor(x => x.UsuarioCreacion).NotEmpty().WithMessage("Campo UsuarioCreacion Invalido");

            ValidationResult validationResult = validator.Validate(usuario);

            if (!validationResult.IsValid)
            {
                IEnumerable<string> Errors = validationResult.Errors.Select(s => s.ErrorMessage);
                string menssageValidation = string.Join(Environment.NewLine, Errors);
                return Result<string>.Fault(menssageValidation, OutputMessage.FaultEntityUsuario);
            }

           var listaUsuarios = _context.Usuarios.AsQueryable().Where(x => x.Estado == true).ToList();
           var listaPersonas = _context.Personas.AsQueryable().Where(x => x.Estado == true).ToList();
           var listaSucursales = _context.Sucursales.AsQueryable().Where(x => x.Estado == true).ToList();
           var validaciones = _rules.AgregarUsuarioValidaciones(usuario, listaPersonas,listaUsuarios,listaSucursales);

            if (!validaciones.Ok)
                return Result<string>.Fault(validaciones.Message);

            if (entidad.SucursalId == 0)
                usuario.SucursalId = null;

            _context.Add(usuario);
            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessInsertUsuario);
        }

        public Result<string> EditarUsuarios(UsuarioDto entidad)
        {
            Encrypt encrypt = new Encrypt();
            var password = encrypt.HashPassword(entidad.Contrasena);

            var usuario = _mapper.Map<Usuario>(entidad);

            UsuarioValidations validator = new UsuarioValidations();
            validator.RuleFor(x => x.UsuarioModificacion).NotEmpty().WithMessage("Campo UsuarioModificacion Invalido");

            ValidationResult validationResult = validator.Validate(usuario);

            if (!validationResult.IsValid)
            {
                IEnumerable<string> Errors = validationResult.Errors.Select(s => s.ErrorMessage);
                string menssageValidation = string.Join(Environment.NewLine, Errors);
                return Result<string>.Fault(menssageValidation, OutputMessage.FaultEntityUsuario);
            }

            var listaUsuarios = _context.Usuarios.AsQueryable().Where(x => x.Estado == true).ToList();
            var listaSucursales = _context.Sucursales.AsQueryable().Where(x => x.Estado == true).ToList();

            var validaciones = _rules.EditarUsuarioValidaciones(usuario,listaUsuarios,listaSucursales);
            if (!validaciones.Ok)
                return Result<string>.Fault(validaciones.Message);

            var original = listaUsuarios.FirstOrDefault(x => x.UsuarioId == usuario.UsuarioId);
            if (original == null) return Result<string>.Fault(OutputMessage.FaultUsuarioNotExists);

            original.NombreUsuario = usuario.NombreUsuario;
            original.Contrasena = password;
            original.PersonaId = usuario.PersonaId;
            original.SucursalId = usuario.SucursalId == 0 ? null : usuario.SucursalId;
            original.UsuarioModificacion = usuario.UsuarioModificacion;
            original.FechaModificacion = usuario.FechaModificacion;


                _context.Usuarios.Update(original);
                _context.SaveChanges();
            
            return Result<string>.Success(OutputMessage.SuccessUpdateUsuario);
        }

        public Result<string> DesactivarUsuarios(int usuarioId)
        {
            var listaUsuarios = _context.Usuarios.AsQueryable().ToList();
            var validaciones = _rules.DesactivarUsuarioValidaciones(listaUsuarios, usuarioId);

            if (!validaciones.Ok)
                return Result<string>.Fault(validaciones.Message);

            var usuario = listaUsuarios.FirstOrDefault(x => x.UsuarioId == usuarioId);
            if (usuario == null) return Result<string>.Fault(OutputMessage.FaultUsuarioNotExists);

            usuario.Estado = false;
            _context.Usuarios.Update(usuario);
            _context.SaveChanges();

            return Result<string>.Success(OutputMessage.SuccessDisableUsuario);
        }
    }
}
