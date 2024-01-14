import 'package:flutter/material.dart';
import 'package:metroca/utils/app_routes.dart';
import 'package:provider/provider.dart';

import '../models/login.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: const Text('Bem Vindo Usuário'),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text('Principal'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.authOrHome,
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.shop),
          title: Text('Favoritos'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.anunciosFavoritos,
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.my_library_books),
          title: const Text('Meus Anúncios'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.meusAuncios,
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.payment),
          title: const Text('Configurações'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.configuracoes,
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.message),
          title: const Text('Conversas'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.mensagens,
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Sair'),
          onTap: () {
            Provider.of<Auth>(
              context,
              listen: false,
            ).logout();
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.authOrHome,
            );
          },
        ),
      ],
    ));
  }
}
