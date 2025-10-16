import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courtsight/screens/dashboard_screen.dart';

void main() {
  group('DashboardScreen - US004 Creación Rápida de partido', () {
    testWidgets('muestra un FloatingActionButton con ícono de añadir', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));

      final fabFinder = find.byType(FloatingActionButton);
      final iconFinder = find.byIcon(Icons.add);

      expect(fabFinder, findsOneWidget);
      expect(iconFinder, findsOneWidget);
    });

    testWidgets('al pulsar el FAB navega a la pantalla de preparación', (tester) async {
      await tester.pumpWidget(MaterialApp(
        routes: {
          '/': (_) => const DashboardScreen(),
          '/setup': (_) => const Placeholder(key: Key('setup-screen')),
        },
      ));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('setup-screen')), findsOneWidget);
    });
  });
}
