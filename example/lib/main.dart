import 'package:flutter/material.dart';
import 'login_form_example.dart';
import 'async_validation_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Shield Examples',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ExampleSelector(),
    );
  }
}

class ExampleSelector extends StatelessWidget {
  const ExampleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Shield Examples')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginFormExample(),
                  ),
                );
              },
              child: const Text('Basic Form Example'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AsyncValidationExample(),
                  ),
                );
              },
              child: const Text('Async Validation Example'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
