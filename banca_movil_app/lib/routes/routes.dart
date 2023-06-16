import 'package:banca_movil_app/screens/cobro_qr_page.dart';
import 'package:banca_movil_app/screens/cobros_page.dart';
import 'package:banca_movil_app/screens/movimientos_page.dart';
import 'package:banca_movil_app/screens/pagos_page.dart';
import 'package:flutter/material.dart';

import 'package:banca_movil_app/screens/home_page.dart';
import 'package:banca_movil_app/screens/login_page.dart';
import 'package:banca_movil_app/screens/pago_qr_page.dart';

Map<String, WidgetBuilder> getRoutes(){
  return {
    '/' : (context) => LoginPage(),
    '/home' : (context) => HomePage(),
    '/cobros' :(context) => CobrosPage(),
    '/pagos' :(context) => PagosPage(),
    '/movimientos' : (context) => MovimientosPage(),
    '/pago/qr' :(context) => PagoQrPage(),
    '/cobro/qr' : (context) => CobroQrPage()
  };
}