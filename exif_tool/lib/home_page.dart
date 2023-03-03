import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

import 'utils.dart';
import 'edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currFilePath = "None";
  File? _currFile;
  String _exifData = "";
  Map<String, dynamic> _exifJson = {};

  void _openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String? temp = result.files.single.path;
      if (temp != null) {
        setState(() {
          File file = File(temp);
          _currFilePath = file.path;
          _currFile = file;
          debugPrint('Filepath: $_currFilePath');
        });
        await Process.run('exiftool', ['-j', _currFilePath]).then((result){
          setState(() {
            _currFile = _currFile;
            _exifData = result.stdout;
            _exifData = _exifData.substring(1, _exifData.length - 3);
            _exifJson = jsonDecode(_exifData);
            stdout.write('ExifData:\n$_exifData');
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Current File:',
                style: TextStyle(fontWeight: FontWeight.bold),

              ),
              Text(
                _currFilePath,
              ),
              const Divider(),
              Expanded(
                  child: GridView.count(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Flexible(child: Image(image: getImageFromFile(_currFile)))]
                      ),
                      Text(generateExifDisplayString(_exifJson)), // Exif Data String
                    ],
                  )),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                heroTag: null,
                onPressed: _openFile,
                tooltip: 'Open File',
                child: const Icon(Icons.file_open),
              ),
              FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EditPage(title: 'Edit', file: _currFile, filePath: _currFilePath, exifJson: _exifJson);
                  }));
                },
                tooltip: 'Edit',
                child: const Icon(Icons.edit),
              ),
            ],
          ),
        )

    );
  }
}