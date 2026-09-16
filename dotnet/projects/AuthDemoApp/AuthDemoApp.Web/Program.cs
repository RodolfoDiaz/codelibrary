using AuthDemoApp.Core.Services;
using Microsoft.AspNetCore.Authentication.Cookies;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllersWithViews();

builder.Services.AddSingleton<IPasswordHasher, PasswordHasher>();

// Read password from environment variable
var dbPassword = Environment.GetEnvironmentVariable("USER_SECRET_KEY")
    ?? throw new InvalidOperationException("Environment variable 'USER_SECRET_KEY' is not set.");

// Retrieve base connection string template from appsettings.json
var connectionStringTemplate = builder.Configuration.GetConnectionString("DefaultConnection")
    ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");

// Format connection string with environment variable secret
var connectionString = string.Format(connectionStringTemplate, dbPassword);

builder.Services.AddScoped<IAuthService>(sp => 
    new SqlAuthenticationService(connectionString, sp.GetRequiredService<IPasswordHasher>()));

// Configure Cookie Authentication
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.LoginPath = "/Account/Login";
        options.LogoutPath = "/Account/Logout";
        options.ExpireTimeSpan = TimeSpan.FromHours(2);
    });

var app = builder.Build();

app.UseStaticFiles();
app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Account}/{action=Login}/{id?}");

app.Run();