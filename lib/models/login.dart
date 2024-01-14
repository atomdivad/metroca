import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:metroca/exceptions/auth_exception.dart';
import 'package:metroca/models/categoria.dart';
import '../data/store.dart';
import 'package:geolocator/geolocator.dart';
import 'package:metroca/utils/constants.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _usuario;
  DateTime? _expireDate;
  Timer? _logoutTimer;
  int _raio = 20;
  int _idcategoria = 0;
  List<Categoria> _categorias = [];
  Categoria _categoria_detalhe = Categoria(
      idcategoria: 0,
      nome: 'Todas as categorias',
      descricao: 'Listar todas as categorias');

  bool get isAuth {
    final isValid = _expireDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get usuario {
    return isAuth ? _usuario : null;
  }

  int? get raio {
    return _raio;
  }

  Categoria get categoria {
    return _categoria_detalhe;
  }

  int get idcategoria {
    return _idcategoria;
  }

  List<Categoria> get categorias {
    return [..._categorias];
  }

  int get contaCategorias {
    return _categorias.length;
  }

  Future<void> _authenticate(String usuario, String senha) async {
    const url = Constants.loginUrl;

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'usuario': usuario,
        'senha': senha,
      }),
    );
    final body = jsonDecode(response.body);
    print(body['access_token']);

    if (body['access_token'] == null) {
      throw AuthException('INVALID_PASSWORD');
    } else {
      _token = body['access_token'];
      _usuario = usuario;

      _expireDate = DateTime.now().add(
        const Duration(
          minutes: 43800, //1 mês
        ),
      );
      Store.saveMap('userData', {
        'token': _token,
        'usuario': usuario,
        'expireDate': _expireDate!.toIso8601String(),
        'raio': _raio,
        'idcategoria': 0,
      });
      _categoria_detalhe = Categoria(
          idcategoria: 0,
          nome: 'Todas as categorias',
          descricao: 'Listar todas as categorias');
      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> retornaUser() async {
    if (isAuth) return;

    final userData = await Store.getMap(
      'userData',
    );

    if (userData.isEmpty) return;

    final expireDate = DateTime.parse(userData['expireDate']);

    if (expireDate.isBefore(DateTime.now())) return;

    _usuario = userData['usuario'];
    _token = userData['token'];
    _expireDate = expireDate;
    _raio = 20; //valor default inicial
    _idcategoria = userData['idcategoria'];
    _categoria_detalhe = Categoria.fromJson(
        userData['categoria_detalhe']); //sempre checar se falhar
    _autoLogout();
  }

  Future<void> atualizaRaio(int raio) async {
    // if (isAuth) return;
    // print("VEIO AQUI???");
    final userData = await Store.getMap(
      'userData',
    );

    if (userData.isEmpty) return;

    final expireDate = DateTime.parse(userData['expireDate']);

    if (expireDate.isBefore(DateTime.now())) return;

    _raio = raio;

    // print(_raio);
    Store.saveMap('userData', {
      'token': _token,
      'usuario': usuario,
      'expireDate': _expireDate!.toIso8601String(),
      'raio': _raio,
      'idcategoria': _idcategoria,
    });
    _autoLogout();
    notifyListeners();
  }

  Future<void> atualizaLocalizacao() async {
    final userData = await Store.getMap(
      'userData',
    );

    if (userData.isEmpty) return;

    final expireDate = DateTime.parse(userData['expireDate']);

    if (expireDate.isBefore(DateTime.now())) return;

    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      final response = await http.put(
        Uri.parse(Constants.cadastroUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userData['token']}',
        },
        body: jsonEncode({
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
        }),
      );
      final body = jsonDecode(response.body);
      print(body);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> salvaCategoria(String categoria, Categoria detalhe) async {
    final userData = await Store.getMap(
      'userData',
    );

    if (userData.isEmpty) return;
    // print("DETALHA TOJSON ${detalhe.toJson()}");
    final expireDate = DateTime.parse(userData['expireDate']);

    if (expireDate.isBefore(DateTime.now())) return;

    _idcategoria = categoria.isEmpty ? 0 : int.parse(categoria);

    // print("salvando categoria ${detalhe.toJson()}");
    // print("categoria: $categoria");
    Store.saveMap('userData', {
      'token': _token,
      'usuario': usuario,
      'expireDate': _expireDate!.toIso8601String(),
      'raio': _raio,
      'idcategoria': _idcategoria,
      'categoria_detalhe': detalhe,
    });
    _categoria_detalhe = detalhe;
    _autoLogout();
    notifyListeners();
  }

  Future<void> inicializa() async {
    final userData = await Store.getMap(
      'userData',
    );

    if (userData.isEmpty) return;

    final expireDate = DateTime.parse(userData['expireDate']);

    if (expireDate.isBefore(DateTime.now())) return;
    // print("categoria: ${userData['idcategoria']}");
    // print("categoria categoria_detalhe: ${userData['categoria_detalhe']}");

    if (userData['categoria_detalhe'] != null) {
      _categoria_detalhe = Categoria.fromJson(userData['categoria_detalhe']);
    }
    if (userData['idcategoria'] != null) {
      _idcategoria = userData['idcategoria'];
    } else {
      _idcategoria = _categoria_detalhe.idcategoria;
    }
    if (userData['raio'] != null) {
      _raio = userData['raio'];
    }
    _autoLogout();
    // notifyListeners();
  }

  Future<void> listaCategorias() async {
    _categorias.clear();
    final resposta = await http.get(
      Uri.parse(Constants.listCategorias),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
    );
    final data = jsonDecode(resposta.body);
    // print(data);
    _categorias.add(Categoria(
        idcategoria: 0,
        nome: 'Todas as categorias',
        descricao: 'Listar todas as categorias'));
    data.forEach((dadosCategoria) {
      _categorias.add(Categoria(
          idcategoria: dadosCategoria['idcategoria'],
          nome: dadosCategoria['nome'],
          descricao: dadosCategoria['descricao']));
    });

    notifyListeners();
  }

  Future<void> verificaStatusToken() async {
    /*
    * Lê o token salvo no armazenamento local e compara com o endpoint
    * {"detail": "active"} o token está ok
    * {"detail": "Invalida auth credetials"} o token expirou
    * uma alternativa, mas por hora utilizar expireDate 
    */
    // final userData = await Store.getMap(
    //   'userData',
    // );
    // if (userData.isEmpty) return;
    // _token = userData['token'];

    // final resposta = await http.get(
    //   Uri.parse(Constants.tokenStatus),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //     'Authorization': 'Bearer $_token',
    //   },
    // );
    // final token_message = jsonDecode(resposta.body);
    // if (token_message['detail'] == 'Invalid auth credentials') logout();

    // if (isAuth) return;

    // notifyListeners();

    if (isAuth) return;

    final userData = await Store.getMap(
      'userData',
    );

    if (userData.isEmpty) return;

    final expireDate = DateTime.parse(userData['expireDate']);

    if (expireDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _usuario = userData['usuario'];
    _expireDate = expireDate;

    _autoLogout();
    notifyListeners();
  }

  Future<void> signup(
    String usuario,
    String senha,
    String nome,
    String sobrenome,
    String cpf,
    String email,
  ) async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      final response = await http.post(
        Uri.parse(Constants.cadastroUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'usuario': usuario,
          'email': email,
          'senha': senha,
          'nome': nome,
          'sobrenome': sobrenome,
          'cpf': cpf,
          'latitude': position.latitude,
          'longitude': position.longitude,
        }),
      );
      final body = jsonDecode(response.body);
      return _authenticate(usuario, senha);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    // https://pub.dev/packages/geolocator
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("disabled");
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("denied");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print(
          "Location permissions are permanently denied, we cannot request permissions.");
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      print(position.longitude);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> login(String usuario, String senha) async {
    return _authenticate(usuario, senha);
  }

  void logout() {
    _token = null;
    _expireDate = null;
    Store.remove(
      'userData',
    ).then((_) {
      notifyListeners();
    });
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expireDate?.difference(DateTime.now()).inMinutes;
    // print("Tempo para logout $timeToLogout"); //em minutos
    _logoutTimer = Timer(Duration(seconds: timeToLogout ?? 0), logout);
  }
}
