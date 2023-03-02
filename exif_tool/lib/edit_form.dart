import 'package:flutter/material.dart';

class EditForm extends StatefulWidget {
    const EditForm({super.key});

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
                    TextFormField(

                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                            onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Test"))
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