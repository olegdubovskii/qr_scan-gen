import 'package:flutter/material.dart';
import 'package:qr_lab/pages/home.dart';
import 'package:qr_lab/pages/generator.dart';
import 'package:qr_lab/pages/scanner.dart';

void main() {
  runApp(MaterialApp(initialRoute: '/', routes: {
    '/': (context) => HomePage(),
    '/generator': (context) => GeneratorPage(),
    '/scanner': (context) => const QRViewExample(),
  }));
}