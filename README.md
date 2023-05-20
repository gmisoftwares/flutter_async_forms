# Async Forms

A rewrite version of flutter form with async validation and submission.

A common problem with flutter built-in forms is that you can't use async functions in the validator and onSaved functions.
This might be a problem if you want to validate a field by making an http request or saving the form data to a database.

This package solves this problem by rewriting the form widget and its children to support async functions.

## Features

* AsyncForm: a rewrite version of flutter built-in Form widget.
* AsyncFormField: a rewrite version of flutter built-in FormField widget.
* AsyncTextFormField: a rewrite version of flutter built-in TextFormField widget.

## Getting started

Replace Form with AsyncForm, FormField with AsyncFormField, TextFormField with AsyncTextFormField.

If you are using Form like this:

```dart
Form(
    child: Column(
        children: [
        TextFormField(
            validator: (value) {
            // can't use async functions here :(
            },
            onSaved: (value) {
            // can't use async functions here :(
            },
        )
        ],
    ),
);
```

replace it with:

```dart
  AsyncForm(
    child: Column(
      children: [
        AsyncTextFormField(
          validator: (value) async {
            // can use async functions here :)
            // for example:
            final response =
                await http.get('https://example.com/validate?value=$value');
            if (response.statusCode == 200) {
              return null;
            } else {
              return 'invalid value';
            }
          },
          onSaved: (value) async {
            // can use async functions here :)
            // for example:
            final response = await http
                .post('https://example.com/save', body: {'value': value});
            if (response.statusCode != 200) {
              throw Exception('failed to save');
            }
          },
        ),
      ],
    ),
  );
```

* make sure that your validator and onSaved functions are async.

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:async_forms/async_forms.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test app',
      home: Scaffold(
        body: Center(
          child: AsyncForm(
            child: Column(
              children: [
                AsyncTextFormField(
                  validator: (value) async {
                    await Future.value(null); // await check
                    final String? error = value == 'test' ? null : 'demo error';
                    return error;
                  },
                  decoration: const InputDecoration(
                    labelText: 'test',
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      AsyncForm.maybeOf(context)
                          ?.validate(); // validate all fields in form
                    },
                    child: const Text('Submit'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

```

## Additional information

If you need to contact me, feel free.
