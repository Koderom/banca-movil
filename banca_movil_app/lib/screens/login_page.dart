import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _clienteCi = '';
  String _clientePassword = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Banca movil', style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 18.0,),
            TextField(
              decoration: InputDecoration(
                labelText: 'CI',
                suffixIcon: Icon(Icons.person)
                
              ),
              onChanged: (value){
                _clienteCi = value;
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: Icon(Icons.password)                
              ),
              onChanged: (value) {
                _clientePassword = value;
              },
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(onPressed: () => _login(_clienteCi,_clientePassword), 
            child: const Text('login')),
          ],
        ),
      ),
    );
  }
  void _login(String clienteCi, String clientePassword) async{
    var response = await http.post(Uri.parse('https://banca-movil-api.fly.dev/login'),
      headers: {'Content-Type': 'application/json'}, 
      body:jsonEncode({
        "ci" : int.parse(_clienteCi),
        "password" : int.parse(_clientePassword)
      }),
    );
    if(response.statusCode == 200){
      String token = json.decode(utf8.decode(response.bodyBytes));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setInt('clienteCi', int.parse(_clienteCi));
      
      Navigator.pushNamed(context, '/home');
    }else{
      debugPrint("error en el login");
    }
  }
}
