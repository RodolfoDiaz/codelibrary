const tc = require('./tipo-cambio');

// Obtener tipo de cambio de compra del dólar
// para los últimos 30 dias (opción predefinida)
tc.compra().then((response) => {
  console.log(response);
});

// Obtener tipo de cambio de venta del dólar
// para los últimos 90 dias
tc.venta(90).then((response) => {
  console.log(response);
});
