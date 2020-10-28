// Tipo cambio de compra y de venta del dólar de los Estados Unidos de América
// Referencia del Banco Central de Costa Rica
// En colones costarricenses

module.exports.compra = compra;
module.exports.venta = venta;

const axios = require('axios');
const IndicadorCompra = '317';
const IndicadorVenta = '318';

function compra(correoElectronico, tokenDeSuscripcion, antiguedadEnDias = 30) {
  return obtenerDatos(
    IndicadorCompra,
    antiguedadEnDias,
    correoElectronico,
    tokenDeSuscripcion
  );
}

function venta(correoElectronico, tokenDeSuscripcion, antiguedadEnDias = 30) {
  return obtenerDatos(
    IndicadorVenta,
    antiguedadEnDias,
    correoElectronico,
    tokenDeSuscripcion
  );
}

function obtenerDatos(
  tipoIndicador,
  antiguedadEnDias,
  correoElectronico,
  tokenDeSuscripcion
) {
  var fechaInicio = new Date();
  fechaInicio.setDate(fechaInicio.getDate() - antiguedadEnDias);
  var fechaFinal = new Date();

  var queryString =
    '?Indicador=' +
    tipoIndicador +
    '&FechaInicio=' +
    fechaInicio.toLocaleDateString('es-CR') +
    '&FechaFinal=' +
    fechaFinal.toLocaleDateString('es-CR') +
    '&Nombre=Test&SubNiveles=N' +
    '&CorreoElectronico=' +
    correoElectronico +
    '&Token=' +
    tokenDeSuscripcion;
  const url =
    'https://gee.bccr.fi.cr/Indicadores/Suscripciones/WS/wsindicadoreseconomicos.asmx/ObtenerIndicadoresEconomicos' +
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
