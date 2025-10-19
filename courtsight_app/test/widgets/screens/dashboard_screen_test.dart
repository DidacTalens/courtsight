import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courtsight/screens/dashboard_screen.dart';

void main() {
  group('DashboardScreen - US006 Vista de pantalla correcta', () {
    testWidgets('usa tema oscuro y muestra cabecera correcta', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const DashboardScreen(),
        ),
      );

      expect(find.text('Estadísticas de Balonmano'), findsOneWidget);
    });

    testWidgets('muestra tarjetas de partidos con icono de estado y detalle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const DashboardScreen(),
        ),
      );

      expect(find.byKey(const Key('match-card-0')), findsOneWidget);
      expect(find.byKey(const Key('match-card-0-status-icon')), findsOneWidget);
      expect(find.byKey(const Key('match-card-0-title')), findsOneWidget);
      expect(find.byKey(const Key('match-card-0-details')), findsOneWidget);
    });

    testWidgets('el FAB navega hacia SetupScreen', (tester) async {
      String? rutaNavegada;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          routes: {
            '/': (_) => DashboardScreen(
                  onNavigateToSetup: (route) => rutaNavegada = route,
                ),
            DashboardScreen.setupRoute: (_) => const Placeholder(key: Key('setup-placeholder')),
          },
        ),
      );

      await tester.tap(find.byKey(const Key('dashboard-fab')));
      await tester.pumpAndSettle();

      expect(rutaNavegada, DashboardScreen.setupRoute);
    });
  });
}
