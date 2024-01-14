import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:metroca/models/conversa.dart';
import 'package:metroca/models/login.dart';
import 'package:metroca/utils/constants.dart';
import 'package:provider/provider.dart';

// https://stackoverflow.com/questions/72171944/how-to-refresh-data-periodically-with-stream
class conversasController with ChangeNotifier {
  late final String _token;
  late final String _usuario;
  List<Conversa> _conversas = [];
  late int _conversaId;
  conversasController(
      [this._token = '',
      this._usuario = '',
      this._conversas = const [],
      this._conversaId = 0]);

  List<Conversa> get conversas {
    return [..._conversas];
  }

  int get contaConversas {
    return _conversas.length;
  }

  int get conversaId {
    return _conversaId;
  }

  Future<int> criaConversa(BuildContext context, int idAnuncio) async {
    final auth = Provider.of<Auth>(context, listen: false);
    final resposta = await http.post(Uri.parse(Constants.criaConversa),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${auth.token}',
        },
        body: jsonEncode({"anuncio_id": idAnuncio}));
    if (resposta.body == 'null') return 0;
    final data = jsonDecode(resposta.body);

    return data['idconversa'];
  }

  Future<void> retornaConversa(BuildContext context, int anuncioId) async {
    _conversaId = 0;
    final auth = Provider.of<Auth>(context, listen: false);
    final resposta = await http.get(
      Uri.parse(Constants.listaConversas),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${auth.token}',
      },
    );

    if (resposta.body == 'null') return;
    final data = jsonDecode(resposta.body);

    Map<String, dynamic> lista = new Map.from(data);

    if (data['pages'] <= 1) {
      data['items'].forEach((dadosMensagem) {
        if (dadosMensagem['anuncio']['idanuncio'] == anuncioId) {
          _conversaId = dadosMensagem['idconversa'];
          return dadosMensagem['idconversa'];
        }
      });
    } else {
      for (int contador = 2; contador <= data['pages']; contador++) {
        final resposta_loop = await http.get(
          Uri.parse('${Constants.listaConversas}?page=$contador'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${auth.token}',
          },
        );
        if (resposta_loop.body == 'null') return;
        final data_loop = jsonDecode(resposta_loop.body);
        lista['items'].addAll(data_loop['items']);
      }
    }

    lista['items'].forEach((dadosMensagem) {
      if (dadosMensagem['anuncio']['idanuncio'] == anuncioId) {
        _conversaId = dadosMensagem['idconversa'];
        return dadosMensagem['idconversa'];
      }
    });
  }

  // StreamController<List<Conversa>> controller =
  //     StreamController<List<Conversa>>();
  // Timer? timer;

  // void fetchCurrency() async {
  //   //do your api call and add data to stream
  //   List<Conversa> conversasteste = [];
  //   final response = await http.get(
  //     Uri.parse(Constants.listaConversas),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $_token',
  //     },
  //   );
  //   final data = jsonDecode(response.body);
  //   print(data);
  //   data.forEach((dadosConversa) {
  //     _conversas.add(Conversa(
  //       idconversa: dadosConversa['idconversa'],
  //       anuncio: Anuncio(
  //           titulo: dadosConversa['titulo'],
  //           descricao: dadosConversa['descricao'],
  //           idanuncio: dadosConversa['idanuncio']),
  //     ));
  //   });
  //   controller.add(conversasteste);
  // }

  // Stream<http.Response> listaConversas() async* {
  //   yield* Stream.periodic(Duration(seconds: 1), (_) {
  //     return http.get(
  //       Uri.parse(Constants.listaConversas),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization': 'Bearer $_token',
  //       },
  //     );
  //   }).asyncMap((event) async => await event);
  // }

  // Stream<http.Response> listaConversas() async* {
  //   yield* Stream.periodic(Duration(seconds: 1), (_) {
  //     return http.get(
  //       Uri.parse(Constants.listaConversas),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization': 'Bearer $_token',
  //       },
  //     );
  //   }).asyncMap((event) async => await event);
  // }
  // while (true) {
  //   await Future.delayed(Duration(milliseconds: 5000));
  //   _conversas.clear();
  // final resposta = http.get(
  //   Uri.parse(Constants.listaConversas),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Authorization': 'Bearer $_token',
  //   },
  // );
  //   // final data = jsonDecode(resposta.body);
  //   // print(data);
  //   // data.forEach((dadosConversa) {
  //   //   _conversas.add(Conversa(
  //   //     idconversa: dadosConversa['idconversa'],
  //   //     anuncio: Anuncio(
  //   //         titulo: dadosConversa['titulo'],
  //   //         descricao: dadosConversa['descricao'],
  //   //         idanuncio: dadosConversa['idanuncio']),
  //   //   ));
  //   // });

  //   HttpClient httpClient = new HttpClient();
  //   HttpClientRequest request =
  //       await httpClient.getUrl(Uri.parse(Constants.listaConversas));
  //   request.headers.set('content-type', 'application/json');
  //   request.headers.set('Authorization', 'Bearer $_token');
  //   // request.add(utf8.encode(json.encode(jsonMap)));
  //   HttpClientResponse response = await request.close();
  //   // todo - you should check the response.statusCode
  //   String reply = await response.transform(utf8.decoder).join();
  //   httpClient.close();
  //   // return reply;
  //   print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  //   // print(reply);
  //   List<Conversa> teste = _recebeApi(reply);
  //   print(teste);
  //   yield [
  //     Conversa(
  //         idconversa: 1,
  //         anuncio: Anuncio(titulo: 'teste', descricao: 'teste'))
  //   ];
  // return Stream<List<Conversa>>.multi((controller) {
  //   resposta.listen(
  //     (snapshot) {
  //       List<ChatMessage> lista = snapshot.docs.map((doc) {
  //         return doc.data();
  //       }).toList();
  //       controller.add(lista);
  //     },
  //   );
  // });

  // List<Conversa> _recebeApi(
  //   String doc,
  // ) {
  //   List<Conversa> conversao = [];
  //   final teste = jsonDecode(doc);
  //   teste['items'].forEach((dadosConversa) {
  //     conversao.add(Conversa(
  //       idconversa: dadosConversa['idconversa'],
  //       anuncio: Anuncio(
  //           titulo: dadosConversa['anuncio']['titulo'],
  //           descricao: dadosConversa['anuncio']['descricao'],
  //           idanuncio: dadosConversa['anuncio']['idanuncio']),
  //     ));
  //   });

  //   return conversao;
  // }

  // Future<void> mostraConversa(int conversaId) async {
  //   _conversas.clear();
  //   final resposta = await http.get(
  //     Uri.parse(Constants().getConversaDetalhada(conversaId)),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $_token',
  //     },
  //   );
  //   final data = jsonDecode(resposta.body);
  //   print(data);
  //   data.forEach((dadosConversa) {
  //     _conversas.add(Conversa(
  //       idconversa: dadosConversa['idconversa'],
  //       anuncio: Anuncio(
  //           titulo: dadosConversa['titulo'],
  //           descricao: dadosConversa['descricao'],
  //           idanuncio: dadosConversa['idanuncio']),
  //     ));
  //   });

  //   notifyListeners();
  // }
}
