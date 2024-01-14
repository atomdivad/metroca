import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:metroca/models/login.dart';
import 'package:metroca/models/mensagem.dart';
import 'package:metroca/modulos/principal/controller/anuncioController.dart';
import 'package:metroca/modulos/principal/anuncio_detalhe/message_bubble.dart';
import 'package:metroca/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AnuncioMensagem extends StatefulWidget {
  int conversaId;
  AnuncioMensagem({super.key, required this.conversaId});

  @override
  State<AnuncioMensagem> createState() => _AnuncioMensagemState();
}

class _AnuncioMensagemState extends State<AnuncioMensagem> {
  // bool verifica_conversa(Future<int> idconversa) {}

  // int conversaId_int = 0;

  // Future<void> converteId() async {
  //   conversaId_int = await widget.conversaId;
  // }

  // final StreamController _myStreamCtrl = StreamController.broadcast();
  // Stream get onVariableChanged => _myStreamCtrl.stream;
  // void updateMyUI() => _myStreamCtrl.sink.add(myNum);

  // final StreamController<List<Mensagem>> _mystreamCtrl =
  //     StreamController<List<Mensagem>>.broadcast();

  // Stream<List<Mensagem>> get onCurrentUserChanged => _mystreamCtrl.stream;

  late Stream<List<Mensagem>> stream;

  @override
  void initState() {
    super.initState();
    AnuncioController providerMensagem =
        Provider.of<AnuncioController>(context, listen: false);
    stream = providerMensagem.getDataStream(context, widget.conversaId);
  }

// https://copyprogramming.com/howto/how-to-refresh-a-widget-with-stream-builder-in-flutter
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    AnuncioController providerMensagem =
        Provider.of<AnuncioController>(context, listen: false);
    // providerMensagem.idConversa = widget.conversaId;
    // providerMensagem.dadosLista();
    return StreamBuilder(
      stream: providerMensagem.getDataStream(context, widget.conversaId),
      builder: (context, AsyncSnapshot<List<Mensagem>> a) {
        if (a.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (a.connectionState == ConnectionState.active ||
            a.connectionState == ConnectionState.done) {
          if (a.hasError) {
            // print(a.error);
            return const Center(child: Text("Error Occured"));
          }
          if (a.hasData) {
            // print(a.data[0].usuario);
            return ListView.builder(
              reverse: true,
              itemCount: a.data?.length,
              itemBuilder: (ctx, i) => MessageBubble(
                mensagem: a.data![i],
                belongsToCurrentUser: a.data?[i].usuario! == auth.usuario,
              ),
            );
          }

          return const Center(child: Text("No Data Received"));
        }
        return Center(child: Text(a.connectionState.toString()));
      },
    );
  }
}
