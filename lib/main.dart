import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signature Pad',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  void _onSavePressed() async {
    if (_controller.isEmpty) return;
    final data = await _controller.toPngBytes();

    if (data == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Image.memory(data)),
          backgroundColor: Colors.grey,
        ),
      ),
    );
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: Signature(
                controller: _controller,
                backgroundColor: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.clear),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _controller.clear(),
                ),
                IconButton(
                  icon: const Icon(Icons.undo),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _controller.undo(),
                ),
                IconButton(
                  icon: const Icon(Icons.redo),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _controller.redo(),
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  color: Theme.of(context).primaryColor,
                  onPressed: _onSavePressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
