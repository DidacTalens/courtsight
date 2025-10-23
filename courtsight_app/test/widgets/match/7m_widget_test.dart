import 'package:courtsight/models/accion.dart';
import 'package:courtsight/models/equipo.dart';
import 'package:courtsight/models/estadisticas.dart';
import 'package:courtsight/models/jugador.dart';
import 'package:courtsight/models/partido.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('US016 - Registro completo de 7 metros', () {
    late Equipo equipoLocal;
    late Equipo equipoVisitante;
    late Jugador porteroLocal;
    late Jugador porteroVisitante;
    late Jugador lanzadorLocal;
    late Jugador lanzadorVisitante;
    late Partido partido;

    setUp(() {
      porteroLocal = Jugador.create(nombre: 'Portero Local', dorsal: '1');
      porteroVisitante =
          Jugador.create(nombre: 'Portero Visitante', dorsal: '16');
      lanzadorLocal = Jugador.create(nombre: 'Lanzador Local', dorsal: '7');
      lanzadorVisitante =
          Jugador.create(nombre: 'Lanzador Visitante', dorsal: '10');

      equipoLocal = Equipo.create(
        nombre: 'Equipo Local',
        porteroActivoId: porteroLocal.id,
        roster: [porteroLocal, lanzadorLocal],
      );

      equipoVisitante = Equipo.create(
        nombre: 'Equipo Visitante',
        esLocal: false,
        porteroActivoId: porteroVisitante.id,
        roster: [porteroVisitante, lanzadorVisitante],
      );

      partido = Partido.create(
        equipoLocal: equipoLocal,
        equipoVisitante: equipoVisitante,
      ).copyWith(estado: EstadoPartido.enCurso);
    });

    test('agrega al historial la acción de 7 metros con datos correctos', () {
      final actualizado = partido.registrarSieteMetros(
        equipoPorteroId: equipoVisitante.id,
        porteroId: porteroVisitante.id,
        equipoLanzadorId: equipoLocal.id,
        lanzadorId: lanzadorLocal.id,
        esGol: true,
        amonestacion: false,
      );

      expect(actualizado.acciones, hasLength(1));
      final Accion accion = actualizado.acciones.single;
      expect(accion.tipo, AccionTipo.sieteMetros);
      expect(accion.resultado, 'Gol');
      expect(accion.amonestacion, isFalse);
      expect(accion.lanzadorId, lanzadorLocal.id);
      expect(accion.porteroId, porteroVisitante.id);
      expect(accion.descripcion, contains('7m'));
      expect(accion.descripcion, contains(equipoLocal.nombre));
      expect(accion.descripcion, contains(equipoVisitante.nombre));
    });

    test('actualiza estadísticas de lanzador y portero tras registrar gol', () {
      final actualizado = partido.registrarSieteMetros(
        equipoPorteroId: equipoVisitante.id,
        porteroId: porteroVisitante.id,
        equipoLanzadorId: equipoLocal.id,
        lanzadorId: lanzadorLocal.id,
        esGol: true,
        amonestacion: false,
      );

      final JugadorEstadisticas statsLanzador =
          actualizado.estadisticasJugadores[lanzadorLocal.id]!;
      final JugadorEstadisticas statsPortero =
          actualizado.estadisticasJugadores[porteroVisitante.id]!;

      expect(statsLanzador.lanzamientos, 1);
      expect(statsLanzador.goles, 1);
      expect(statsLanzador.amonestaciones, 0);
      expect(statsPortero.lanzamientos, 1);
      expect(statsPortero.goles, 0);
    });

    test('registra amonestación cuando corresponde', () {
      final actualizado = partido.registrarSieteMetros(
        equipoPorteroId: equipoVisitante.id,
        porteroId: porteroVisitante.id,
        equipoLanzadorId: equipoLocal.id,
        lanzadorId: lanzadorLocal.id,
        esGol: false,
        amonestacion: true,
      );

      final JugadorEstadisticas statsLanzador =
          actualizado.estadisticasJugadores[lanzadorLocal.id]!;

      expect(statsLanzador.lanzamientos, 1);
      expect(statsLanzador.goles, 0);
      expect(statsLanzador.amonestaciones, 1);
    });
  });
}
