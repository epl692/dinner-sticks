import 'package:dinner_sticks/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test — home screen renders without crash',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: App()),
    );
    // Before async providers resolve, a loading indicator is shown.
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });
}
