import 'dart:async';

import 'package:flutter/material.dart';

class CanvasApp extends StatefulWidget {
  const CanvasApp({super.key});

  @override
  State<CanvasApp> createState() => _CanvasAppState();
}

class _CanvasAppState extends State<CanvasApp> {
  late StreamController<int> _counterController;
  late Stream<int> _counterStream;
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    _counterController = StreamController<int>();
    _counterStream = _counterController.stream.asBroadcastStream();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _incrementCounter();
      // This is just to ensure the stream is set up after the first frame
      // You can remove this if you don't need it
      print("Stream initialized");
    });

    // getCounterStream().listen(
    //   (value) {
    //     _counter = value;
    //     print("Listened to stream: $value");
    //   },
    //   onDone: () {
    //     print("Stream closed");
    //   },
    //   onError: (error) {
    //     print("Error in stream: $error");
    //   },
    // );
  }

  void _incrementCounter() {
    for (int i = 0; i < 10; i++) {
      Future.delayed(const Duration(seconds: 1), () {
        print("Counter incremented to $_counter");
      });
      _counter++;
      _counterController.add(_counter);
    }
  }

  Stream<int> getCounterStream() async* {
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(seconds: 5));
      // if (i == 3) {
      //   throw Exception("Stream completed with error");
      // }

      print("logs: $i");
      yield i;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _counterController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canvas')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: _counterController.stream,
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    if (snapshot.hasData) {
                      return Text(
                        "Counter: ${snapshot.data}",
                        style: TextStyle(fontSize: 25),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                // Text("Counter $_counter", style: TextStyle(fontSize: 25)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _counterController.add(++_counter);
                  },
                  child: const Text(
                    "Increment Counter",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
