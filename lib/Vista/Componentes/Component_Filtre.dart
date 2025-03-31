import 'package:flutter/material.dart';

class Component_Filtre extends StatefulWidget {
  final Function(String, bool)
      onFilterChanged; // Modificado para recibir orden ascendente/descendente

  const Component_Filtre({Key? key, required this.onFilterChanged})
      : super(key: key);

  @override
  State<Component_Filtre> createState() => _Component_FiltreState();
}

class _Component_FiltreState extends State<Component_Filtre> {
  String _selectedFilter = "nombre";
  bool _descending = false; // Filtro en orden ascendente por defecto

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Ordenar por:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ListTile(
            title: const Text("Nombre"),
            leading: Radio<String>(
              value: "nombre",
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
              },
            ),
          ),
          ListTile(
            title: const Text("Precio"),
            leading: Radio<String>(
              value: "precio",
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
              },
            ),
          ),
          ListTile(
            title: const Text("Existencias"),
            leading: Radio<String>(
              value: "existencias",
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
              },
            ),
          ),
          SwitchListTile(
            title: const Text("Orden descendente"),
            value: _descending,
            onChanged: (value) {
              setState(() => _descending = value);
            },
          ),
          ElevatedButton(
            onPressed: () {
              widget.onFilterChanged(_selectedFilter, _descending);
              Navigator.pop(context);
            },
            child: const Text("Aplicar Filtro"),
          ),
        ],
      ),
    );
  }
}
