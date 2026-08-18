using System;

class Program
{
    static void Main(string[] args)
    {
        AuthenticationService auth = new AuthenticationService();
        bool isValid = args.Length > 0 && auth.Authenticate(args[0], args[1]);
        if (isValid)
        {
            Console.WriteLine("Authentication successful.");
        }
        else
        {
            Console.WriteLine("Authentication failed.");
        }
    }
}