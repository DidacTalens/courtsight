import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courtsight/widgets/match/marcador_widget.dart';
import 'package:courtsight/models/models.dart';

void main() {
  group('MarcadorWidget - US001: Marcador y Tiempo Siempre Visibles', () {
    late Partido partidoMock;
    
    setUp(() {
      final equipoLocal = Equipo.create(
        nombre: 'Equipo Local',
        esLocal: true,
      );
      final equipoVisitante = Equipo.create(
        nombre: 'Equipo Visitante', 
        esLocal: false,
      );
      
      partidoMock = Partido.create(
        equipoLocal: equipoLocal,
        equipoVisitante: equipoVisitante,
      ).copyWith(
        marcadorLocal: 5,
        marcadorVisitante: 4,
        tiempoTranscurrido: 720, // 12 minutos
        estado: EstadoPartido.enCurso,
      );
    });

    testWidgets('debe mostrar el marcador con formato correcto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarcadorWidget(partido: partidoMock),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('-'), findsOneWidget);
    });

    testWidgets('debe mostrar el tiempo de juego formateado', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarcadorWidget(partido: partidoMock),
          ),
        ),
      );

      expect(find.text('12:00'), findsOneWidget);
    });

    testWidgets('debe mostrar los nombres de los equipos', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarcadorWidget(partido: partidoMock),
          ),
        ),
      );

      expect(find.text('Equipo Local'), findsOneWidget);
      expect(find.text('Equipo Visitante'), findsOneWidget);
    });

    testWidgets('debe tener texto grande y visible para el marcador', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MarcadorWidget(partido: partidoMock),
          ),
        ),
      );

      final marcadorLocalFinder = find.text('5');
      final marcadorLocalWidget = tester.widget<Text>(marcadorLocalFinder);
      
      expect(marcadorLocalWidget.style?.fontSize, greaterThanOrEqualTo(32.0));
    });
  });
}