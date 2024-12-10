
//using ES.Labs.Api;
//using ES.Labs.Api.Security;
//using ES.Labs.Domain;
//using ES.Labs.Domain.Projections;
//using EventStore.Client;
using BotoGP.Api.Hubs;
using BotoGP.Domain.Repositories;
using BotoGP.Domain.Services;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
var services = builder.Services;

//services.AddEventStoreClient(_ => EventStoreClientSettings
//    .Create(builder.Configuration.GetConnectionString("EVENTSTORE")));

services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
services.AddEndpointsApiExplorer();
services.AddSwaggerGen();

services.AddSignalR();

services.AddSingleton<ICircuitRepository, CircuitRepository>();

//services.AddCustomAuthorization();

services.AddCors(options => options.AddPolicy("AllowAll", builder =>
{
    builder.AllowAnyMethod()
        .AllowAnyHeader()
        .AllowCredentials()
        .WithOrigins(
            "http://localhost:3000",
            "http://localhost:5000",
            "http://localhost:5173",
            "http://localhost:4173",

            "http://localhost:6000",
            "https://localhost:6001",

            "http://localhost:7000",
            "https://localhost:7001");
}));

services.AddHttpClient();

//services.AddSingleton<IEventMetadataInfo, AppVersionInfo>();
//services.AddScoped<EventDataBuilder>();

//services.AddStackExchangeRedisCache(options =>
//{
//    options.Configuration = builder.Configuration.GetConnectionString("REDIS");
//    options.InstanceName = "ESDemo-";
//});

// services.AddHostedService<ConsumerHostedService>();

var app = builder.Build();

app.MapGet("/api/circuits/catalog", static async (ICircuitRepository repository) => {

    var data = await repository.ReadAllAsync();

    return Results.Ok(data.Select(x => new {
        x.Name,
        x.Id
    }));
});


app.MapGet("/api/circuits/{id}/svg", static async (ICircuitRepository repository, [FromRoute] string id, [FromQuery] int scale = 1) => {

    string path = "";
    var c = await repository.ReadAsync(id);
    if (c != null)
    {
        path = "M" + string.Join(" L", c.Map.CheckPoints.Select(p => $"{p.x * scale},{p.y * scale}")) + " z";
    }

    var data = $@"<?xml version=""1.0"" encoding=""UTF-8"" standalone=""no""?>
<!DOCTYPE svg PUBLIC ""-//W3C//DTD SVG 1.1//EN"" ""http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"">
<svg xmlns=""http://www.w3.org/2000/svg"" width=""{150 * scale}px"" height=""{100 * scale}px"" viewBox=""0 0 {150 * scale} {100 * scale}"" preserveAspectRatio=""xMidYMid meet"">
    <title>Circuit</title>
    <g id=""main"">
        <path stroke=""#666666"" stroke-linecap=""round"" stroke-linejoin=""round"" stroke-width=""{20 * scale}"" fill=""transparent"" d=""{path}"" />
        <path stroke=""#cccccc"" stroke-linecap=""round"" stroke-linejoin=""round"" stroke-width=""{15 * scale}"" fill=""transparent"" d=""{path}"" />
    </g>
</svg>";
    return Results.File(System.Text.Encoding.UTF8.GetBytes(data), "image/svg+xml");
});

//app.MapGet("/appInfo", ([FromServices] AppVersionInfo appInfo) => Results.Ok(appInfo))
//    .RequireAuthorization(policyBuilder =>
//    {
//        policyBuilder.AddRequirements(new HasPermissionRequirement(Permissions.PlaceOrder));
//    })
//    .RequireAuthorization(Policies.OnlyEvenSeconds);

//app.MapGet("/me", () => Results.Ok(DateTime.Now)).RequireAuthorization(Policies.MustHaveSession);

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.UseWebSockets();

app.UseStaticFiles();

//app.MapControllers();
app.UseEndpoints(endpoints =>
{
    endpoints.MapControllers();

    endpoints.MapHub<RaceHub>("/race");
});

app.Run();