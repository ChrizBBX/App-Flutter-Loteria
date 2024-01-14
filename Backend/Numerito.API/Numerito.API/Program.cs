using Microsoft.EntityFrameworkCore;
using Numerito.API.Data;
using Numerito.API.Services.MetodosPagos;
using Numerito.API.Services.Personas;
using Numerito.API.Services.Usuarios;
using Numerito.API.Services.Ventas;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

var connectionString = builder.Configuration.GetConnectionString("ConexionProyecto");
builder.Services.AddDbContext<NumeritoContext>(options => options.UseSqlServer(connectionString));
builder.Services.AddTransient<UsuarioService>();
builder.Services.AddTransient<UsuarioRules>();
builder.Services.AddTransient<VentaService>();
builder.Services.AddTransient<VentaRules>();
builder.Services.AddTransient<MetodoPagoRules>();
builder.Services.AddTransient<PersonaRules>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
