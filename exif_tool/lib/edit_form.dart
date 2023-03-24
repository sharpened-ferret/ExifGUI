import 'package:flutter/material.dart';

class EditForm extends StatefulWidget {
    EditForm({Key? key, required this.exifJson}) : super(key: key) {
        exifJson.forEach((key, value) {
            formFields.add(
                TextFormField(
                    decoration: InputDecoration(
                        hintText: value.toString(),
                        labelText: key
                    ),
                )
            );
        });
    }

    final Map exifJson;
    final List<Widget> formFields = <Widget>[];

    @override
    EditFormState createState() {
        return EditFormState();
    }
}

class EditFormState extends State<EditForm> {
    final _formKey = GlobalKey<FormState>();

    @override
    Widget build(BuildContext context) {
        return Form(
            key: _formKey,
            child: Column(
                children: <Widget>[
                    Column(children: widget.formFields,),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                            onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("File Saved"))
                                    );
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