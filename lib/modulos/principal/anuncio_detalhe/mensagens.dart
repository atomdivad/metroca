import 'package:flutter/material.dart';
import 'package:metroca/componentes/appbar_personalizado.dart';
import 'package:metroca/models/anuncio.dart';
import 'package:metroca/modulos/mensagens/controller/conversasController.dart';
import 'package:metroca/modulos/principal/anuncio_detalhe/anuncio_mensagem.dart';
import 'package:metroca/modulos/principal/anuncio_detalhe/nova_mensagem.dart';
import 'package:provider/provider.dart';

class Mensagens extends StatefulWidget {
  Mensagens({super.key});

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  // late int conversaId_int;
  // Future<void> converteId(BuildContext context, idAnuncio) async {
  //   conversasController providerConversas =
  //       Provider.of<conversasController>(context, listen: false);
  //   conversaId_int =
  //       // await providerConversas.retornaConversa(context, idAnuncio);
  // }
  bool _semMensagens = false;

  set estadoMensagens(bool estado) => setState(() => _semMensagens = estado);
  @override
  Widget build(BuildContext context) {
    // MensagensController providerMensagem =
    //     Provider.of<MensagensController>(context, listen: false);
    conversasController providerConversas =
        Provider.of<conversasController>(context, listen: false);
    final Anuncio anuncio =
        ModalRoute.of(context)?.settings.arguments as Anuncio;
    // print("ANUNCIO_ID ???????????: ${anuncio.idanuncio}");
    return Scaffold(
      appBar: AppBarPersonalizado("Mensagem"),
      body: SafeArea(
        child: FutureBuilder(
            //remover o futurebuilder
            //causando mtas requisições
            future:
                providerConversas.retornaConversa(context, anuncio.idanuncio),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.error != null) {
                return const Center(
                  child: Text('Ocorreu um erro'),
                );
              } else {
                print("CONVERSA_ID: ${providerConversas.conversaId}");
                return Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: AnuncioMensagem(
                      conversaId: providerConversas.conversaId,
                    )),
                    NovaMensagem(
                      callback: (val) => setState(() => _semMensagens = val),
                      conversaId: providerConversas.conversaId,
                      idAnuncio: anuncio.idanuncio,
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
