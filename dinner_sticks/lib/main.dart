import 'package:dinner_sticks/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Entry point.
void main() {
  runApp(const ProviderScope(child: App()));
}

/// Root widget — wraps the Material app in Riverpod's [ProviderScope].
class App extends StatelessWidget {
  /// Creates the app.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dinner Sticks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
