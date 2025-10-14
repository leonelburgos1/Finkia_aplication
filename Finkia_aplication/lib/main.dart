import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AGROU',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SplashScreen(), // <- aquí pones tu splash primero
    );
  }
}

// Ejemplo de tu pantalla principal
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio AGROU')),
      body: const Center(child: Text('Bienvenido a Finkia 🌱')),
    );
  }
}
