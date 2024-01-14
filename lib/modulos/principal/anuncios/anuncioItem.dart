import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:metroca/models/anuncio.dart';
import 'package:metroca/utils/app_routes.dart';

class AnuncioItem extends StatefulWidget {
  final Anuncio anuncio;
  AnuncioItem(this.anuncio);

  @override
  State<AnuncioItem> createState() => _AnuncioItemState();
}

class _AnuncioItemState extends State<AnuncioItem> {
  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);

    // final anuncio = Provider.of<Anuncio>(
    //   context,
    //   listen: false,
    // );
    var b64 = (widget.anuncio.fotos.length != 0)
        ? widget.anuncio.fotos[0]['foto_codigo']
        : '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';

    Uint8List bytesImage = const Base64Decoder().convert(b64);

    var _tema = Theme.of(context);
    // return Container(
    //   // height: 200,
    //   // width: 200,
    //   decoration: const BoxDecoration(
    //       borderRadius: BorderRadius.all(Radius.circular(15)),
    //       color: Color.fromARGB(255, 134, 134, 101)),
    //   child: Padding(
    //     padding: const EdgeInsets.all(17.0),
    //     child: Row(
    //       children: [
    //         Image.memory(
    //           bytesImage,
    //           fit: BoxFit.fill,
    //           height: 100,
    //           width: 100,
    //         ),
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: <Widget>[
    //               Text(
    //                 titulo,
    //                 style: _tema.textTheme.headlineMedium?.copyWith(),
    //               ),
    //               Text(
    //                 descricao,
    //                 style: _tema.textTheme.displaySmall?.copyWith(),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 3,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: MemoryImage(bytesImage),
          radius: 30,
          // child: Image.memory(
          //   bytesImage,
          //   fit: BoxFit.cover,
          //   height: 100,
          //   width: 100,
          // ),
        ),
        title: Text(widget.anuncio.titulo,
            style: _tema.textTheme.headlineMedium?.copyWith()),
        subtitle: Text(
          widget.anuncio.descricao,
          style: _tema.textTheme.displayMedium?.copyWith(),
        ),
        onTap: () async {
          await widget.anuncio.verificaFavorito(context);
          Navigator.of(context).pushNamed(
            AppRoutes.anuncioDetalhe,
            arguments: widget.anuncio,
          );
        },
        // trailing: MediaQuery.of(context).size.width > 480
        //     ? TextButton.icon(
        //         onPressed: () {},
        //         icon: const Icon(Icons.delete),
        //         label: Text('Excluir',
        //             style: TextStyle(
        //               color: Theme.of(context).errorColor,
        //             )),
        //       )
        //     : IconButton(
        //         icon: const Icon(Icons.delete),
        //         color: Theme.of(context).errorColor,
        //         onPressed: () {}),
      ),
    );
  }
}
