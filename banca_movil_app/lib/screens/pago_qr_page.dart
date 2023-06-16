import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PagoQrPage extends StatelessWidget {
  const PagoQrPage({super.key});

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: json.encode(args),
              size: 250.0,
            ),
            SizedBox(height: 100.0),
            ElevatedButton(
              child: Text('Volver'),
              onPressed: (){
                Navigator.popAndPushNamed(context, '/home');
              }
            )
          ],
        ),
        
      )    );
  }
}