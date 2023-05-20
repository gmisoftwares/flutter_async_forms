import 'package:flutter/material.dart';
import 'package:async_forms/async_forms.dart';

void main() {
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  final formKey = GlobalKey<AsyncFormState>();
  ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test app',
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AsyncForm(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AsyncTextFormField(
                  validator: (value) async {
                    await Future.delayed(const Duration(seconds: 1)); // await
                    final String? error = value == 'test' ? null : 'demo error';
                    return error;
                  },
                  decoration: const InputDecoration(
                    labelText: 'test',
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      formKey.currentState
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
