import 'package:app/Vista/Administrador/Vista_Pedidos.dart';
import 'package:app/Vista/Empleado/Vista_PedidosEmpleado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';

class VistaAgregarpedido extends StatefulWidget {
  final String usuarioId;
  final String username;
  const VistaAgregarpedido({
    super.key,
    required this.usuarioId,
    required this.username,
  });

  @override
  State<VistaAgregarpedido> createState() => _VistaAgregarpedidoState();
}

class _VistaAgregarpedidoState extends State<VistaAgregarpedido> {
  final NoPedidoController = TextEditingController();
  final clienteController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();
  final fechaController = BoardDateTimeTextController();
  DateTime date = DateTime.now();

  final formKey = GlobalKey<FormState>();

  Future<void> registrerPedido() async {
    try {

      final snapshot =
          await FirebaseFirestore.instance.collection('pedidos').get();

      final newPedidoId =
          (snapshot.docs.length + 1).toString(); 
      await FirebaseFirestore.instance
          .collection('pedidos')
          .doc(newPedidoId)
          .set({
        'id': newPedidoId,
        'cliente': clienteController.text,
        'descripcion': descripcionController.text,
        'precio': int.parse(precioController.text),
        'fecha': BoardDateFormat('dd/MM/yyyy HH:mm').format(date),
        'isEntregado': false,
      });

      print('ID: $newPedidoId');
      print('Cliente: ${clienteController.text}');
      print('Descripción: ${descripcionController.text}');
      print('Precio: ${precioController.text}');
      print('Fecha: ${BoardDateFormat('dd/MM/yyyy HH:mm').format(date)}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pedido registrado con éxito')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error al registrar pedido: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 209, 219, 250),
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
                  builder: (context) => VistaPedidosEmpleado(
                        usuarioId: widget.usuarioId,
                        username: widget.username,
                      )),
            );
          },
        ),
        actions: [agregar(context)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Componentes("Cliente", clienteController),
              Componentes("Descripción", descripcionController,
                  isDescription: true),
              Componentes("Precio", precioController),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 65,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 209, 219, 250),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Fecha de entrega: ',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            if (selectedDate != null && selectedDate != date) {
                              TimeOfDay? selectedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(
                                    hour: date.hour, minute: date.minute),
                              );

                              if (selectedTime != null) {
                                setState(() {
                                  date = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedTime.hour,
                                    selectedTime.minute,
                                  );

                                  fechaController.setDate(date);

                                  print(
                                      "Fecha y hora seleccionada: ${BoardDateFormat('dd/MM/yyyy HH:mm').format(date)}");
                                });
                              }
                            }
                          },
                          child: Text(
                            BoardDateFormat('dd/MM/yyyy HH:mm').format(date),
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Componentes(String titulo, TextEditingController controller,
      {bool isDescription = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: GoogleFonts.montserrat(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: isDescription
                ? const EdgeInsets.all(8.0) 
                : EdgeInsets.zero,
            child: TextFormField(
              controller: controller,
              keyboardType:
                  isDescription ? TextInputType.multiline : TextInputType.text,
              textInputAction: isDescription
                  ? TextInputAction.newline
                  : TextInputAction.done,
              maxLines: isDescription ? null : 1,
              decoration: InputDecoration(
                hintText: isDescription
                    ? 'Escribe la descripción del pedido'
                    : 'Ingresa $titulo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget agregar(BuildContext context) {
    return IconButton(
        onPressed: () {
          registrerPedido();
        },
        icon: Icon(Icons.save));
  }
}
