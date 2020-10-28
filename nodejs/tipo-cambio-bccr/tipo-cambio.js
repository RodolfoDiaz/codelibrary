// Tipo cambio de compra y de venta del dólar de los Estados Unidos de América
// Referencia del Banco Central de Costa Rica
// En colones costarricenses

module.exports.compra = compra;
module.exports.venta = venta;

const axios = require('axios');
const IndicadorCompra = '317';
const IndicadorVenta = '318';

function compra(antiguedadEnDias = 30) {
  return obtenerDatos(IndicadorCompra, antiguedadEnDias);
}

function venta(antiguedadEnDias = 30) {
  return obtenerDatos(IndicadorVenta, antiguedadEnDias);
}

function obtenerDatos(tipoIndicador, antiguedadEnDias) {
  var fechaInicio = new Date();
  fechaInicio.setDate(fechaInicio.getDate() - antiguedadEnDias);
  var fechaFinal = new Date();

  var queryString =
    '?tcIndicador=' +
    tipoIndicador +
    '&tcFechaInicio=' +
    fechaInicio.toLocaleDateString('es-CR') +
    '&tcFechaFinal=' +
    fechaFinal.toLocaleDateString('es-CR') +
    '&tcNombre=Test&tnSubNiveles=N';
  const url =
    'https://gee.bccr.fi.cr/indicadoreseconomicos/WebServices/wsIndicadoresEconomicos.asmx/ObtenerIndicadoresEconomicos' +
    queryString;

  return axios
    .get(url)
    .then((response) => {
      var convert = require('xml-js');
      var json = convert.xml2json(response.data, { compact: true, spaces: 4 });
      return json;
    })
    .catch((error) => {
      console.log('Error', error);
    });
}
