import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Banca movil - Home', style: TextStyle(color: Colors.white),  
        ),
      ),
      body: _getMenu(context),
    );
  }


  Widget _getMenu(context){
    List opciones = [
      {'texto': 'Realizar pago', 'ruta': '/pagos' , 'icon' : 'payment'},
      {'texto': 'Realizar cobro', 'ruta': '/cobros', 'icon' : 'credit_score'},
      {'texto': 'Ver movimientos', 'ruta': '/movimientos', 'icon' : 'fact_check'}
    ];
    List<Widget> opciones_widget = [];
    opciones.forEach((opcion) => {
      opciones_widget.add(ListTile(
        title: Text(opcion['texto']),
        leading: _getIconFromString(opcion['icon']),
        trailing: Icon(Icons.arrow_forward_ios_outlined),
        onTap: () => {
          Navigator.pushNamed(context, opcion['ruta'])
        },
      ))
    });
    return ListView(children: opciones_widget,);
  }
  Widget _getIconFromString(String icon){
    Map icons = {
      'payment' : Icon(Icons.payment),
      'credit_score' : Icon(Icons.credit_score),
      'fact_check' : Icon(Icons.fact_check)
    };
    return icons[icon];
  }
}

