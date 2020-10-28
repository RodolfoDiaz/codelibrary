const tc = require('./tipo-cambio');
// https://www.bccr.fi.cr/seccion-indicadores-economicos/servicio-web
const correoElectronico = '';
const tokenDeSuscripcion = '';

// Obtener tipo de cambio de compra del dólar
// para los últimos 30 dias (opción predefinida)
tc.compra(correoElectronico, tokenDeSuscripcion).then((response) => {
  console.log(response);
});

// Obtener tipo de cambio de venta del dólar
// para los últimos 90 dias
tc.venta(correoElectronico, tokenDeSuscripcion, 90).then((response) => {
  console.log(response);
});
