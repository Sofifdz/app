import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controlador/Ventas.dart'; 

class VentanaTicket extends StatelessWidget {
  final Ventas venta;

  const VentanaTicket({super.key, required this.venta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 209, 219, 250),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 35,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                const SizedBox(height: 16),
                Center(
                  child: venta.desdePedido == true ?
                  Text(
                    'Pedido #${venta.pedidoId}',
                    style: GoogleFonts.montserrat(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ):
                  Text(
                    'Venta #${venta.IDventa}',
                    style: GoogleFonts.montserrat(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  )
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Fecha: ${venta.fecha}',
                      style: GoogleFonts.montserrat(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Productos',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: venta.productos.length,
                    itemBuilder: (context, index) {
                      final producto = venta.productos[index];
                      final nombre = producto['productoname'] ?? 'Producto';
                      final cantidad = producto['cantidad'] ?? 1;
                      final precio = (producto['precio'] ?? 0).toDouble();
                      final subtotal = cantidad * precio;
                      final descripcion = venta.descripcion.toString();
                      final cliente = venta.cliente.toString();
            
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: venta.desdePedido == true ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Descripción del pedido: \n$descripcion',
                                style: GoogleFonts.montserrat(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text('Cliente: \n$cliente',
                                style: GoogleFonts.montserrat(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text('\$${subtotal.toStringAsFixed(2)}',
                                style: GoogleFonts.montserrat(fontSize: 16)),
                          ],
                        ):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(nombre,
                                style: GoogleFonts.montserrat(fontSize: 16)),
                            Text('Cantidad: $cantidad',
                                style: GoogleFonts.montserrat(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text('\$${subtotal.toStringAsFixed(2)}',
                                style: GoogleFonts.montserrat(fontSize: 16)),
                          ],
                        )
                      );
                    },
                  ),
                ),
                const Divider(thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${venta.total.toStringAsFixed(2)}',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
