import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courtsight/blocs/partido/partido_bloc.dart';
import 'package:courtsight/blocs/partido/partido_event.dart';
import 'package:courtsight/blocs/partido/partido_state.dart';
import 'package:courtsight/models/equipo.dart';
import 'package:courtsight/models/jugador.dart';
import 'package:courtsight/models/partido.dart';
import 'package:courtsight/models/parcial.dart';

void main() {
  late Partido partidoInicial;
  late Jugador porteroInicial;
  late Jugador porteroSuplente;

  Partido crearPartidoBase() {
    porteroInicial = Jugador.create(nombre: 'Portero 1', dorsal: '1');
    porteroSuplente = Jugador.create(nombre: 'Portero 2', dorsal: '12');

    final equipoLocal = Equipo(
      id: 'local',
      nombre: 'Equipo Local',
      colorUniforme: '#FF0000',
      colorPortero: '#00FF00',
      porteroActivoId: porteroInicial.id,
      esLocal: true,
      roster: [porteroInicial, porteroSuplente],
    );

    final equipoVisitante = Equipo(
      id: 'visitante',
      nombre: 'Equipo Visitante',
      colorUniforme: '#0000FF',
      colorPortero: '#FFFF00',
      porteroActivoId: porteroSuplente.id,
      esLocal: false,
      roster: [porteroSuplente],
    );

    return Partido(
      id: 'partido-1',
      fecha: DateTime(2024, 1, 1),
      equipoLocal: equipoLocal,
      equipoVisitante: equipoVisitante,
      estado: EstadoPartido.enCurso,
      duracionMinutos: 60,
      tiempoTranscurrido: 0,
      marcadorLocal: 0,
      marcadorVisitante: 0,
      parciales: [Parcial.create(minutoInicio: 0, minutoFin: 5)],
      equipoEnAtaque: equipoLocal.id,
      fechaCreacion: DateTime(2024, 1, 1),
      fechaFinalizacion: null,
    );
  }

  setUp(() {
    partidoInicial = crearPartidoBase();
  });

  test('estado inicial usa el partido proporcionado', () {
    final bloc = PartidoBloc(
      loadPartido: (_) async => partidoInicial,
      initialPartido: partidoInicial,
    );

    expect(bloc.state.status, PartidoStatus.enCurso);
    expect(bloc.state.partido, equals(partidoInicial));
  });

  blocTest<PartidoBloc, PartidoState>(
    'emite partido actualizado cuando PartidoCambioPortero es manejado',
    build: () => PartidoBloc(
      loadPartido: (_) async => partidoInicial,
      initialPartido: partidoInicial,
    ),
    act: (bloc) => bloc.add(
      PartidoCambioPortero(
        equipoId: partidoInicial.equipoLocal.id,
        nuevoPorteroId: porteroSuplente.id,
      ),
    ),
    expect: () {
      final partidoActualizado = partidoInicial.cambiarPortero(
        equipoId: partidoInicial.equipoLocal.id,
        nuevoPorteroId: porteroSuplente.id,
      );

      return [PartidoState.enCurso(partido: partidoActualizado)];
    },
    verify: (bloc) {
      final partido = bloc.state.partido;
      expect(partido, isNotNull);
      expect(partido!.equipoLocal.porteroActivoId, equals(porteroSuplente.id));
    },
  );
}
