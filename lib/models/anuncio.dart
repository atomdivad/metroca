import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:metroca/models/login.dart';
import 'package:metroca/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Anuncio with ChangeNotifier {
  final int idanuncio;
  final String titulo;
  final String descricao;
  final String interesses;
  final List<dynamic> fotos;
  final String usuario;
  bool eFavorito;

  Anuncio({
    this.idanuncio = 0,
    this.titulo = '',
    this.descricao = '',
    this.interesses = '',
    this.fotos = const [],
    this.eFavorito = false,
    this.usuario = '',
  });

  void _alternaFavorito() {
    eFavorito = !eFavorito;
    notifyListeners();
  }

  Future<void> verificaFavorito(BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    // print("id anuncio: $idanuncio");
    try {
      http.Response resposta = await http.get(
        Uri.parse(
            Constants().verificaAnuncioFavoritoPeloId(idanuncio.toString())),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${auth.token}',
        },
      );

      if (resposta.body == 'null') return;
      Map<String, dynamic> dados = json.decode(resposta.body);

      eFavorito = dados['favorito'];
      // print(eFavorito);
    } catch (_) {
      eFavorito = false;
    }
    notifyListeners();
  }

  Future<void> alternaFavorito(BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    try {
      _alternaFavorito();

      if (eFavorito) {
        try {
          http.Response resposta =
              await http.post(Uri.parse(Constants.adicionaFavorito),
                  headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization': 'Bearer ${auth.token}',
                  },
                  body: jsonEncode({
                    "anuncio_id": idanuncio.toInt(),
                  }));

          if (resposta.body == 'null') return;
          eFavorito = true;
          print(resposta.body);
        } catch (_) {
          eFavorito = false;
        }
        notifyListeners();
      } else {
        //remove favorito
        try {
          http.Response resposta = await http.delete(
              Uri.parse(Constants().removeFavoritos(idanuncio.toString())),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer ${auth.token}',
              });

          if (resposta.body == 'null') return;
          eFavorito = false;
          print(resposta.body);
        } catch (_) {
          eFavorito = true;
        }
        notifyListeners();
      }
    } catch (_) {
      _alternaFavorito();
    }
  }
}
