import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courtsight/blocs/setup/setup_bloc.dart';
import 'package:courtsight/blocs/setup/setup_event.dart';
import 'package:courtsight/blocs/setup/setup_state.dart';

void main() {
  group('SetupBloc - US007 Configuración de Nombres y Colores de Uniforme', () {
    blocTest<SetupBloc, SetupState>(
      'actualiza nombre del equipo local',
      build: SetupBloc.new,
      act: (bloc) => bloc.add(const SetupTeamNameChanged(team: SetupTeam.local, nombre: 'HB Flow Local')),
      expect: () => [
        isA<SetupState>().having(
          (state) => state.equipoLocal.nombre,
          'equipoLocal.nombre',
          'HB Flow Local',
        ),
      ],
    );

    blocTest<SetupBloc, SetupState>(
      'actualiza nombre del equipo visitante',
      build: SetupBloc.new,
      act: (bloc) => bloc.add(const SetupTeamNameChanged(team: SetupTeam.visitante, nombre: 'HB Flow Visitante')),
      expect: () => [
        isA<SetupState>().having(
          (state) => state.equipoVisitante.nombre,
          'equipoVisitante.nombre',
          'HB Flow Visitante',
        ),
      ],
    );

    blocTest<SetupBloc, SetupState>(
      'actualiza color de jugadores del equipo local',
      build: SetupBloc.new,
      act: (bloc) => bloc.add(const SetupTeamColorChanged(
        team: SetupTeam.local,
        slot: UniformSlot.jugadores,
        hexColor: '#123456',
      )),
      expect: () => [
        isA<SetupState>().having(
          (state) => state.equipoLocal.colorUniforme,
          'equipoLocal.colorUniforme',
          '#123456',
        ),
      ],
    );

    blocTest<SetupBloc, SetupState>(
      'actualiza color del portero del equipo visitante',
      build: SetupBloc.new,
      act: (bloc) => bloc.add(const SetupTeamColorChanged(
        team: SetupTeam.visitante,
        slot: UniformSlot.portero,
        hexColor: '#ABCDEF',
      )),
      expect: () => [
        isA<SetupState>().having(
          (state) => state.equipoVisitante.colorPortero,
          'equipoVisitante.colorPortero',
          '#ABCDEF',
        ),
      ],
    );
  });
}
