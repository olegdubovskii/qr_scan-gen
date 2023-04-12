import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR generator/scanner")),
      body: Center(
        child: Container(
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage('assets/images/flutter.png'),
          //         fit: BoxFit.cover)),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    dynamic result = await Navigator.pushNamed(
                        context, '/generator',
                        arguments: {});
                  },
                  child: Container(
                    child: Center(
                        child: const Text(
                      "Generator",
                      style: TextStyle(fontSize: 30),
                    )),
                    height: 60,
                    width: 200,
                  )),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    dynamic result = await Navigator.pushNamed(
                        context, '/scanner',
                        arguments: {});
                  },
                  child: Container(
                    child: Center(
                      child: const Text(
                        "Scanner",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    height: 60,
                    width: 200,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}