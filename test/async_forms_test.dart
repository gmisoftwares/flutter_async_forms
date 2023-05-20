import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:async_forms/async_forms.dart';

void main() {
  testWidgets('AsyncFormScope maybe of', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        title: 'test app',
        home: Scaffold(
          body: AsyncForm(
            child: Column(children: [
              AsyncTextFormField(
                decoration: const InputDecoration(
                  labelText: 'test',
                ),
              ),
            ]),
          ),
        ),
      ),
    );
    await widgetTester.pumpAndSettle();
    final textFeild = find.text('test');
    expect(
        AsyncForm.maybeOf(
            widgetTester.element(find.byType(AsyncTextFormField))),
        isNotNull);
    expect(textFeild, findsOneWidget);
  });
  testWidgets(
    'async on validation',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        MaterialApp(
          title: 'test app',
          home: Scaffold(
            body: AsyncForm(
              child: Column(children: [
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
              ]),
            ),
          ),
        ),
      );
      await widgetTester.pumpAndSettle();
      final textFeild = find.byType(AsyncTextFormField);
      expect(textFeild, findsOneWidget);
      await widgetTester.enterText(textFeild, 'not test');
      final bool? isNotvalid = await AsyncForm.maybeOf(
              widgetTester.element(find.byType(AsyncTextFormField)))
          ?.validate();
      expect(isNotvalid, isFalse);
      await widgetTester.pumpAndSettle();
      expect(find.text('demo error'), findsOneWidget);
      await widgetTester.enterText(textFeild, 'test');
      final bool? isvalid = await AsyncForm.maybeOf(
              widgetTester.element(find.byType(AsyncTextFormField)))
          ?.validate();
      expect(isvalid, isTrue);
      await widgetTester.pumpAndSettle();
      expect(find.text('demo error'), findsNothing);
    },
  );
  testWidgets('saved on async form', (widgetTester) async {
    String? value;
    await widgetTester.pumpWidget(
      MaterialApp(
        title: 'test app',
        home: Scaffold(
          body: AsyncForm(
            child: Column(children: [
              AsyncTextFormField(
                onSaved: (newValue) async {
                  await Future.value(null); // await check
                  value = newValue;
                },
                decoration: const InputDecoration(
                  labelText: 'test',
                ),
              ),
            ]),
          ),
        ),
      ),
    );
    await widgetTester.pumpAndSettle();
    final textFeild = find.byType(AsyncTextFormField);
    expect(textFeild, findsOneWidget);
    await widgetTester.enterText(textFeild, 'test');
    await AsyncForm.maybeOf(
            widgetTester.element(find.byType(AsyncTextFormField)))
        ?.save();
    expect(value, 'test');
  });
}
