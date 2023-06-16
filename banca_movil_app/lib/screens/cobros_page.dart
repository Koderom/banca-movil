import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qrscan/qrscan.dart' as scanner;

class CobrosPage extends StatefulWidget {
  const CobrosPage({super.key});

  @override
  State<CobrosPage> createState() => _CobrosPageState();
}

class _CobrosPageState extends State<CobrosPage> {
  String _mensaje = '';

  String _cuentaOrigen = '';
  String _cuentaDestino = '';
  String _monto = '';

  Future<String> _obtenerToken() async{
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    String token = await prefs.getString('token')!;
    return  'Bearer $token';
  }
  Future<String> _obtenerClienteCi() async{
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    int ci =    prefs.getInt('clienteCi')!;
    return ci.toString();
  }
  Future<List<dynamic>> _getListaCuentas() async {
    String token = await _obtenerToken();
    String clienteCi = await _obtenerClienteCi();
    http.Response request = await http.get(Uri.parse('https://banca-movil-api.fly.dev/cuentas-usuario?clienteCi=$clienteCi'),
      headers: {'authorization' : token}
    );
    if(request.statusCode == 200){
      var resp = utf8.decode(request.bodyBytes);
      var cuentas = json.decode(resp);
      return cuentas;
    }else{
      return [];
    }
  }
  late Future<List<dynamic>> _listaCuentas ; 

  @override
  void initState() {
    super.initState();
    _listaCuentas = _getListaCuentas();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Banca movil - Cobros')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            _getInputCuentaOrigen(),
            _getMontoACobrar(),
            _getInputCuentaDestino(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _cobrar(),
              child: Text('Cobrar'),
            ),
            ElevatedButton(
              onPressed: () => _scanearQr(), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code),
                  const Text('Cobrar por Qr'),
                ],
              )
            ),
            Text(_mensaje),
          ],
        ),
      ),
    );
  }

  Widget _getInputCuentaOrigen(){
    return TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Ingrese la cuenta origen',
        icon: Icon(Icons.credit_card)
      ),
      onChanged: (value) {
        setState(() {
          _cuentaOrigen = value.toString();
        });
      },
    );
  }

  Widget _getMontoACobrar(){
    return TextField(
      keyboardType: TextInputType.numberWithOptions( decimal: true),
      decoration: InputDecoration(
        icon: Icon(Icons.monetization_on),
        labelText: 'Ingrese el monto a cobrar'
      ),
      onChanged: (value) {
        _monto = value.toString();
      },
    );
  }

  Widget _getInputCuentaDestino(){
    return FutureBuilder(
      future: _listaCuentas,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          List<dynamic> cuentas = snapshot.data!;
          return DropdownButtonFormField(
            
            hint: Text(_cuentaDestino),
            items: cuentas.map((cuenta){
              return DropdownMenuItem(
                child: Text('${cuenta['nro']} - saldo : ${cuenta['saldo']}'),
                value: cuenta['nro'],
              );
            }).toList(), 
            onChanged: (value){
              setState(() {
                _cuentaDestino = value.toString();
                debugPrint(_cuentaDestino);
              });
            },
            decoration: InputDecoration(
              labelText: 'Seleccione una cuenta destino',
              icon: Icon(Icons.credit_score_outlined)
            ),
          );
        }else{
          return Text('Buscando cuentas...');
        }
      }
    );

  }
  
  void _cobrar() async {
    if(_cuentaDestino.length == 0 || _cuentaOrigen.length == 0 || _monto.length == 0) return;
    try {
      String token = await _obtenerToken();
      int nroCuentaOrigen = int.parse(_cuentaOrigen);
      if(!await validarCuenta(nroCuentaOrigen)){
        setState(() {
          _mensaje = 'cuenta invalida';
        });
        return;
      }
      int nroCuentaDestino = int.parse(_cuentaDestino);
      double montoACobrar = double.parse(_monto);
      
      http.Response request = await http.post(Uri.parse('https://banca-movil-api.fly.dev/retiro-cuenta'),
        headers: {
          'authorization': token,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "nroCuenta" : nroCuentaOrigen,
          "monto" : montoACobrar
        })
      );
      if(request.statusCode != 200){
        setState(() {
          this._mensaje = request.body;
        });
        return; 
      }
      
      request = await http.post(Uri.parse('https://banca-movil-api.fly.dev/deposito-cuenta'),
        headers: {
          'authorization': token,
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'nroCuenta' : nroCuentaDestino,
          'monto' : montoACobrar
        })
      );
      if(request.statusCode == 200) {
        setState(() {
          this._mensaje = 'Cobro exitoso';
        });
      }

    }catch(e){
      debugPrint(e.toString());
    }
  }
  Future<bool> validarCuenta(int nroCuenta) async {
    String token = await _obtenerToken();
    http.Response response = await http.get(Uri.parse('https://banca-movil-api.fly.dev/usuario-cuenta?nroCuenta=${nroCuenta}'),
      headers: {'authorization': token}
    );
    if(response.statusCode == 200) return true;
    debugPrint(response.body);
    return false;
  }
  
  void _scanearQr() async {
    if(_cuentaDestino.isEmpty){
      setState(() {
        _mensaje = 'Seleccionar cueta de destino';
      });
      return;
    }
    var data_qr = await scanner.scan();
    if(data_qr != null){
      Map data = json.decode(data_qr);
      setState(() {
        _cuentaOrigen = data['nroCuenta'].toString();
        _monto = data['monto'].toString();  
      });
      _cobrar();
    }
  }
}