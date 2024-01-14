import 'package:flutter/material.dart';

class ajustaDimensoes {
  static MediaQueryData? _mQueryData;
  static Orientation? orientation;

  init(BuildContext context) {
    _mQueryData = MediaQuery.of(context);
    orientation = _mQueryData!.orientation;
  }

  double get telaAltura => _mQueryData!.size.height - _mQueryData!.padding.top;

  double get telaLargura => _mQueryData!.size.width;
}
