import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courtsight/widgets/match/parciales_widget.dart';
import 'package:courtsight/models/models.dart';

void main() {
  group('ParcialesWidget - US002: Visualización de Parciales de 5 Minutos', () {
    late Partido partidoMock;
    late List<Parcial> parcialesMock;
    
    setUp(() {
      final equipoLocal = Equipo.create(
        nombre: 'Equipo Local',
        esLocal: true,
      );
      final equipoVisitante = Equipo.create(
        nombre: 'Equipo Visitante', 
        esLocal: false,
      );
      
      // Crear parciales de ejemplo según el scenario
      parcialesMock = [
        Parcial.create(
          minutoInicio: 0,
          minutoFin: 5,
          golesLocal: 2,
          golesVisitante: 1,
        ),
        Parcial.create(
          minutoInicio: 5,
          minutoFin: 10,
          golesLocal: 2,
          golesVisitante: 2,
        ),
        Parcial.create(
          minutoInicio: 10,
          minutoFin: 15,
          golesLocal: 1,
          golesVisitante: 1,
        ),
      ];
      
      partidoMock = Partido.create(
        equipoLocal: equipoLocal,
        equipoVisitante: equipoVisitante,
      ).copyWith(
        marcadorLocal: 5,
        marcadorVisitante: 4,
        tiempoTranscurrido: 720, // 12 minutos
        estado: EstadoPartido.enCurso,
        parciales: parcialesMock,
      );
    });

    testWidgets('debe mostrar todos los parciales de 5 minutos', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ParcialesWidget(partido: partidoMock),
          ),
        ),
      );

      expect(find.text('0-5\''), findsOneWidget);
      expect(find.text('5-10\''), findsOneWidget);
      expect(find.text('10-15\''), findsOneWidget);
    });

    testWidgets('debe mostrar los marcadores de cada parcial', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ParcialesWidget(partido: partidoMock),
          ),
        ),
      );

      expect(find.text('2-1'), findsOneWidget);
      expect(find.text('2-2'), findsOneWidget); 
      expect(find.text('1-1'), findsOneWidget);
    });

    testWidgets('debe mostrar el parcial actual destacado', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ParcialesWidget(partido: partidoMock),
          ),
        ),
      );

      final parcialActualFinder = find.text('10-15\'');
      expect(parcialActualFinder, findsOneWidget);
      
      final parcialActualWidget = tester.widget<Text>(parcialActualFinder);
      expect(parcialActualWidget.style?.fontWeight, FontWeight.bold);
    });
  });
}