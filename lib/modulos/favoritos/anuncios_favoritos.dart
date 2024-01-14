import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:metroca/componentes/app_drawer.dart';
import 'package:metroca/models/anuncio.dart';
import 'package:metroca/models/login.dart';

import 'package:metroca/componentes/appbar_personalizado.dart';
import 'package:metroca/modulos/principal/anuncios/anuncioItem.dart';
import 'package:metroca/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AnunciosFavoritos extends StatefulWidget {
  const AnunciosFavoritos({super.key});

  @override
  State<AnunciosFavoritos> createState() => _AnunciosFavoritosState();
}

class _AnunciosFavoritosState extends State<AnunciosFavoritos> {
  static const _pageSize = 50;
  bool mostraBranco = false;
  final PagingController<int, Anuncio> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<Anuncio> newItems = [];
      final auth = Provider.of<Auth>(context, listen: false);
      final resposta = await http.get(
        Uri.parse(Constants.usuarioFavoritos),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${auth.token}',
        },
      );
      // final newItems = await RemoteApi.getBeerList(pageKey, _pageSize);
      Map<String, dynamic> data = jsonDecode(utf8.decode(resposta.bodyBytes));

      data["items"].forEach((anuncioDados) {
        // print(anuncioDados['fotos']);
        newItems.add(Anuncio(
            idanuncio: anuncioDados['idanuncio'],
            titulo: anuncioDados['titulo'],
            descricao: anuncioDados['descricao'],
            interesses: anuncioDados['interesses'],
            fotos: anuncioDados['fotos'],
            usuario: anuncioDados['usuario']['usuario']));
      });

      // print(pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
      setState(() {
        mostraBranco = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizado('MeTroca'),
      body: mostraBranco
          ? Text('')
          : PagedListView<int, Anuncio>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Anuncio>(
                itemBuilder: (context, item, index) => AnuncioItem(item),
              ),
            ),
      drawer: AppDrawer(),
    );
  }
}
