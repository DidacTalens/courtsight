import 'package:bloc/bloc.dart';
import 'package:courtsight/models/partido.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final Future<List<Partido>> Function() partidosProvider;
  final void Function(String partidoId) onPartidoSeleccionado;

  DashboardBloc({
    required this.partidosProvider,
    required this.onPartidoSeleccionado,
  }) : super(const DashboardState.inicial()) {
    on<DashboardLoadRequested>(_onLoadRequested);
    on<DashboardPartidoSeleccionado>(_onPartidoSeleccionado);
  }

  Future<void> _onLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardState.cargando());
    try {
      final partidos = await partidosProvider();
      emit(DashboardState.cargado(partidos: partidos));
    } catch (_) {
      emit(const DashboardState.fallo(mensaje: 'Error al cargar partidos'));
    }
  }

  void _onPartidoSeleccionado(
    DashboardPartidoSeleccionado event,
    Emitter<DashboardState> emit,
  ) {
    onPartidoSeleccionado(event.partidoId);
  }
}
