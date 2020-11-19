namespace TipoCambioBCCR
{
    class Program
    {
        // Info: https://www.bccr.fi.cr/seccion-indicadores-economicos/servicio-web
        private const string CorreoElectronico = "";
        private const string TokenDeSuscripcion = "";

        static void Main(string[] args)
        {
            var tipoCambioCompra = TipoCambio.Compra(CorreoElectronico, TokenDeSuscripcion);
            
            var tipoCambioVenta = TipoCambio.Venta(CorreoElectronico, TokenDeSuscripcion);
        }
    }
}
