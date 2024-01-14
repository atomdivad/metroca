import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:metroca/models/categoria.dart';
import 'package:metroca/utils/constants.dart';

class cadastroController with ChangeNotifier {
  final String _token;
  List<Categoria> _categorias = [];
  cadastroController([
    this._token = '',
    this._categorias = const [],
  ]);

  List<Categoria> get categorias {
    return [..._categorias];
  }

  int get contaCategorias {
    return _categorias.length;
  }

  Future<void> cadastraAnuncio(Map<String, Object> formData) async {
    // print(jsonEncode({
    //   "titulo": formData['titulo'],
    //   "descricao": formData['descricao'],
    //   "interesses": formData['interesses'],
    //   "fotos": formData['fotos'],
    //   "categoria_id": 1
    // }));
    // print("foto tipo");
    // print(formData['fotos']);
    // print(formData['idcategoria']);

    final resposta = await http.post(Uri.parse(Constants.cadastrarAnuncio),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          "titulo": formData['titulo'],
          "descricao": formData['descricao'],
          "interesses": formData['interesses'],
          "fotos": formData['fotos'] ?? [],
          "categoria_id": formData['idcategoria'],
        }));

    if (resposta.body == 'null') return;

    // if (data["items"].isEmpty ?? true) {

    // }
    notifyListeners();
  }

  // Future<void> listaCategorias() async {
  //   _categorias.clear();
  //   final resposta = await http.get(
  //     Uri.parse(Constants.listCategorias),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $_token',
  //     },
  //   );
  //   final data = jsonDecode(resposta.body);
  //   // print(data);
  //   data.forEach((dadosCategoria) {
  //     _categorias.add(Categoria(
  //         idcategoria: dadosCategoria['idcategoria'],
  //         nome: dadosCategoria['nome'],
  //         descricao: dadosCategoria['descricao']));
  //   });

  //   notifyListeners();
  // }
}
