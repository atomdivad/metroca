import 'package:flutter/material.dart';

class Mensagem with ChangeNotifier {
  final String mensagem;
  final dynamic usuario;
  final DateTime created_at;

  Mensagem({
    required this.mensagem,
    required this.usuario,
    required this.created_at,
  });
}
