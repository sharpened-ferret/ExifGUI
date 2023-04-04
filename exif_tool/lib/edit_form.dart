import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'dart:io';
import 'map.dart';

class EditForm extends StatefulWidget {
  EditForm({Key? key, required this.exifJson, required this.filepath})
      : super(key: key) {

    exifJson.forEach((key, value) {
      formFields.add(TextFormField(
        decoration: InputDecoration(hintText: value.toString(), labelText: key),
        onSaved: (val) {
          if (val != null && val != "") {
            saveField(key, val);
          }
        },
      ));
    });
  }

  final Map exifJson;
  final String filepath;
  final List<Widget> formFields = <Widget>[];
  Map formResults = {};

  void saveField(String key, String value) {
    formResults[key] = value;
  }

  @override
  EditFormState createState() {
    return EditFormState();
  }
}

class EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();
  LatLng? location;

  void _saveFile() async {
    List<String> retArgs = <String>[];
    retArgs.add(widget.filepath);
    widget.formResults.forEach((key, value) {
      retArgs.add("-$key='$value'");
    });
    if (location != null) {
      retArgs.add("-GPSLatitude=${location?.latitude}");
      retArgs.add("-GPSLongitude=${location?.longitude}");
      if (location!.latitude > 0) {
        retArgs.add("-GPSLatitudeRef=N");
      } else {
        retArgs.add("-GPSLatitudeRef=S");
      }
      if (location!.longitude < 0) {
        retArgs.add("-GPSLongitudeRef=W");
      } else {
        retArgs.add("-GPSLongitudeRef=E");
      }
    }
    debugPrint("running exiftool with args=$retArgs");
    await Process.run('exiftool', retArgs).then((result) {
      debugPrint(result.stdout);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scrollbar(
          thickness: 20.0,
          child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView(
                primary: true,
                children: <Widget>[
                  ElevatedButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const MapPage(
                                  title: 'Select Image Location');
                            })).then((value) {
                              if (value != null) {
                                location = value;
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Location Set: ${value.latitude}, ${value.longitude}")));
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).indicatorColor,
                          ),
                          child: const Text("Set Image Location")),
                  Column(
                    children: widget.formFields,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("File Saved")));
                          _saveFile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).indicatorColor,
                      ),
                      child: const Text("Save"),
                    ),
                  )
                ],
              ))),
    );
  }
}
