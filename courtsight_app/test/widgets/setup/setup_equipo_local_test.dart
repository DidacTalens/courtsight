import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courtsight/screens/setup_screen.dart';

void main() {
  group('SetupScreen - US005 Gestión del Equipo Local', () {
    testWidgets('muestra botón "Editar Equipo Local"', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SetupScreen()));

      expect(find.text('Editar Equipo Local'), findsOneWidget);
    });

    testWidgets('permite modificar el nombre del equipo local', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SetupScreen()));

      await tester.tap(find.text('Editar Equipo Local'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('input-nombre-equipo')), 'Atlético Local');
      await tester.pump();

      expect(find.text('Atlético Local'), findsWidgets);
    });

    testWidgets('permite modificar dorsales de jugadores locales', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SetupScreen()));

      await tester.tap(find.text('Editar Equipo Local'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('input-jugador-0-nombre')), 'Portero');
      await tester.enterText(find.byKey(const Key('input-jugador-0-dorsal')), '12');
      await tester.pump();

      expect(find.text('Portero'), findsWidgets);
      expect(find.text('12'), findsWidgets);
    });
  });
}
