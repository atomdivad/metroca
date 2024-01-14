import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:metroca/models/login.dart';
import 'package:metroca/models/mensagem.dart';
import 'package:metroca/modulos/mensagens/controller/conversasController.dart';
import 'package:metroca/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AnuncioController with ChangeNotifier {
  late final String _token;
  late final String _usuario;
  List<Mensagem> _mensagensLista = [];
  int idConversa;
  AnuncioController([
    this._token = '',
    this._usuario = '',
    this._mensagensLista = const [],
    this.idConversa = 0,
  ]);

  List<Mensagem> get mensagens {
    return [..._mensagensLista];
  }

  int get contaMensagens {
    return _mensagensLista.length;
  }

  Future<void> dadosLista() async {
    _mensagensLista.clear();
    http.Response response = await http.get(
      Uri.parse(Constants().getConversaDetalhada(idConversa)),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
    );
    Map<String, dynamic> map = json.decode(utf8.decode(response.bodyBytes));

    map['items'].forEach((dadosMensagem) {
      _mensagensLista.add(
        Mensagem(
          mensagem: dadosMensagem['mensagem'],
          usuario: dadosMensagem['usuario']['usuario'],
          created_at: DateTime.parse(dadosMensagem['created_at']),
        ),
      );
    });
    notifyListeners();
  }

  Stream<List<Mensagem>> getDataStream(
      BuildContext context, int idconversa) async* {
    final auth = Provider.of<Auth>(context, listen: false);

    while (true) {
      http.Response response = await http.get(
        Uri.parse(Constants().getConversaDetalhada(idconversa)),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${auth.token}',
        },
      );

      Map<String, dynamic> map = json.decode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> lista = Map.from(map);

      if (map['pages'] != null) {
        if (map['pages'] <= 1) {
          pegaMensagens(map);
        } else {
          for (int contador = 2; contador <= map['pages']; contador++) {
            final resposta_loop = await http.get(
              Uri.parse(
                  '${Constants().getConversaDetalhada(idconversa)}?page=$contador'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${auth.token}',
              },
            );
            if (resposta_loop.body == 'null') return;
            final data_loop = jsonDecode(utf8.decode(resposta_loop.bodyBytes));
            lista['items'].addAll(data_loop['items']);
          }
        }
        pegaMensagens(lista);
      }

      yield _mensagensLista;

      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Future<void> deletaAnuncio(BuildContext context, int id) async {
    final auth = Provider.of<Auth>(context, listen: false);
    http.Response resposta = await http.delete(
      Uri.parse(Constants().deletaAnuncio(id)),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${auth.token}',
      },
    );

    if (resposta.body == 'null') return;
    final data = jsonDecode(resposta.body);
    if (data['status'] == 'Anúncio deletado') {
      print('Deletado');
    } else {
      return;
    }
    // notifyListeners();
  }

  Future<void> pegaMensagens(Map<String, dynamic> teste) async {
    _mensagensLista.clear();
    teste['items'].forEach((dadosMensagem) {
      _mensagensLista.add(
        Mensagem(
          mensagem: dadosMensagem['mensagem'],
          usuario: dadosMensagem['usuario']['usuario'],
          created_at: DateTime.parse(dadosMensagem['created_at']),
        ),
      );
    });
    // notifyListeners();
  }

  Future<void> salvaMensagem(
      BuildContext context, int conversaId, String mensagem, idAnuncio) async {
    final auth = Provider.of<Auth>(context, listen: false);
    conversasController providerConversas =
        Provider.of<conversasController>(context, listen: false);
    print("mensagem enviada ${conversaId}");
    if (conversaId == 0) {
      print("entrou aqui????? ");
      conversaId = await providerConversas.criaConversa(context, idAnuncio);
      providerConversas.retornaConversa(context, idAnuncio);
    }
    final resposta = await http.post(
        Uri.parse(Constants().getEnviaMensagem(conversaId.toString())),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${auth.token}',
        },
        body: jsonEncode({
          "mensagem": mensagem,
          "conversa_id": conversaId,
        }));

    if (resposta.body == 'null') return;
    // notifyListeners();
  }
}
