import 'package:flutter/material.dart';

class HomeAdministrador extends StatefulWidget {
  const HomeAdministrador({super.key});

  @override
  State<HomeAdministrador> createState() => _HomeAdministradorState();
}

class _HomeAdministradorState extends State<HomeAdministrador> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Text('Administrador'),
    );
  }
}