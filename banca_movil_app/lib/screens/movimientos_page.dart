import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MovimientosPage extends StatefulWidget {
  const MovimientosPage({super.key});

  @override
  State<MovimientosPage> createState() => _MovimientosPageState();
}

class _MovimientosPageState extends State<MovimientosPage> {
  String _cuenta = '';
  String _saldo = '';
  late Future<List<dynamic>> _listaCuentas;
  List<dynamic> _listaMovimientos = [];

  @override
  void initState() {
    super.initState();
    _listaCuentas = _getListaCuentas();
    //_listaMovimientos = _getListaMovimientos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Banca movil - Movimientos')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            _getInputCuentasDisponibles(),
            SizedBox(height: 16.0),
            Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Saldo: $_saldo', style: TextStyle(fontSize: 24.00)),
            )),
            SizedBox(height: 16.0),
            Text('Movimientos:', style: TextStyle(fontSize: 18.00)),
            _getMovimientos()
          ],
        ),
      ),
    );
  }

  Future<String> _obtenerToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('token')!;
    return 'Bearer $token';
  }

  Future<String> _obtenerClienteCi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int ci = prefs.getInt('clienteCi')!;
    return ci.toString();
  }

  Future<List<dynamic>> _getListaCuentas() async {
    String token = await _obtenerToken();
    String clienteCi = await _obtenerClienteCi();
    http.Response request = await http.get(
        Uri.parse(
            'https://banca-movil-api.fly.dev/cuentas-usuario?clienteCi=$clienteCi'),
        headers: {'authorization': token});
    if (request.statusCode == 200) {
      var resp = utf8.decode(request.bodyBytes);
      var cuentas = json.decode(resp);
      return cuentas;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> _getListaMovimientos() async {
    String token = await _obtenerToken();

    if (_cuenta.length == 0) return [];

    http.Response request = await http.get(
        Uri.parse(
            'https://banca-movil-api.fly.dev/movimientos-cuenta?nroCuenta=$_cuenta'),
        headers: {'authorization': token});
    if (request.statusCode == 200) {
      var resp = utf8.decode(request.bodyBytes);
      var movimientos = json.decode(resp);
      debugPrint(movimientos.toString());
      return movimientos['movimientos'];
    } else {
      return [];
    }
  }

  Widget _getInputCuentasDisponibles() {
    return FutureBuilder(
        future: _listaCuentas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<dynamic> cuentas = snapshot.data!;
            return DropdownButtonFormField(
              hint: Text(_cuenta),
              items: cuentas.map((cuenta) {
                return DropdownMenuItem(
                  child: Text('${cuenta['nro']} - saldo: ${cuenta['saldo']}'),
                  value: cuenta,
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  if (value != null) {
                    value as Map;
                    _cuenta = value['nro'].toString();
                    _saldo = value['saldo'].toString();
                  }
                  debugPrint(value.toString());
                });
              },
              decoration: InputDecoration(
                labelText: 'Seleccione una cuenta',
              ),
            );
          } else {
            return Text('Buscando cuentas...');
          }
        });
  }

  Widget _getMovimientos() {
    return FutureBuilder(
        future: _getListaMovimientos(),
        builder: (context, snapshot) {
          if (_cuenta.isEmpty) return Text("esperando que seleccione cuenta");
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: _movimientosWidget(snapshot.data!),
            );
          } else {
            return Container(
              child: Center(child: CircularProgressIndicator()),
              width: 20.0,
            );
          }
        });
  }

  List<Widget> _movimientosWidget(List movimientos) {
    List<Widget> list_movimientos = [];
    movimientos.forEach((element) {
      late Color color;
      late Icon icono;

      if (element['tipo_movimiento'] == 'deposito') {
        color = Color.fromARGB(255, 174, 243, 176);
        icono = Icon(
          Icons.add,
          color: color,
        );
      } else {
        color = Color.fromARGB(255, 238, 162, 157);
        icono = Icon(Icons.remove, color: color);
      }

      list_movimientos.add(Card(
        color: Color.fromARGB(255, 252, 252, 252),
        child: ListTile(
          leading: icono,
          title: Text(
            element['tipo_movimiento'].toString().toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(179, 82, 82, 82)),
          ), 
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Monto: ${element['monto']}'),
              Text('Fecha: ${DateTime.parse(element['fecha_hora'])}')
            ],
          ),
          
        ),

      ));
    });
    return list_movimientos;
  }
}
