import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courtsight/screens/setup_screen.dart';
import 'package:courtsight/screens/match_screen.dart';

void main() {
  group('SetupScreen - Gestión del Equipo Local', () {
    testWidgets('muestra secciones básicas y botón de inicio deshabilitado',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SetupScreen()));

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'Equipo Local',
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == 'Equipo Visitante',
        ),
        findsOneWidget,
      );

      final ElevatedButton botonInicio = tester.widget(
        find.widgetWithText(ElevatedButton, 'Iniciar Partido'),
      );
      expect(botonInicio.onPressed, isNull);
    });

    testWidgets('permite modificar el nombre del equipo local', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SetupScreen()));

      await tester.enterText(
        find.byKey(const Key('input-equipo-local-nombre')),
        'Atlético Local',
      );
      await tester.pump();

      expect(find.text('Atlético Local'), findsWidgets);
    });

    testWidgets('permite completar roster local y visitante y activa el botón',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SetupScreen()));

      await tester.enterText(
        find.byKey(const Key('input-equipo-local-nombre')),
        'HB Flow Local',
      );
      await tester.enterText(
        find.byKey(const Key('input-jugador-0-nombre')),
        'Portero Local',
      );
      await tester.enterText(
        find.byKey(const Key('input-jugador-0-dorsal')),
        '1',
      );

      await tester.enterText(
        find.byKey(const Key('input-equipo-visitante-nombre')),
        'HB Flow Visitante',
      );
      await tester.enterText(
        find.byKey(const Key('input-visitante-jugador-0-nombre')),
        'Portero Visitante',
      );
      await tester.enterText(
        find.byKey(const Key('input-visitante-jugador-0-dorsal')),
        '12',
      );
      await tester.pump();

      final ElevatedButton botonInicio = tester.widget(
        find.widgetWithText(ElevatedButton, 'Iniciar Partido'),
      );
      expect(botonInicio.onPressed, isNotNull);
    });

    testWidgets('permite seleccionar color de uniforme local', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SetupScreen()));

      final CamisetaCortaIcon iconoInicial = tester.widget(
        find.byKey(const ValueKey('icon-local-jugador')),
      );

      await tester.tap(
        find.byKey(const ValueKey('color-picker-local-jugadores')),
      );
      await tester.pumpAndSettle();

      final blockPickerFinder = find.byType(BlockPicker);
      expect(blockPickerFinder, findsOneWidget);

      final BlockPicker blockPicker = tester.widget(blockPickerFinder);
      final Color nuevoColor = blockPicker.availableColors
          .firstWhere((color) => color != iconoInicial.color);
      blockPicker.onColorChanged(nuevoColor);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Guardar'));
      await tester.pumpAndSettle();

      final CamisetaCortaIcon iconoActualizado = tester.widget(
        find.byKey(const ValueKey('icon-local-jugador')),
      );

      expect(iconoActualizado.color, equals(nuevoColor));
    });

    testWidgets('registra jugadores y dorsales en el partido generado',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SetupScreen()));

      // Datos equipo local
      await tester.enterText(
        find.byKey(const Key('input-equipo-local-nombre')),
        'HB Flow Local',
      );
      await tester.enterText(
        find.byKey(const Key('input-jugador-0-nombre')),
        'Portero Local',
      );
      await tester.enterText(
        find.byKey(const Key('input-jugador-0-dorsal')),
        '1',
      );

      // Datos equipo visitante
      await tester.enterText(
        find.byKey(const Key('input-equipo-visitante-nombre')),
        'HB Flow Visitante',
      );
      await tester.enterText(
        find.byKey(const Key('input-visitante-jugador-0-nombre')),
        'Extremo Visitante',
      );
      await tester.enterText(
        find.byKey(const Key('input-visitante-jugador-0-dorsal')),
        '9',
      );

      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Iniciar Partido'));
      await tester.pumpAndSettle();

      final matchViewFinder = find.byType(MatchView);
      expect(matchViewFinder, findsOneWidget);

      final MatchView matchView = tester.widget(matchViewFinder);
      final partido = matchView.partido;

      expect(partido.equipoLocal.roster, isNotEmpty);
      expect(partido.equipoVisitante.roster, isNotEmpty);

      final jugadorLocal = partido.equipoLocal.roster.first;
      final jugadorVisitante = partido.equipoVisitante.roster.first;

      expect(jugadorLocal.nombre, equals('Portero Local'));
      expect(jugadorLocal.dorsal, equals('1'));
      expect(jugadorVisitante.nombre, equals('Extremo Visitante'));
      expect(jugadorVisitante.dorsal, equals('9'));
    });
  });
}
