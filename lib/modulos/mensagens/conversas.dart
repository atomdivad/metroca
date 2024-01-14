import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:metroca/componentes/app_drawer.dart';
import 'package:metroca/componentes/appbar_personalizado.dart';
import 'package:metroca/models/anuncio.dart';
import 'package:metroca/models/conversa.dart';
import 'package:metroca/models/login.dart';
import 'package:metroca/modulos/mensagens/conversaItem.dart';
import 'package:metroca/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Conversas extends StatefulWidget {
  const Conversas({super.key});

  @override
  State<Conversas> createState() => _ConversasState();
}

class _ConversasState extends State<Conversas> {
  bool mostraBranco = false;
  static const _pageSize = 50;
  final PagingController<int, Conversa> _pagingController =
      PagingController(firstPageKey: 1);

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<Conversa> newItems = [];
      final auth = Provider.of<Auth>(context, listen: false);
      final resposta = await http.get(
        Uri.parse(Constants().listaConversasPaginacao(pageKey)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${auth.token}',
        },
      );
      // print(resposta.body);
      if (resposta.body == 'null') return;
      Map<String, dynamic> data = jsonDecode(utf8.decode(resposta.bodyBytes));

      data["items"].forEach((conversaDados) {
        newItems.add(Conversa(
          idconversa: conversaDados['idconversa'],
          anuncio: Anuncio(
            idanuncio: conversaDados['anuncio']['idanuncio'],
            titulo: conversaDados['anuncio']['titulo'],
            descricao: conversaDados['anuncio']['descricao'],
            usuario: conversaDados['anuncio']['usuario']['usuario'],
            fotos: conversaDados['anuncio']['fotos'],
          ),
        ));
        // print(newItems);
      });

      if (newItems.length == 0) {
        setState(() {
          mostraBranco = true;
        });
      } else {
        setState(() {
          mostraBranco = false;
        });
      }
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      print(error);
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(_pagingController);
    return Scaffold(
      appBar: AppBarPersonalizado('Mensagens'),
      body: mostraBranco
          ? Text('')
          : PagedListView<int, Conversa>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Conversa>(
                itemBuilder: (context, item, index) => conversaItem(item),
              ),
            ),
      drawer: AppDrawer(),
    );
  }
}
