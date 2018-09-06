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
    /// <see cref="http://indicadoreseconomicos.bccr.fi.cr/indicadoreseconomicos/Cuadros/frmVerCatCuadro.aspx?idioma=1&CodCuadro=%20400"/>
    /// <see cref="https://gee.bccr.fi.cr/indicadoreseconomicos/WebServices/wsIndicadoresEconomicos.asmx"/>
    /// </summary>
    public static class TipoCambio
    {
        private const string IndicadorCompra = "317";
        private const string IndicadorVenta = "318";
        private const string Subniveles = "N";
        private const string FormatoFecha = "dd/MM/yyyy";

        public static DataSet Compra(int antiguedadEnDias = 30)
        {
            return ObtenerDatos(IndicadorCompra, antiguedadEnDias);
        }
        public static DataSet Venta(int antiguedadEnDias = 30)
        {
            return ObtenerDatos(IndicadorVenta, antiguedadEnDias);
        }

        private static DataSet ObtenerDatos(string tipoIndicador, int antiguedadEnDias)
        {
            string fechaInicio = DateTime.Today.AddDays(antiguedadEnDias * -1).ToString(FormatoFecha, CultureInfo.InvariantCulture);
            string fechaFin = DateTime.Today.ToString(FormatoFecha, CultureInfo.InvariantCulture);

            wsIndicadoresEconomicosSoapClient servicioWeb = new wsIndicadoresEconomicosSoapClient();
            var tipoCambio = new DataSet();
            tipoCambio = servicioWeb.ObtenerIndicadoresEconomicos(tipoIndicador, fechaInicio, fechaFin, "Website", Subniveles);

            return tipoCambio;
        }
    }
}
