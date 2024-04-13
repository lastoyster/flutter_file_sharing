import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  final String text =
      'Flutter is a framework to build cross-platform applications. https://www.flutter.dev';
  final String imageAsset = 'assets/image.png';
  final String imageNetwork =
      'https://www.mindinventory.com/blog/wp-content/uploads/2022/10/flutter-3.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Sharing"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildShareButton('Share Text & Link', () {
              Share.share(text);
            }, Colors.blue),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Share Image from Asset',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final ByteData image = await rootBundle.load(imageAsset);
                      final Uint8List buffer = image.buffer.asUint8List();
                      Share.shareFiles(
                        [Uint8List.fromList(buffer)],
                        text: 'Flutter Logo',
                        subject: 'Flutter Logo',
                      );
                    },
                    child: Image.asset(
                      imageAsset,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildShareButton('Share Image from Network', () async {
              final http.Response response =
                  await http.get(Uri.parse(imageNetwork));
              Share.shareFiles(
                [Uint8List.fromList(response.bodyBytes)],
                text: 'Flutter 3',
                subject: 'Flutter 3',
              );
            }, Colors.orange),
            const SizedBox(height: 20),
            _buildShareButton('Share Image from Image Picker', () async {
              final XFile? imagePicker =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (imagePicker != null) {
                final Uint8List uint8List = await imagePicker.readAsBytes();
                Share.shareFiles(
                  [uint8List],
                  text: 'Image Gallery',
                  subject: 'Image Gallery',
                );
              }
            }, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton(
      String title, void Function() onPressed, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
