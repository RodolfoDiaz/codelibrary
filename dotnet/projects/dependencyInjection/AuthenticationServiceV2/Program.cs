using System;
using Microsoft.Extensions.DependencyInjection;

public class Program
{
    static void Main(string[] args)
    {
        // Setup Dependency Injection Container
        var services = new ServiceCollection();

        // Register AuthenticationService
        services.AddTransient<AuthenticationService>();

        // Swap out ANY of these 3 implementations without changing AuthenticationService:

        // Case 1: File Logging
         services.AddSingleton<IAuditLogger>(new FileAuditLogger("audit.log"));

        // Case 2: On-Premise SQL Database Logging
        // services.AddSingleton<IAuditLogger>(new SqlDatabaseAuditLogger("Server=localhost;Database=AuditDB;..."));

        // Case 3: Cloud-Based Repository Logging
        // services.AddSingleton<IAuditLogger>(new CloudAuditLogger("cloud-api-key-12345"));

        // Build container and execute
        var serviceProvider = services.BuildServiceProvider();
        var authService = serviceProvider.GetRequiredService<AuthenticationService>();

        authService.Authenticate(args[0], args[1]);
    }
}