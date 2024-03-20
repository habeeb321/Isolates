import 'dart:isolate';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  //runWithoutIsolates(5000000000);
                  useIsolates();
                },
                child: const Text('Check'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void useIsolates() async {
    final ReceivePort receivePort = ReceivePort();
    try {
      await Isolate.spawn(runWithIsolates, [receivePort.sendPort, 5000000000]);
    } catch (e) {
      print(e);
      receivePort.close();
    }
    final response = await receivePort.first;
    print('result is: $response');
  }

  int runWithIsolates(List<dynamic> args) {
    SendPort resultPort = args[0];
    int value = 0;
    for (var i = 0; i < args[1]; i++) {
      value = value + 1;
    }
    Isolate.exit(resultPort, value);
  }

  void runWithoutIsolates(int count) {
    int value = 0;
    for (var i = 0; i <= count; i++) {
      value = value + 1;
    }
    print(value);
  }
}
