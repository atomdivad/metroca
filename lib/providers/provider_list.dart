import 'package:metroca/models/anuncios.dart';
import 'package:metroca/models/favoritos.dart';
import 'package:metroca/models/login.dart';
import 'package:metroca/modulos/configuracoes/controller/configuracoesController.dart';
import 'package:metroca/modulos/mensagens/controller/conversasController.dart';
import 'package:metroca/modulos/principal/controller/anuncioController.dart';
import 'package:provider/provider.dart';

final providerList = [
  ChangeNotifierProvider(
    create: (_) => Auth(),
  ), //precisa ser o primeiro para que o Anuncios dependa de auth
  ChangeNotifierProxyProvider<Auth, Anuncios>(
    create: (_) => Anuncios(),
    update: (ctx, auth, previous) {
      return Anuncios(
        auth.token ?? '',
      );
    },
  ),
  ChangeNotifierProxyProvider<Auth, Favoritos>(
    create: (_) => Favoritos(),
    update: (ctx, auth, previous) {
      return Favoritos();
    },
  ),
  ChangeNotifierProxyProvider<Auth, configuracoesController>(
    create: (_) => configuracoesController(),
    update: (ctx, auth, previous) {
      return configuracoesController(
        auth.token ?? '',
        // previous?.categorias ?? [],
      );
    },
  ),
  ChangeNotifierProxyProvider<Auth, conversasController>(
    create: (_) => conversasController(),
    update: (ctx, auth, previous) {
      return conversasController(
        auth.token ?? '',
        auth.usuario ?? '',
        previous?.conversas ?? [],
      );
    },
  ),
  ChangeNotifierProxyProvider<Auth, AnuncioController>(
    create: (_) => AnuncioController(),
    update: (ctx, auth, previous) {
      return AnuncioController(
        auth.token ?? '',
        auth.usuario ?? '',
        previous?.mensagens ?? [],
      );
    },
  ),
  // ChangeNotifierProxyProvider<Auth, Configuracoes>(
  //   create: (_) => Configuracoes(),
  //   update: (ctx, auth, previous) {
  //     // no update passa a lista e o token ( passa itens caso seja necessario recriar o token)
  //     return Configuracoes();
  //   },
  // ),
];
