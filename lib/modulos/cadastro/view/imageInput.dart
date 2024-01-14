import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  const ImageInput(this.onSelectImage, {super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  List<File> _storedImages = [];
  final ImagePicker picker = ImagePicker();

  _fotoDaGaleria() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            _storedImages.add(File(xfilePick[i].path));
          }
          widget.onSelectImage(_storedImages);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nenhuma foto foi selecionada')));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 180,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 300.0,
                    child: _storedImages.isEmpty
                        ? const Center(child: Text('Nenhuma foto selecionada'))
                        : GridView.builder(
                            itemCount: _storedImages.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                  child: kIsWeb
                                      ? Image.network(_storedImages[index].path)
                                      : Image.file(_storedImages[index]));
                            },
                          ),
                  ),
                ),
              ],
            )),
        const SizedBox(width: 10),
        Expanded(
          child: TextButton.icon(
            onPressed: _fotoDaGaleria,
            icon: const Icon(Icons.folder),
            label: const Text(''),
          ),
        ),
      ],
    );
  }
}
