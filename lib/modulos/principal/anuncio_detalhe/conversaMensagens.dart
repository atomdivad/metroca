import 'package:flutter/material.dart';
import 'package:metroca/componentes/appbar_personalizado.dart';
import 'package:metroca/models/conversa.dart';
import 'package:metroca/modulos/mensagens/controller/conversasController.dart';
import 'package:metroca/modulos/principal/anuncio_detalhe/anuncio_mensagem.dart';
import 'package:metroca/modulos/principal/anuncio_detalhe/nova_mensagem.dart';
import 'package:provider/provider.dart';

class conversaMensagens extends StatefulWidget {
  conversaMensagens({super.key});

  @override
  State<conversaMensagens> createState() => _conversaMensagensState();
}

class _conversaMensagensState extends State<conversaMensagens> {
  bool _semMensagens = false;

  set estadoMensagens(bool estado) => setState(() => _semMensagens = estado);
  @override
  Widget build(BuildContext context) {
    // MensagensController providerMensagem =
    //     Provider.of<MensagensController>(context, listen: false);
    conversasController providerConversas =
        Provider.of<conversasController>(context, listen: false);
    final Conversa conversa =
        ModalRoute.of(context)?.settings.arguments as Conversa;
    print("conversa_ID ???????????: ${conversa.idconversa}");
    return Scaffold(
      appBar: AppBarPersonalizado("Mensagem"),
      body: SafeArea(
        child: FutureBuilder(
            //remover o futurebuilder
            //causando mtas requisições
            future: providerConversas.retornaConversa(
                context, conversa.anuncio.idanuncio),
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
                      idAnuncio: conversa.anuncio.idanuncio,
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
