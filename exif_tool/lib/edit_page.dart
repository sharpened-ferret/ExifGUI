import 'package:exif_tool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'edit_form.dart';

class EditPage extends StatefulWidget {
  const EditPage(
      {Key? key,
      required this.title,
      required this.file,
      required this.filePath,
      required this.exifJson})
      : super(key: key);

  final String title;
  final File? file;
  final String filePath;
  final Map exifJson;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Current File:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.filePath),
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
                        shrinkWrap: true,
                        primary: false,
                        controller: controller,
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                    child: Image(
                                        image: getImageFromFile(widget.file)))
                              ]),
                          EditForm(
                              exifJson: widget.exifJson,
                              filepath: widget.filePath)
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
