import 'package:banca_movil_app/routes/routes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        appBarTheme: AppBarTheme(color: Color.fromARGB(255, 66, 112, 64)),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: getRoutes(),
    );
  }
}
