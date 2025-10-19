import 'package:bloc/bloc.dart';
import 'package:courtsight/models/equipo.dart';
import 'setup_event.dart';
import 'setup_state.dart';

class SetupBloc extends Bloc<SetupEvent, SetupState> {
  SetupBloc() : super(SetupState.inicial()) {
    on<SetupTeamNameChanged>(_onTeamNameChanged);
    on<SetupTeamColorChanged>(_onTeamColorChanged);
  }

  void _onTeamNameChanged(
    SetupTeamNameChanged event,
    Emitter<SetupState> emit,
  ) {
    switch (event.team) {
      case SetupTeam.local:
        emit(state.copyWith(
          equipoLocal: state.equipoLocal.copyWith(nombre: event.nombre),
        ));
        break;
      case SetupTeam.visitante:
        emit(state.copyWith(
          equipoVisitante: state.equipoVisitante.copyWith(nombre: event.nombre),
        ));
        break;
    }
  }

  void _onTeamColorChanged(
    SetupTeamColorChanged event,
    Emitter<SetupState> emit,
  ) {
    Equipo objetivo;
    switch (event.team) {
      case SetupTeam.local:
        objetivo = state.equipoLocal;
        break;
      case SetupTeam.visitante:
        objetivo = state.equipoVisitante;
        break;
    }

    switch (event.slot) {
      case UniformSlot.jugadores:
        objetivo = objetivo.copyWith(colorUniforme: event.hexColor);
        break;
      case UniformSlot.portero:
        objetivo = objetivo.copyWith(colorPortero: event.hexColor);
        break;
    }

    switch (event.team) {
      case SetupTeam.local:
        emit(state.copyWith(equipoLocal: objetivo));
        break;
      case SetupTeam.visitante:
        emit(state.copyWith(equipoVisitante: objetivo));
        break;
    }
  }
}
