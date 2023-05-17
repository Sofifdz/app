// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;

// class BuscarCategorias extends StatefulWidget {
//   const BuscarCategorias({super.key});

//   @override
//   State<BuscarCategorias> createState() => _BuscarCategoriasState();
// }

// class _BuscarCategoriasState extends State<BuscarCategorias> {
//   final TextEditingController textEditingController = TextEditingController();
//   List<dynamic> categorias = [];
//   Box box = Hive.box('categorias');
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF9e9c71),
//         title: Row(
//           children: [
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.only(left: 10),
//                 margin: const EdgeInsets.only(bottom: 5),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     bottomLeft: Radius.circular(10),
//                   ),
//                 ),
//                 child: TextField(
//                   autofocus: true,
//                   onTap: () {},
//                   onEditingComplete: () {
//                     FocusScope.of(context).unfocus();
//                   },
//                   onChanged: (value) {
//                     setState(
//                       () {
//                         if (value.isEmpty) {
//                           categorias = [];
//                         } else {
//                           categorias = box.values
//                               .where((element) => element
//                                   .toString()
//                                   .toLowerCase()
//                                   .contains(value.toLowerCase()))
//                               .toList();
//                         }
//                       },
//                     );
//                   },
//                   controller: textEditingController,
//                   decoration: const InputDecoration(
//                     fillColor: Colors.amber,
//                     border: InputBorder.none,
//                     hintText: 'Buscar producto',
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.only(bottom: 5),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(10),
//                   bottomRight: Radius.circular(10),
//                 ),
//               ),
//               child: IconButton(
//                 splashRadius: 25,
//                 icon: const Icon(
//                   Icons.search,
//                   color: Colors.blue,
//                 ),
//                 onPressed: () {},
//               ),
//             )
//           ],
//         ),
//       ),
//       body: categorias.isEmpty
//           ? const Center(
//               child: Text('No hay resultados'),
//             )
//           : ListView.builder(
//               itemCount: categorias.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(categorias[index]),
//                 );
//               },
//             ),
//     );
//   }
// }
