import 'package:flutter/material.dart';
import 'package:metroca/models/login.dart';
import 'package:metroca/modulos/principal/controller/pagina_anuncios.dart';
import 'package:metroca/modulos/login/view/pagina_login.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.verificaStatusToken(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return auth.isAuth ? PaginaAnuncios() : PaginaLogin();
        }
      },
    );
  }
}
