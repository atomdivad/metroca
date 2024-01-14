import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:metroca/models/anuncio.dart';
import 'package:metroca/models/categoria.dart';
import 'package:metroca/models/usuario.dart';
import '../utils/constants.dart';

class Anuncios with ChangeNotifier {
  final String _token;
  List<Anuncio> _items = [];
  late final Usuario usuario;
  late final Categoria categoria;
  final List<dynamic> fotos = [];

  Anuncios([
    this._token = '',
    // this._items = const [],
  ]);

  List<Anuncio> get items => [..._items];
  int get itemsCount {
    return _items.length;
  }

  Future<void> carregaAnuncios() async {
    _items.clear();
    final resposta = await http.get(
      Uri.parse(Constants.listaAnuncios),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
    );

    if (resposta.statusCode != 200) {
      throw "Token expirado";
    }
    if (resposta.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(resposta.body);
    data["items"].forEach((anuncioDados) {
      // print(anuncioDados['fotos']);
      _items.add(Anuncio(
          idanuncio: anuncioDados['idanuncio'],
          titulo: anuncioDados['titulo'],
          descricao: anuncioDados['descricao'],
          interesses: anuncioDados['interesses'],
          fotos: anuncioDados['fotos']));
    });
    // }

    notifyListeners();
  }
}
