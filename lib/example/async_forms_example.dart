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
