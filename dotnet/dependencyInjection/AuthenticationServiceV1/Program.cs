using System;

class Program
{
    static void Main(string[] args)
    {
        AuthenticationService auth = new AuthenticationService();
        auth.Authenticate(args[0],args[1]);
    }
}