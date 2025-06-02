import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Principalbotones extends StatelessWidget {
  const Principalbotones({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Panadería Yadael",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          actions: [
            SizedBox(
              height: 40,
              width: 80,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: const Color.fromARGB(255, 142, 194, 146),
                child: Text(
                  "Pagar",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
          backgroundColor: Colors.brown,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Wrap(
                children: [
                  CardsPan("Pan 10", const Color.fromARGB(255, 173, 219, 175)),
                  CardsPan("Pan 9", const Color.fromARGB(255, 173, 199, 221)),
                  CardsPan("Pan 5", const Color.fromARGB(255, 173, 128, 128)),
                ],
              ),
              const SizedBox(height: 20),
              titleproductos(),
              const SizedBox(height: 30),
              productosList(),
              const Spacer(),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total:",
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "36", // Solo de muestra
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
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

  Widget CardsPan(String title, Color color) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 150,
          width: 105,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(height: 8),
                Text(
                  '0', // Valor estático solo para diseño
                  style: GoogleFonts.roboto(fontSize: 25),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleproductos() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Productos",
            style: GoogleFonts.montserrat(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.qr_code_scanner),
        ),
      ],
    );
  }

  Widget productosList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "1",
              style: GoogleFonts.roboto(fontSize: 20),
            ),
            Text(
              "Producto",
              style: GoogleFonts.roboto(fontSize: 20),
            ),
            Text(
              "\$ 0",
              style: GoogleFonts.roboto(fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }
}
