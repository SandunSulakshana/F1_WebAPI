using API.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddSingleton(serviceProvider =>
{
    var configuration = serviceProvider.GetRequiredService<IConfiguration>();
    var connectionString = configuration.GetConnectionString("DefaultConnection") ??
                            throw new ApplicationException("The connection string is null");
    return new SqlConnectionFactory(connectionString);
});

builder.Services.AddScoped<IUtilityServices, UtilityServices>();
var app = builder.Build();

// Enable CORS
app.UseCors(
    c => c.AllowAnyHeader()
    .AllowAnyOrigin()
    .AllowAnyMethod()
    );

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapControllers();

app.Run();
