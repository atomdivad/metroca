import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:metroca/componentes/app_drawer.dart';
import 'package:metroca/data/store.dart';
import 'package:metroca/models/categoria.dart';
import 'package:metroca/models/login.dart';
import 'package:metroca/utils/app_routes.dart';
import 'package:provider/provider.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  double _currentSliderValue = 1;
  Categoria? categoria_detalhe;
  List<Categoria> categorias = [];
  // int? _idcategoria;
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};

  // Future<void> _submit() async {
  //   final auth = Provider.of<Auth>(context, listen: false);

  //   auth.atualizaRaio(_currentSliderValue.toInt());
  // }

  Future<void> _submitForm() async {
    _formKey.currentState?.save();

    try {
      final auth = Provider.of<Auth>(context, listen: false);

      await auth.atualizaRaio(_currentSliderValue.toInt());
      // print("Na hora de salvar ${categoria_detalhe?.nome}");
      // print("${auth.categoria}");
      // print("FORM: ${_formData['idcategoria'].toString()}");
      if (_formData['idcategoria'] != null) {
        // print("ENTROU AQUI?????@?@?@?@?@@?@?@");

        auth.salvaCategoria(
            _formData['idcategoria'].toString(), categoria_detalhe!);
      } else {
        auth.salvaCategoria(
            auth.categoria.idcategoria.toString(), categoria_detalhe!);
      }
      // auth.carregaCategoria();
      // categoria_detalhe = auth.categoria;
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.authOrHome,
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro'),
          content: const Text('Não foi possível salvar as configurações'),
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
    }
    // finally {
    //   setState(() => _isLoading = false);
    // }
  }

  Future<void> carregaDb() async {
    final userData = await Store.getMap(
      'userData',
    );

    if (userData['categoria_detalhe'] == null) {
      final auth = Provider.of<Auth>(context, listen: false);
      categoria_detalhe = auth.categoria;
    } else {
      categoria_detalhe = Categoria.fromJson(userData['categoria_detalhe']);
    }

    if (userData['raio'] != null) {
      int valor = userData['raio'];
      // print("VALOR $valor");
      _currentSliderValue = valor.toDouble();
    } else {
      _currentSliderValue = 20;
    }
  }

  @override
  void initState() {
    super.initState();

    Provider.of<Auth>(context, listen: false).listaCategorias().then((value) {
      carregaDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context);
    final List<Categoria> categorias = provider.categorias;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        actions: [
          IconButton(
            onPressed: () {
              _submitForm();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Slider(
                      value: _currentSliderValue,
                      min: 1.0,
                      max: 20.0,
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                    if (_currentSliderValue.toInt() == 1)
                      Text('${_currentSliderValue.toInt().toString()} km')
                    else
                      Text('${_currentSliderValue.toInt().toString()} kms'),
                    const SizedBox(height: 20),
                    const SizedBox(height: 10),
                    const Text('Categoria: '),
                    if (categorias.length != 0)
                      DropdownButtonFormField(
                        value: categorias[(categorias.indexWhere((ct) =>
                            ct.idcategoria == categoria_detalhe?.idcategoria))],
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 252, 255, 254),
                        ),
                        dropdownColor: const Color.fromARGB(255, 252, 255, 254),
                        onSaved: (Categoria? newValue) {
                          if (newValue != null) categoria_detalhe = newValue;
                        },
                        onChanged: (Categoria? newValue) {
                          setState(() {
                            _formData['idcategoria'] =
                                newValue?.idcategoria as int;
                          });
                        },
                        items: categorias.map((Categoria categoria) {
                          return DropdownMenuItem<Categoria>(
                            value: categoria,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                utf8.decode(categoria.nome.codeUnits),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
