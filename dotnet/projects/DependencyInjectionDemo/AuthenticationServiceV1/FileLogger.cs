public class FileLogger
{
    public void Log(string message)
    {
        // Tightly coupled implementation writing directly to a local file
        File.AppendAllText("audit.log", $"[{DateTime.UtcNow}] {message}{Environment.NewLine}");
    }
}
