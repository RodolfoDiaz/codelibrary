using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

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
}