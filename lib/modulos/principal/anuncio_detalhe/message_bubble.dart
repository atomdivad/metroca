import 'package:flutter/material.dart';

import 'package:metroca/models/mensagem.dart';

class MessageBubble extends StatelessWidget {
  static const _defaultImage = 'assets/images/avatar.png';
  final Mensagem mensagem;
  final bool belongsToCurrentUser;

  const MessageBubble({
    super.key,
    required this.mensagem,
    required this.belongsToCurrentUser,
  });

  // Widget _showUserImage(String imageURL) {
  //   ImageProvider? provider;
  //   final uri = Uri.parse(imageURL);
  //   if (uri.path.contains(_defaultImage)) {
  //     provider = AssetImage(_defaultImage);
  //   } else if (uri.scheme.contains('http')) {
  //     provider = NetworkImage(uri.toString());
  //   } else {
  //     provider = FileImage(File(uri.toString()));
  //   }
  //   return CircleAvatar(
  //     backgroundImage: provider,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // um compnoente em cima do outro
      children: [
        Row(
          mainAxisAlignment: belongsToCurrentUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: belongsToCurrentUser
                      ? Colors.grey.shade300
                      : Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: belongsToCurrentUser
                        ? Radius.circular(12)
                        : Radius.circular(0),
                    bottomRight: belongsToCurrentUser
                        ? Radius.circular(0)
                        : Radius.circular(12),
                  ),
                ),
                width: 180,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 8,
                ),
                child: Column(
                  crossAxisAlignment: belongsToCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   mensagem.idconversa as String,
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       color: belongsToCurrentUser
                    //           ? Colors.black
                    //           : Colors.white),
                    // ),
                    Text(
                      mensagem.mensagem,
                      textAlign: belongsToCurrentUser
                          ? TextAlign.right
                          : TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: belongsToCurrentUser
                              ? Colors.black
                              : Colors.white),
                    ),
                  ],
                )),
          ],
        ),
        // Positioned(
        //   top: 0,
        //   left: belongsToCurrentUser ? null : 165,
        //   right: belongsToCurrentUser ? 165 : null,
        //   child: _showUserImage(mensagem.userImageURL),
        // ),
      ],
    );
  }
}
