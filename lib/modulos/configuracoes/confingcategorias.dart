import 'package:flutter/material.dart';
import 'package:metroca/models/categoria.dart';

class ConfigCategorias extends StatefulWidget {
  List<Categoria> categorias = [];
  ConfigCategorias({super.key, required this.categorias});

  @override
  State<ConfigCategorias> createState() => _ConfigCategoriasState();
}

class _ConfigCategoriasState extends State<ConfigCategorias> {
  @override
  Widget build(BuildContext context) {
    Categoria? dropdownValue = widget.categorias.first;
    return DropdownButton<Categoria>(
      value: null,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      // onChanged: (Categoria? value) {
      //   // This is called when the user selects an item.
      //   setState(() {
      //     dropdownValue = value!;
      //   });
      // },
      // items: _categorias
      //     .map<DropdownMenuItem<Categoria>>((Categoria value) {
      //   return DropdownMenuItem<Categoria>(
      //     value: value.nome,
      //     child: Text(value as String),
      //   );
      // }).toList(),
      items: widget.categorias.map((Categoria categoria) {
        return DropdownMenuItem<Categoria>(
          value: categoria,
          child: Text(
            categoria.nome,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: (Categoria? value) {
        setState(() {
          dropdownValue = value;
        });
      },
    );
  }
}
