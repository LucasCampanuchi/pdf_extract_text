import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;
  String text = 'Teste';
  List<TextLine> te = [];
  //;late File file;

  /* Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/pdf/Teste.pdf');
  } */

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        tempPath + '/file_01.tmp'; // file_01.tmp is dump file, can be anything
    return File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> _incrementCounter() async {
    ByteData a = await rootBundle.load('assets/pdf/rei-virus.pdf');
    var file = await writeToFile(a);

    final PdfDocument document = PdfDocument(
      inputBytes: file.readAsBytesSync(),
    );

    String t = PdfTextExtractor(document).extractText();

    final List<TextLine> textLine =
        PdfTextExtractor(document).extractTextLines();

    for (var item in textLine) {
      print(item.text);
    }

    document.dispose();

    setState(() {
      text = t;
      te = textLine;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(text.split('/n'));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* Text(
                file.path,
              ), */
              /* Image.asset(
                'assets/images/mosaic.png',
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.headline4,
              ), */
              Text(te.toString()),
              ...te.map((e) => Text(e.text))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
