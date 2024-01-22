using AutoMapper;
using LoteriaApp.WebApi.Services.Usuarios.UsuarioDto;
using Numerito.API.Data.Entities;

namespace Numerito.API.Data.MapProfile
{
    public class MapProfile : Profile
    {
        public MapProfile()
        {
            CreateMap<UsuarioDto, Usuario>().ReverseMap();
        }
    }
}
