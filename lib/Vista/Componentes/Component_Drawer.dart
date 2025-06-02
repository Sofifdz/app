import 'package:app/Controlador/ServiciosFirebase.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComponentDrawer extends StatefulWidget {
  
  final List<String> items;
  final List<IconData> iconos;
  final List<VoidCallback> onTaps;
  final String typeUser;
  final Color colorr;
  final String username;
  final String usuarioId; 

  const ComponentDrawer({
    super.key,
    required this.items,
    required this.iconos,
    required this.onTaps,
    required this.typeUser,
    required this.colorr,
    required this.username, 
    required this.usuarioId,
  });

  @override
  State<ComponentDrawer> createState() => _ComponentDrawerState();
}

class _ComponentDrawerState extends State<ComponentDrawer> {
  late String _username = 'Cargando...';

  @override
  void initState() {
    super.initState(); 
    _loadUsername();
  }



  Future<void> _loadUsername() async {
    String username =
        await ServiciosFirebasePersonal.getUsername(widget.usuarioId);
    if (mounted) {
      setState(() {
        _username = username.isEmpty ? 'Usuario desconocido' : username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String headerText ='Hola $_username';
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 200,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: widget.colorr,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(30.0, 30.0, 10.0, 10.0),
                child: Text(
                  headerText,
                  style: GoogleFonts.montserrat(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              for (int i = 0; i < widget.items.length; i++)
                ListTile(
                  leading:
                      Icon(widget.iconos[i], size: 30, color: Colors.black),
                  title: Text(widget.items[i],
                      style: GoogleFonts.montserrat(fontSize: 18)),
                  onTap: widget.onTaps[i],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
