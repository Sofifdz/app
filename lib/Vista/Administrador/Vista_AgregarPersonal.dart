import 'package:app/Vista/Administrador/Vista_Personal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Vista_AgregarPersonal extends StatefulWidget {
  final String usuarioId;
  final String username;
  const Vista_AgregarPersonal({
    super.key,
    required this.usuarioId,
    required this.username,
  });

  @override
  State<Vista_AgregarPersonal> createState() => _Vista_AgregarPersonalState();
}

class _Vista_AgregarPersonalState extends State<Vista_AgregarPersonal> {
  final usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();

  bool isVisible = false;

  String? _selectedValue = "Empleado";

  Future<void> _register() async {
    try {
    
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: _emailController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('El correo ya está registrado')),
        );
        return;
      }

  
      await _firestore.collection('users').add({
        'email': _emailController.text,
        'username': usernameController.text,
        'password': passwordController.text,
        'role': _selectedValue
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro exitoso')),
      );

      Navigator.pop(context); 
    } catch (e) {
      print('Error al registrarse: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(160, 133, 203, 144),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Color.fromARGB(255, 81, 81, 81),
            size: 35,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VistaPersonal(
                        usuarioId: widget.usuarioId,
                        username: widget.username,
                      )),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Color.fromARGB(255, 81, 81, 81),
            ),
            onPressed:
                _register, // Llamada correcta a la función sin paréntesis
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 50.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Nombre de usuario",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nombre es requerido";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email es requerido";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !isVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Contraseña es requerida";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                Container(
                  width: 400,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green,
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedValue,
                    items: [
                      DropdownMenuItem<String>(
                        value: "Empleado",
                        child: Center(
                            child: Text("Empleado",
                                style: GoogleFonts.roboto(fontSize: 20))),
                      ),
                      DropdownMenuItem<String>(
                        value: "Administrador",
                        child: Center(
                            child: Text("Administrador",
                                style: GoogleFonts.roboto(fontSize: 20))),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue;
                      });
                      print('Seleccionado: $newValue');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
