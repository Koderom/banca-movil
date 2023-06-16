import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PagosPage extends StatefulWidget {
  const PagosPage({super.key});

  @override
  State<PagosPage> createState() => _PagosPageState();
}

class _PagosPageState extends State<PagosPage> {
  String cuentaSeleccionada = '';
  String monto = '';
  String cuentaDestino = '';
  String error = '';
  String _token = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Banca movil - Pagos')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          
          children: [
            _getInputListCuentas(),
            _getInputMonto(),
            _getInputCuentaDestino(),
            
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _pagar(),
              child: const Text('Pagar'),
            ),
            ElevatedButton(
              onPressed: ()=> _generarQr(), 
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_2),
                  Text('Pagar con QR'),
                ],
              ) 
            ),
            Text(error)
          ],
        ),
      ),
    );
  }
  @override
  void initState(){
    super.initState();  
    _listaCuentas = _cargarCuentas();
    _obtenerToken();
  }
  void _obtenerToken() async{
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    String token =    prefs.getString('token')!;
    _token = 'Bearer $token';
  }
  late Future<List<dynamic>> _listaCuentas;
  Future<List<dynamic>> _cargarCuentas() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token =   await prefs.getString('token')!;
    int clienteCi =  prefs.getInt('clienteCi')!;
    
    token = 'Bearer $token';
    debugPrint(token);
    final uri = Uri.parse('https://banca-movil-api.fly.dev/cuentas-usuario?clienteCi=$clienteCi');
    http.Response response = await http.get(uri,
      headers: {
        'authorization': token,
      },
      
    );

    if(response.statusCode == 200){
      var res = utf8.decode(response.bodyBytes);
      var cuentas = json.decode(res);
      return cuentas;
    }else{
      debugPrint(response.statusCode.toString());
      debugPrint(response.body);
      return [];
    }
  }

  Widget _getInputListCuentas(){
    return FutureBuilder(
      future: _listaCuentas,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          List<dynamic> cuentas = snapshot.data!;
          return DropdownButtonFormField(
            hint: Text(cuentaSeleccionada),
            items: cuentas.map((cuenta){
              debugPrint(cuenta.toString());
              return DropdownMenuItem(
                child: Text('${cuenta['nro']} - saldo : ${cuenta['saldo']}'),
                value: cuenta['nro'],
              );
            }).toList(), 
            onChanged: (value){
              setState(() {
                cuentaSeleccionada = value.toString();
              });
            },
            decoration: InputDecoration(
              icon: Icon(Icons.credit_score_outlined),
              labelText: 'Seleccione una cuenta',
            ),
          );
        }else{
          return Text("cargando cuentas...");
        }
      }
    );
  }

  Widget _getInputMonto(){
    return TextFormField(
      onChanged: (value) {
        setState(() {
          monto = value;
        });
      },
      decoration: InputDecoration(
        icon: Icon(Icons.monetization_on),
        labelText: 'Monto',
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  Widget _getInputCuentaDestino(){
    return TextFormField(
      onChanged: (value) {
        setState(() {
          cuentaDestino = value;
        });
      },
      decoration: InputDecoration(
        icon: Icon(Icons.credit_card),
        labelText: 'Cuenta destino',
      ),
    );
  }

  void _pagar() async{
    if(monto.length == 0 || cuentaSeleccionada.length == 0 || cuentaDestino.length == 0) return;
    
    try {
      int nroCuentaOrigen = int.parse(cuentaSeleccionada);
      int nroCuentaDestino = int.parse(cuentaDestino);
      double montoPago = double.parse(monto);
      
      if(!await validarCuenta(nroCuentaDestino)){
        debugPrint('error al validar la cuenta');
        setState(() {
          this.error = 'error en cuenta destino';
        });
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token =   await prefs.getString('token')!;
      token = 'Bearer $token';
    

      http.Response request = await http.post(Uri.parse('https://banca-movil-api.fly.dev/retiro-cuenta'),
        headers: {
          'authorization': token,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "nroCuenta" : nroCuentaOrigen,
          "monto" : montoPago
        })
      );
      if(request.statusCode != 200){
        setState(() {
          this.error = request.body;  
        });
        return;
      }
      
      request = await http.post(Uri.parse('https://banca-movil-api.fly.dev/deposito-cuenta'),
        headers: {
          'authorization': token,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "nroCuenta" : nroCuentaDestino,
          "monto" : montoPago
        })
      );
      if(request.statusCode == 200) {
        setState(() {
          this.error = 'Pago exitoso';
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> validarCuenta(int nroCuenta) async {
    http.Response response = await http.get(Uri.parse('https://banca-movil-api.fly.dev/usuario-cuenta?nroCuenta=${nroCuenta}'),
      headers: {'authorization': _token}
    );
    if(response.statusCode == 200) return true;
    debugPrint(response.body);
    return false;
  }

  void _generarQr() async{
    if(this.cuentaSeleccionada.length == 0 || this.monto.length == 0){
      setState(() {
        error = 'Seleccionar una cuenta y ingrese un monto valido';
      });
      return;
    }
    
    var request = await http.get(Uri.parse('https://banca-movil-api.fly.dev/saldo-cuenta?nroCuenta=$cuentaSeleccionada'),
      headers: {'authorization': _token}
    );
    if(request.statusCode == 200){
      Map info = json.decode(request.body);
      double saldo = double.parse(info['saldo']);
      double monto = double.parse(this.monto);
      if(saldo >= monto){
        Navigator.pushNamed(context, '/pago/qr', arguments: {
          'nroCuenta' : cuentaSeleccionada,
          'monto' : monto
        });
      }else{
        setState(() {
          error = 'Saldo insuficiente';
        });
      }
    }
    
  }
}