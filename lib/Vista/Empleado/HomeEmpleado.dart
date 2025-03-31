import 'package:flutter/material.dart';

class Homeempleado extends StatefulWidget {
  const Homeempleado({super.key});

  @override
  State<Homeempleado> createState() => _HomeempleadoState();
}

class _HomeempleadoState extends State<Homeempleado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Text('Administrador'),
    );
  }
}