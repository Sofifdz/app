import 'package:app/Vista/Administrador/vistaAdmin.dart';
import 'package:app/Vista/Componentes/ShowDialogCaja.dart';
import 'package:app/Vista/Empleado/Vista_Ventas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  bool isVisible = false;

  final formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    final String email = _emailcontroller.text.trim();
    final String password = _passwordcontroller.text;

    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario o contraseña incorrectos")),
        );
        return;
      }

      final userDoc = querySnapshot.docs.first;
      final role = userDoc['role'];
      final username = userDoc['username'];
      final userId = userDoc.id;

      if (mounted) {
        if (role == 'Administrador') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Vistaadmin(
              username: userId,
              usuarioId: userId,
            )),
          );
        } else if (role == 'Empleado') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => VistaVentas(
                      usuarioId: userId,
                      username: userDoc['username'],
                    )),
          );

          ShowDialogCaja.show(
            context: context,
            usuarioId: userId,
            username: username,
            abroOcierro: 'Abro con',
            txtBoton: 'Comenzar',
            tipoOperacion: "abrir",
          );
        }
      }
    } catch (e) {
      print("Error al iniciar sesión: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
          
          
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
                            onPressed: () async {
                              await _login();

                              /*User? user = FirebaseAuth.instance.currentUser;

                              if (user != null) {
                                // Obtener los datos del usuario desde Firestore
                                DocumentSnapshot userDoc =
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .get();

                                if (userDoc.exists) {
                                  String usuarioId = user.uid;
                                  String username =
                                      userDoc['username'] ?? 'Usuario';

                                  AperturaCajaDialog.show(
                                    context: context,
                                    usuarioId: usuarioId,
                                    username: username,
                                  );
                                }
                              }*/
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
                      /*Text("crear cuenta"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPrueba()));
                          },
                          child: const Text("Crear cuenta"))*/
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
