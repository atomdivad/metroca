import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:metroca/exceptions/auth_exception.dart';
import 'package:metroca/models/login.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'usuario': '',
    'senha': '',
    'nome': '',
    'sobrenome': '',
    'cpf': '',
    'email': '',
  };

  AnimationController? _controller;

  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  bool _isLogin() => _authMode == AuthMode.Login;
  // bool _isSignup() => _authMode == AuthMode.Signup;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, //with SingleTickerProviderStateMixin {
      duration: const Duration(
        milliseconds: 300,
      ),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
        _controller?.forward();
      } else {
        _authMode = AuthMode.Login;
        _controller?.reverse();
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro'),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ]),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        //Login
        await auth.login(
          _authData['usuario']!,
          _authData['senha']!,
        );
      } else {
        //Registrar
        await auth.signup(
          _authData['usuario']!,
          _authData['senha']!,
          _authData['nome']!,
          _authData['sobrenome']!,
          _authData['cpf']!,
          _authData['email']!,
        ); // ! estará presente
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 320 : 600,
        // height: _heightAnimation?.value.height ?? (_isLogin() ? 320 : 400),
        width: deviceSize.width * 0.85,

        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Usuário',
                  errorStyle: const TextStyle(fontSize: 10),
                ),
                keyboardType: TextInputType.text,
                onSaved: (usuario) => _authData['usuario'] =
                    usuario ?? '', //caso seja nulo atribui vazio
                validator: (_usuario) {
                  final usuario = _usuario ?? '';
                  if (usuario.trim().isEmpty) {
                    return 'Informe um usuário';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  errorStyle: const TextStyle(fontSize: 10),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: _senhaController,
                onSaved: (senha) => _authData['senha'] = senha ?? '',
                validator: (_senha) {
                  final senha = _senha ?? '';
                  if (senha.isEmpty || senha.length < 5) {
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
              ),
              // if (_isSignup())
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 60,
                  maxHeight: _isLogin() ? 0 : 120,
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        errorStyle: const TextStyle(fontSize: 10),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      onSaved: (nome) => _authData['nome'] = nome ?? '',
                      validator: _isLogin()
                          ? null
                          : (_nome) {
                              final nome = _nome ?? '';
                              if (nome.length < 3) {
                                return '2 caracteres são o mínino para o campo nome';
                              }
                              return null;
                            },
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 60,
                  maxHeight: _isLogin() ? 0 : 120,
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Sobrenome',
                        errorStyle: const TextStyle(fontSize: 10),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      onSaved: (sobrenome) =>
                          _authData['sobrenome'] = sobrenome ?? '',
                      validator: _isLogin()
                          ? null
                          : (_sobrenome) {
                              final sobrenome = _sobrenome ?? '';
                              if (sobrenome.length < 3) {
                                return 'Necessário 2 digitos ou mais para sobrenome';
                              }
                              return null;
                            },
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 60,
                  maxHeight: _isLogin() ? 0 : 120,
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'CPF',
                        errorStyle: const TextStyle(fontSize: 10),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      onSaved: (cpf) => _authData['cpf'] = cpf ?? '',
                      validator: _isLogin()
                          ? null
                          : (_cpf) {
                              final cpf = _cpf ?? '';
                              if (cpf.length != 11) {
                                return 'Informar o cpf correto';
                              }
                              return null;
                            },
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 60,
                  maxHeight: _isLogin() ? 0 : 120,
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        errorStyle: const TextStyle(fontSize: 10),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (email) => _authData['email'] =
                          email ?? '', //caso seja nulo atribui vazio
                      validator: _isLogin()
                          ? null
                          : (_email) {
                              final email = _email ?? '';
                              if (email.trim().isEmpty ||
                                  !email.contains('@')) {
                                return 'Informe um e-mail válido';
                              }
                              return null;
                            },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                      _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR'),
                ),
              Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
