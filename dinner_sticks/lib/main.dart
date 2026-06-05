import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

/// Root widget — replaced in Phase 2 with ProviderScope + MaterialApp.
class App extends StatelessWidget {
  /// Creates the app.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Dinner Sticks')),
      ),
    );
  }
}
