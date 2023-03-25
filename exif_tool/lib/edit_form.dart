import 'package:flutter/material.dart';
import 'dart:io';

class EditForm extends StatefulWidget {
    EditForm({Key? key, required this.exifJson, required this.filepath}) : super(key: key) {
        exifJson.forEach((key, value) {
            formFields.add(
                TextFormField(
                    decoration: InputDecoration(
                        hintText: value.toString(),
                        labelText: key
                    ),
                    onSaved: (val) {
                        if (val != null && val != "") {
                            saveField(key, val);
                        }
                    },
                )
            );
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

    void _saveFile() async {
        List<String> retArgs = <String>[];
        retArgs.add(widget.filepath);
        widget.formResults.forEach((key, value) {
            retArgs.add("-$key='$value'");
        });
        debugPrint("running exiftool with args=$retArgs");
        await Process.run('exiftool', retArgs).then((result){
            debugPrint(result.stdout);
        });
    }

    @override
    Widget build(BuildContext context) {
        return Form(
            key: _formKey,
            child: ListView(
                children: <Widget>[
                    Column(children: widget.formFields,),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                            onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("File Saved"))
                                    );
                                    _saveFile();
                                    //debugPrint("exiftool filename $retArgs");
                                }
                            },
                            child: const Text("Submit"),
                        ),
                    )
                ],
            ),
        );
    }
}