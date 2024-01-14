import 'package:flutter/material.dart';

class Categoria with ChangeNotifier {
  final int idcategoria;
  final String nome;
  final String descricao;

  Categoria({
    required this.idcategoria,
    required this.nome,
    required this.descricao,
  });

  Categoria.fromJson(Map<String, dynamic> json)
      : idcategoria = json['idcategoria'],
        nome = json['nome'],
        descricao = json['descricao'];

  Map<String, dynamic> toJson() =>
      {'idcategoria': idcategoria, 'nome': '$nome', 'descricao': '$descricao'};
}
