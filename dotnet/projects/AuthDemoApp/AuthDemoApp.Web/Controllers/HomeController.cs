using AuthDemoApp.Web.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using System.Security.Claims;

namespace AuthApp.Web.Controllers;

[Authorize] // Restricts access to authenticated users only
public class HomeController : Controller
{
    public IActionResult Index()
    {
        // Retrieve claims set during Login in AccountController
        var userName = User.Identity?.Name ?? "User";
        var userEmail = User.FindFirstValue(ClaimTypes.Email) ?? string.Empty;

        ViewData["UserName"] = userName;
        ViewData["UserEmail"] = userEmail;

        return View();
    }

    public IActionResult Privacy()
    {
        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}