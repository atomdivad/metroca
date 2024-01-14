import 'dart:convert';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metroca/models/anuncio.dart';
import 'package:metroca/componentes/appbar_personalizado.dart';
import 'package:metroca/modulos/principal/controller/anuncioController.dart';
import 'package:metroca/utils/app_routes.dart';
import 'package:provider/provider.dart';

class AnuncioDetalheUsuario extends StatefulWidget {
  AnuncioDetalheUsuario({Key? key}) : super(key: key);

  @override
  State<AnuncioDetalheUsuario> createState() => _AnuncioDetalheUsuarioState();
}

class _AnuncioDetalheUsuarioState extends State<AnuncioDetalheUsuario> {
  bool anuncioFavorito = false;
  Uint8List mostraFoto(var hash) {
    Uint8List bytesImage = const Base64Decoder().convert(hash);
    return bytesImage;
  }

  @override
  Widget build(BuildContext context) {
    // final msg = ScaffoldMessenger.of(context);
    final Anuncio anuncio =
        ModalRoute.of(context)?.settings.arguments as Anuncio;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarPersonalizado('MeTroca'),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(width: 2.0, color: Colors.lightBlue.shade900),
            )),
            height: MediaQuery.of(context).size.height * .35,
            width: double.infinity,
            child: anuncio.fotos.isNotEmpty
                ? ImageSlideshow(
                    indicatorColor: Colors.blue,
                    children: [
                      for (var item in anuncio.fotos)
                        Image.memory(
                          mostraFoto(item['foto_codigo']),
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        )
                    ],
                  )
                : const Center(
                    child: Image(
                      height: 100,
                      width: 100,
                      image: AssetImage('assets/images/no-image.png'),
                    ),
                  ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              anuncio.titulo,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          anuncio.descricao,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 30, bottom: 30),
                            width: MediaQuery.of(context).size.width,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        Text(
                          'Interesses',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          anuncio.descricao,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            Expanded(
              child: InkWell(
                onTap: () async {
                  await Provider.of<AnuncioController>(
                    context,
                    listen: false,
                  ).deletaAnuncio(context, anuncio.idanuncio);

                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.authOrHome,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Anúncio ${anuncio.titulo} deletado"),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Finalizar Anúncio',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
