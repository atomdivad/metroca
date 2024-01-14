import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:metroca/componentes/app_drawer.dart';
import 'package:metroca/models/categoria.dart';
import 'package:metroca/models/login.dart';

import 'package:metroca/modulos/cadastro/view/imageInput.dart';
import 'package:metroca/modulos/configuracoes/controller/configuracoesController.dart';
import 'package:metroca/utils/app_routes.dart';
import 'package:provider/provider.dart';

/*
## image_picker
para acessar a camera
(A Flutter plugin for iOS and Android for picking images from the image library, and taking new pictures with the camera.)
adicionar ao pubspec

# path_provider
A Flutter plugin for finding commonly used locations on the filesystem. 
Supports Android, iOS, Linux, macOS and Windows. Not all methods are supported on all platforms.

# path
A comprehensive, cross-platform path manipulation library for Dart.
The path package provides common operations for manipulating paths: joining, splitting, normalizing, etc.

*/

class cadastrarAnuncio extends StatefulWidget {
  const cadastrarAnuncio({super.key});

  @override
  State<cadastrarAnuncio> createState() => _cadastrarAnuncioState();
}

class _cadastrarAnuncioState extends State<cadastrarAnuncio> {
  /*  SingleTickerProviderStateMixin
      AnimationController(vsync: TickerProvider) 
      tickerprovider é uma classe que vai disparar um callback para cada frame são 60 frames
      */
  final _tituloFocus = FocusNode();
  final _descricaoFocus = FocusNode();
  final _interessesFocus = FocusNode();
  final _categoriaFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  // final _imageUrlController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<Auth>(context, listen: false).listaCategorias().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _selectImage(List<File> pickedImage) {
    final listaImagens = [];

    print(pickedImage.length);
    setState(() {
      for (int i = 0; i < pickedImage.length; i++) {
        List<int> imageBytes = pickedImage[i].readAsBytesSync();
        String bytesImage = base64Encode(imageBytes);
        listaImagens.add(bytesImage);
      }

      _formData['fotos'] = listaImagens;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tituloFocus.dispose();
    _descricaoFocus.dispose();
    _interessesFocus.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (_formData.isEmpty) {
  //     final arg = ModalRoute.of(context)?.settings.arguments;

  //     if (arg != null) {
  //       final anuncio = arg as Anuncio;
  //       _formData['idanuncio'] = anuncio.idanuncio;
  //       _formData['titulo'] = anuncio.titulo;
  //       _formData['descricao'] = anuncio.titulo;
  //       _formData['interesses'] = anuncio.interesses;
  //     }
  //   }
  // }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      // Auth auth = Provider.of<Auth>(context, listen: false);
      await Provider.of<configuracoesController>(context, listen: false)
          .cadastraAnuncio(_formData)
          .then((value) {
        setState(() => _isLoading = false);
      }); //consegue acessar o provider com listen
      //igual a false por estar fora do build
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.authOrHome,
      );
    } catch (error) {
      // print("${error} chegou aqui####################");
      // ignore: use_build_context_synchronously
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro'),
          content: const Text('Não foi possível salvar o produto'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context);
    final List<Categoria> categorias = provider.categorias;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Cadastro'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['titulo']?.toString(),
                      decoration: const InputDecoration(labelText: 'Nome'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_tituloFocus);
                      },
                      onSaved: (titulo) => _formData['titulo'] = titulo ?? '',
                      validator: (_titulo) {
                        //se retornar null no validator é pq foi com sucesso
                        final titulo = _titulo ?? '';
                        if (titulo.trim().isEmpty) {
                          return 'O titulo é obrigatório';
                        }
                        if (titulo.trim().length < 3) {
                          return 'Titulo precisa de no mínimo 3 letras';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['descricao']?.toString(),
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      focusNode: _descricaoFocus,
                      onFieldSubmitted: (_) {},
                      onSaved: (descricao) =>
                          _formData['descricao'] = descricao ?? '',
                      validator: (_descricao) {
                        //se retornar null no validator é pq foi com sucesso
                        final descricao = _descricao ?? '';
                        if (descricao.trim().isEmpty) {
                          return 'A descrição é obrigatória';
                        }
                        if (descricao.trim().length < 10) {
                          return 'Descrição precisa de no mínimo 10 letras';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                    TextFormField(
                      initialValue: _formData['interesses']?.toString(),
                      decoration:
                          const InputDecoration(labelText: 'Interesses'),
                      focusNode: _interessesFocus,
                      onFieldSubmitted: (_) {},
                      onSaved: (interesses) =>
                          _formData['interesses'] = interesses ?? '',
                      validator: (_interesses) {
                        //se retornar null no validator é pq foi com sucesso
                        final interesses = _interesses ?? '';
                        if (interesses.trim().isEmpty) {
                          return 'Os interesses são obrigatórios';
                        }
                        if (interesses.trim().length < 10) {
                          return 'Descrição precisa de no mínimo 10 letras';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    const Text('Categoria: '),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 252, 255, 254),
                      ),
                      focusNode: _categoriaFocus,
                      dropdownColor: const Color.fromARGB(255, 252, 255, 254),
                      onChanged: (Categoria? newValue) {
                        setState(() {
                          _formData['idcategoria'] =
                              newValue?.idcategoria as int;
                        });
                      },
                      items: categorias.map((Categoria categoria) {
                        return DropdownMenuItem<Categoria>(
                          value: categoria,
                          child: Text(
                            categoria.nome,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    ImageInput(_selectImage),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
      drawer: AppDrawer(),
    );
  }
}
