using RandomNumberApp.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

// ASP.NET WEB API: DEPENDENCY INJECTION 
// SINGLETON: A single instance of the service is created and shared throughout the application lifetime
// SCOPED: A new instance is created for each request
// TRANSIENT: A new instance is created every time it's needed.

// Select one of the following lifetimes for the RandomNumberService:

//builder.Services.AddSingleton<IRandomNumberService, RandomNumberService>();
//builder.Services.AddScoped<IRandomNumberService, RandomNumberService>();
builder.Services.AddTransient<IRandomNumberService, RandomNumberService>();

// Use Postman or any other API testing tool to test the API endpoint: https://localhost:7126/api/RandomNumber

builder.Services.AddControllers();
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
