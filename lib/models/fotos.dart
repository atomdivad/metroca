import 'package:flutter/material.dart';

class Fotos with ChangeNotifier {
  final String idfoto;
  final String foto_codigo;

  Fotos({
    required this.idfoto,
    required this.foto_codigo,
  });
}
