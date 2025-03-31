import 'package:app/Vista/Administrador/vistaAdmin.dart';
import 'package:app/Vista/Empleado/vistaempleado.dart';
import 'package:app/Vista/Singup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isVisible = false;

  final formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailcontroller.text,
        password: _passwordcontroller.text,
      );

      final User? user = userCredential.user;
      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user!.uid).get();
      final role = userDoc['role'];

      if (mounted) {
        if (role == 'Administrador') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Vistaadmin()));
        } else if (role == 'Empleado') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => vistaempleado()));
        }
      }
    } on FirebaseAuthException catch (e) {
      print('Código de error: ${e.code}'); 

      String errorMessage;
      switch (e.code) {
        case 'invalid-credential': //esto en especifico por que firebase a veces no devuelve muy bien el error
          errorMessage = 'La contraseña es incorrecta o el usuario no existe.';
          break;
        default:
          errorMessage =
              'Error: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              //padding: const EdgeInsets.all(40.0),
              padding: const EdgeInsets.fromLTRB(40.0, 150.0, 40.0, 40.0),
              child: Container(
                height: 600,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 126, 178, 202), // Fondo azul
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Icon(
                          Icons.storefront_outlined,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Text(
                          "Iniciar Sesion",
                          style: GoogleFonts.montserrat(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Usuario
                      txt(context, "Correo"),
                      const SizedBox(height: 5),
                      txtField(context, _emailcontroller, Icon(Icons.mail),
                          null, false),
                      const SizedBox(height: 20),

                      txt(context, "Contraseña"),
                      const SizedBox(height: 5),
                      txtField(
                          context,
                          _passwordcontroller,
                          Icon(Icons.password),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: Icon(isVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          !isVisible),
                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA6C89A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              _login();
                            },
                            child: Text(
                              "Iniciar",
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text("crear cuenta"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPrueba()));
                          },
                          child: const Text("Crear cuenta"))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget txt(BuildContext context, String texto) {
    return Text(
      texto,
      style: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget txtField(
    BuildContext context,
    TextEditingController variable,
    Icon icono,
    IconButton? iconofinal,
    bool yesOrNo,
  ) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Campo obligatorio";
        }
        return null;
      },
      controller: variable,
      obscureText: yesOrNo,
      decoration: InputDecoration(
        prefixIcon: icono,
        suffixIcon: iconofinal,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
