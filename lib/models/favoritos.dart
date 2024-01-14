import 'package:flutter/material.dart';
import 'package:metroca/models/anuncio.dart';
import 'package:metroca/models/categoria.dart';
import 'package:metroca/models/usuario.dart';

class Favoritos with ChangeNotifier {
  final String _token;
  List<Anuncio> _items = [];
  late final Usuario usuario;
  late final Categoria categoria;
  final List<dynamic> fotos = [];

  Favoritos([
    this._token = '',
    // this._items = const [],
  ]);

  List<Anuncio> get items => [..._items];
  int get itemsCount {
    return _items.length;
  }
}
