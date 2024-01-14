import 'package:flutter/material.dart';
import 'package:metroca/utils/app_routes.dart';

class AppBarPersonalizado extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  AppBarPersonalizado(
    this.title, {
    Key? key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.mensagens,
            );
          },
          icon: Icon(Icons.message),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.cadastrarAnuncio,
            );
          },
          icon: Icon(Icons.new_label_outlined),
        ),
      ],
    );
  }
}
