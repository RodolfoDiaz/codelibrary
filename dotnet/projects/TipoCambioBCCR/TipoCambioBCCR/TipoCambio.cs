using System;
using System.Data;
using System.Globalization;
using TipoCambioBCCR.IndicadoresEconomicos;

namespace TipoCambioBCCR
{
    /// <summary>
    /// Tipo cambio de compra y de venta del dólar de los Estados Unidos de América
    /// Referencia del Banco Central de Costa Rica
    /// En colones costarricenses
    /// </summary>
    public static class TipoCambio
    {
        private const string IndicadorCompra = "317";
        private const string IndicadorVenta = "318";
        private const string Subniveles = "N";
        private const string FormatoFecha = "dd/MM/yyyy";

        public static DataSet Compra(string correoElectronico, string tokenDeSuscripcion, int antiguedadEnDias = 30)
        {
            return ObtenerDatos(correoElectronico, tokenDeSuscripcion, IndicadorCompra, antiguedadEnDias);
        }
        public static DataSet Venta(string correoElectronico, string tokenDeSuscripcion, int antiguedadEnDias = 30)
        {
            return ObtenerDatos(correoElectronico, tokenDeSuscripcion, IndicadorVenta, antiguedadEnDias);
        }

        private static DataSet ObtenerDatos(string correoElectronico, string tokenDeSuscripcion, string tipoIndicador, int antiguedadEnDias)
        {
            string fechaInicio = DateTime.Today.AddDays(antiguedadEnDias * -1).ToString(FormatoFecha, CultureInfo.InvariantCulture);
            string fechaFin = DateTime.Today.ToString(FormatoFecha, CultureInfo.InvariantCulture);

            wsindicadoreseconomicosSoapClient servicioWeb = new wsindicadoreseconomicosSoapClient();
            var tipoCambio = new DataSet();
            tipoCambio = servicioWeb.ObtenerIndicadoresEconomicos(tipoIndicador, fechaInicio, fechaFin, "Website", Subniveles, correoElectronico,tokenDeSuscripcion);

            return tipoCambio;
        }
    }
}
