import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:metroca/componentes/app_drawer.dart';
import 'package:metroca/models/anuncio.dart';
import 'package:metroca/models/login.dart';
import 'package:metroca/componentes/appbar_personalizado.dart';
import 'package:metroca/modulos/principal/anuncios/anuncioItemUsuario.dart';
import 'package:metroca/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({super.key});

  @override
  State<MeusAnuncios> createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  static const _pageSize = 50;
  final PagingController<int, Anuncio> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<Anuncio> newItems = [];
      final auth = Provider.of<Auth>(context, listen: false);

      final resposta = await http.get(
        Uri.parse(Constants().listaAnunciosUsuarioPaginacao(pageKey)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${auth.token}',
        },
      );

      Map<String, dynamic> data = jsonDecode(utf8.decode(resposta.bodyBytes));

      data["items"].forEach((anuncioDados) {
        newItems.add(Anuncio(
          idanuncio: anuncioDados['idanuncio'],
          titulo: anuncioDados['titulo'],
          descricao: anuncioDados['descricao'],
          interesses: anuncioDados['interesses'],
          fotos: anuncioDados['fotos'],
        ));
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizado('MeTroca'),
      body: PagedListView<int, Anuncio>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Anuncio>(
          itemBuilder: (context, item, index) => AnuncioItemUsuario(item),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
