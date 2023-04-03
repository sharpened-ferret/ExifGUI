import 'package:exif_tool/main.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

import 'utils/utils.dart';
import 'edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currFilePath = "None";
  File? _currFile;
  String _exifData = "";
  Map<String, dynamic> _exifJson = {};
  ScrollController controller = ScrollController();

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
        await Process.run('exiftool', ['-j', _currFilePath]).then((result) {
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
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () {
                  MyApp.of(context).changeTheme();
                },
                icon: Icon(MyApp.of(context).getTheme()
                    ? Icons.nightlight_round
                    : Icons.sunny))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,

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
                child: Scrollbar(
                    thickness: 8,
                    controller: controller,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: GridView.count(
                        scrollDirection: Axis.vertical,
                        controller: controller,
                        padding: const EdgeInsets.all(10),
                        primary: false,
                        shrinkWrap: false,
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        children: [
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Image(
                                    image: getImageFromFile(_currFile),
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              ]),
                          Scrollbar(
                              thickness: 20.0,
                              child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context)
                                      .copyWith(scrollbars: false),
                                  child: SingleChildScrollView(
                                    primary: true,
                                    child: Column(children: [
                                      _exifData != "" ? Text(
                                        "File Properties:",
                                        style: Theme.of(context).textTheme.headline5,
                                      ) : const Text(""),
                                      Text(generateExifDisplayString(
                                          _exifJson)),
                                    ]),
                                  )))
                          // Exif Data String
                        ],
                      ),
                    )),
              ),
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
                backgroundColor: Theme.of(context).indicatorColor,
                onPressed: _openFile,
                tooltip: 'Open File',
                child: const Icon(Icons.file_open),
              ),
              _currFile != null
                  ? FloatingActionButton(
                      heroTag: null,
                      backgroundColor: Theme.of(context).indicatorColor,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditPage(
                              title: 'Edit',
                              file: _currFile,
                              filePath: _currFilePath,
                              exifJson: _exifJson);
                        }));
                      },
                      tooltip: 'Edit',
                      child: const Icon(Icons.edit),
                    )
                  : const Text(""),
            ],
          ),
        ));
  }
}
