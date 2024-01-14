import 'package:flutter/material.dart';
import 'package:metroca/config/tema.dart';
import 'package:metroca/modulos/cadastro/view/cadastrarAnuncio.dart';
import 'package:metroca/modulos/configuracoes/configuracoes.dart';
import 'package:metroca/modulos/favoritos/anuncios_favoritos.dart';
import 'package:metroca/modulos/mensagens/conversas.dart';
import 'package:metroca/modulos/principal/anuncio_detalhe/anuncio_detalhe_usuario.dart';
import 'package:metroca/modulos/principal/anuncio_detalhe/anuncio_detalhe.dart';
import 'package:metroca/modulos/principal/anuncio_detalhe/conversaMensagens.dart';
import 'package:metroca/modulos/principal/anuncio_detalhe/mensagens.dart';
import 'package:metroca/modulos/principal/controller/meus_anuncios.dart';
import 'package:metroca/pages/home.dart';
import 'package:metroca/providers/provider_list.dart';
import 'package:provider/provider.dart';
import './utils/app_routes.dart';
import 'dart:async';
import 'package:metroca/models/login.dart';
// https://docs.flutter.dev/cookbook
// https://docs.flutter.dev/get-started/codelab

void main() {
  const oneSec = Duration(seconds: 300);
  Timer.periodic(
      oneSec,
      (Timer t) =>
          Auth().atualizaLocalizacao()); //atualiza localização a cada 5 minutos
  runApp(const meTrocaApp());
}

class meTrocaApp extends StatelessWidget {
  const meTrocaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // https://www.appsloveworld.com/flutter/100/36/how-to-execute-a-method-in-a-certain-time-in-flutter
    //metodo para atualizar lat/lng
    //
    return MultiProvider(
      //Multiprovider resolve o problema em que é necessário instanciar mais de um provider..
      //e eles precisam se comunicar
      providers: providerList,
      child: MaterialApp(
        title: 'MeTroca App',
        theme: MeTrocaTema.of(context),
        routes: {
          AppRoutes.authOrHome: (ctx) => const Home(),
          AppRoutes.configuracoes: (ctx) => const Configuracoes(),
          AppRoutes.meusAuncios: (ctx) => const MeusAnuncios(),
          AppRoutes.cadastrarAnuncio: (ctx) => const cadastrarAnuncio(),
          AppRoutes.anuncioDetalhe: (ctx) => AnuncioDetalhe(),
          AppRoutes.anuncioDetalheUsuario: (ctx) => AnuncioDetalheUsuario(),
          AppRoutes.anunciosFavoritos: (ctx) => const AnunciosFavoritos(),
          AppRoutes.anuncioMensagem: (ctx) => Mensagens(),
          AppRoutes.mensagens: (ctx) => const Conversas(),
          AppRoutes.conversaMensagem: (ctx) => conversaMensagens(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
