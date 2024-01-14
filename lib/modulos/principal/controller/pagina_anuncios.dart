import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:metroca/componentes/app_drawer.dart';
import 'package:metroca/data/store.dart';
import 'package:metroca/models/anuncio.dart';
import 'package:metroca/models/login.dart';
import 'package:metroca/modulos/principal/anuncios/anuncioItem.dart';
import 'package:metroca/componentes/appbar_personalizado.dart';
import 'package:metroca/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PaginaAnuncios extends StatefulWidget {
  const PaginaAnuncios({super.key});

  @override
  State<PaginaAnuncios> createState() => _PaginaAnunciosState();
}

class _PaginaAnunciosState extends State<PaginaAnuncios> {
  bool _isLoading = false;
  int? raio;
  int? categoria;
  static const _pageSize = 50;
  final PagingController<int, Anuncio> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> carregaDb() async {
    final userData = await Store.getMap(
      'userData',
    );

    // ignore: use_build_context_synchronously
    final auth = Provider.of<Auth>(context, listen: false);

    if (userData['raio'] == null) {
      raio = auth.raio;
    } else {
      raio = userData['raio'];
    }

    if (userData['idcategoria'] == null) {
      categoria = auth.idcategoria;
    } else {
      categoria = userData['idcategoria'];
    }
  }

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Auth>(context, listen: false).inicializa().then((value) {
      carregaDb();
      setState(() {
        _isLoading = false;
      });
    });

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<Anuncio> newItems = [];
      final auth = Provider.of<Auth>(context, listen: false);
      // print("categoria por aqui $categoria");
      categoria = auth.idcategoria;
      if (auth.raio != null) {
        raio = auth.raio;
      } else {
        raio = 20;
      }
      final resposta = await http.get(
        Uri.parse(
            Constants().listaAnunciosPaginacao(raio!, pageKey, categoria!)),
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
    }
  }

  // @override
  // Widget build(BuildContext context) =>

//implementar metodo que atualiza localização
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPersonalizado('MeTroca'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
// https://blog.logrocket.com/build-an-intuitive-ecommerce-product-gallery-with-flutter/
