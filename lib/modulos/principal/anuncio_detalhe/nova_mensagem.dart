import 'package:flutter/material.dart';
import 'package:metroca/modulos/principal/controller/anuncioController.dart';

// https://www.freecodecamp.org/news/build-a-chat-app-ui-with-flutter/
//https://stackoverflow.com/questions/53919391/refresh-flutter-text-widget-content-every-5-minutes-or-periodically

typedef boolCallback = void Function(bool val);

class NovaMensagem extends StatefulWidget {
  int conversaId;
  int idAnuncio;
  final boolCallback callback;
  NovaMensagem(
      {super.key,
      required this.conversaId,
      required this.idAnuncio,
      required this.callback});

  @override
  State<NovaMensagem> createState() => _NovaMensagemState();
}

class _NovaMensagemState extends State<NovaMensagem> {
  String _message = '';
  String textoEnviarMensagem = "Enviar Mensagem...";
  final _messageController = TextEditingController();

  // Future<int> criaConversa() async {
  //   final auth = Provider.of<Auth>(context, listen: false);
  //   final resposta = await http.post(Uri.parse(Constants.criaConversa),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization': 'Bearer ${auth.token}',
  //       },
  //       body: jsonEncode({"anuncio_id": widget.idAnuncio}));
  //   if (resposta.body == 'null') return 0;
  //   final data = jsonDecode(resposta.body);
  //   return data['idconversa'];
  // }

  // Future<void> _sendMessage() async {
  //   final auth = Provider.of<Auth>(context, listen: false);
  //   int cId = await widget.conversaId;
  //   print("mensagem enviada ${cId}");
  //   if (cId == 0) {
  //     cId = await criaConversa();
  //   }
  //   final resposta =
  //       await http.post(Uri.parse(Constants().getEnviaMensagem(cId.toString())),
  //           headers: <String, String>{
  //             'Content-Type': 'application/json; charset=UTF-8',
  //             'Authorization': 'Bearer ${auth.token}',
  //           },
  //           body: jsonEncode({
  //             "mensagem": _message,
  //             "conversa_id": cId,
  //           }));

  //   if (resposta.body == 'null') return;
  //   _messageController.clear();
  // }

  Future<void> _sendMessage() async {
    // final auth = Provider.of<Auth>(context, listen: false);
    await AnuncioController()
        .salvaMensagem(context, widget.conversaId, _message, widget.idAnuncio);
    _messageController.clear();
    if (widget.conversaId == 0) {
      print("chamou callback");
      widget.callback(
          true); // para atualizar a ui foi necessario enviar um callback para o pai
      //informando que mudanças ocorreram
    }
  }

  void limpaTexto() {
    textoEnviarMensagem = '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: TextField(
            controller: _messageController,
            onChanged: (msg) => setState(() => _message = msg),
            onTap: limpaTexto,
            decoration: InputDecoration(
              labelText: textoEnviarMensagem,
              filled: true,
              fillColor: Colors.grey.shade300,
            ),
            onSubmitted: (_) {
              //tentar aqui
              if (_message.trim().isNotEmpty) {
                _sendMessage();
              }
            },
          ),
        ),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey.shade300,
          child: IconButton(
              onPressed: _message.trim().isEmpty ? null : _sendMessage,
              icon: Icon(Icons.send)),
        )
      ],
    );
  }
}
