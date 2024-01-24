using AutoMapper;
using LoteriaApp.WebApi.Services.Usuarios.UsuarioDto;
using Numerito.API.Data.Entities;
using Numerito.API.Services.Cierres.CierreDtos;
using Numerito.API.Utitily.Scaffolding;

namespace Numerito.API.Data.MapProfile
{
    public class MapProfile : Profile
    {
        public MapProfile()
        {
            CreateMap<UsuarioDto, Usuario>().ReverseMap();
            CreateMap<CierreDto, Cierre>().ReverseMap();
        }
    }
}
