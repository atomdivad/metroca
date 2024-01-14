import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:metroca/utils/constants.dart';

class configuracoesController with ChangeNotifier {
  final String _token;

  configuracoesController([
    this._token = '',
  ]);

  Future<void> cadastraAnuncio(Map<String, Object> formData) async {
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

    notifyListeners();
  }
}
