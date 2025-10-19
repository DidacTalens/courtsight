import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courtsight/blocs/dashboard/dashboard_bloc.dart';
import 'package:courtsight/blocs/dashboard/dashboard_event.dart';
import 'package:courtsight/blocs/dashboard/dashboard_state.dart';
import 'package:courtsight/models/models.dart';

void main() {
  group('DashboardBloc - US003 Listado Completo y Navegación', () {
    late List<Partido> partidosMock;

    setUp(() {
      final equipoLocal = Equipo.create(nombre: 'Equipo Local');
      final equipoVisitante = Equipo.create(nombre: 'Equipo Visitante', esLocal: false);

      partidosMock = [
        Partido.create(
          equipoLocal: equipoLocal,
          equipoVisitante: equipoVisitante,
        ),
      ];
    });

    blocTest<DashboardBloc, DashboardState>(
      'emite [cargando, cargado] cuando se cargan partidos correctamente',
      build: () => DashboardBloc(
        partidosProvider: () async => partidosMock,
        onPartidoSeleccionado: (_) {},
      ),
      act: (bloc) => bloc.add(const DashboardLoadRequested()),
      expect: () => [
        const DashboardState.cargando(),
        DashboardState.cargado(partidos: partidosMock),
      ],
    );

    blocTest<DashboardBloc, DashboardState>(
      'emite [cargando, fallo] cuando ocurre un error al cargar partidos',
      build: () => DashboardBloc(
        partidosProvider: () async => throw Exception('Error al cargar'),
        onPartidoSeleccionado: (_) {},
      ),
      act: (bloc) => bloc.add(const DashboardLoadRequested()),
      expect: () => [
        const DashboardState.cargando(),
        const DashboardState.fallo(mensaje: 'Error al cargar partidos'),
      ],
    );

    String? partidoSeleccionado;

    blocTest<DashboardBloc, DashboardState>(
      'invoca onPartidoSeleccionado cuando se selecciona un partido',
      build: () {
        partidoSeleccionado = null;
        return DashboardBloc(
          partidosProvider: () async => partidosMock,
          onPartidoSeleccionado: (id) => partidoSeleccionado = id,
        );
      },
      act: (bloc) async {
        bloc.add(const DashboardLoadRequested());
        await Future.delayed(Duration.zero);
        bloc.add(DashboardPartidoSeleccionado(partidosMock.first.id));
      },
      verify: (_) {
        expect(partidoSeleccionado, equals(partidosMock.first.id));
      },
    );
  });
}
