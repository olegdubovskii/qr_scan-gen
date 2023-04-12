import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_image_generator/qr_image_generator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class GeneratorPage extends StatefulWidget {
  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  File? _file;
  String? _localPath;
  var TextInputDataController = TextEditingController();
  var TextInputNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    TextInputDataController.addListener(() {
      setState(() {});
    });
    TextInputNameController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR generator")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: TextField(
              controller: TextInputDataController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.input),
                  iconColor: Colors.grey,
                  labelText: "Input of encoded data"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: TextField(
              controller: TextInputNameController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.input),
                  iconColor: Colors.grey,
                  labelText: "Input qr code name"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              flex: 10,
              child: _file == null
                  ? const Image(image: AssetImage('assets/images/no-image.jpg'))
                  : InkWell(
                      child: Image.file(File(_file!.path)),
                      onLongPress: () async {
                        await Clipboard.setData(
                            ClipboardData(text: _localPath));
                      },
                    )),
          const SizedBox(height: 10),
          SizedBox(
              height: 40,
              width: 120,
              child: ElevatedButton(
                child: const Text("Geneate"),
                onPressed: TextInputDataController.text == '' ||
                        TextInputNameController.text == ''
                    ? null
                    : () async {
                        await saveQRImage(TextInputDataController.text,
                            TextInputNameController.text);
                        setState(() {
                          TextInputDataController.text = '';
                          TextInputNameController.text = '';
                        });
                      },
              )),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Future saveQRImage(String data, String fileName) async {
    FocusScope.of(context).unfocus();
    String? fileDirectory = await FilePicker.platform.getDirectoryPath();
    String? filePath =
        fileDirectory.toString() + '/' + fileName.toString() + '.png';

    if (filePath == null) {
      return;
    }

    final file = File(filePath);
    final generator = QRGenerator();

    await generator.generate(
      data: data,
      filePath: filePath,
      scale: 10,
      padding: 2,
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      errorCorrectionLevel: ErrorCorrectionLevel.medium,
    );
    setState(() {
      this._localPath = filePath;
      this._file = file;
    });
  }
}