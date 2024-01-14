import 'package:flutter/material.dart';

class Usuario with ChangeNotifier {
  final String idusuario;
  final String usuario;
  final String nome;

  Usuario({
    required this.idusuario,
    required this.usuario,
    required this.nome,
  });
}
