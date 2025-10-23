import 'package:bloc/bloc.dart';
import 'package:courtsight/models/models.dart';
import 'partido_event.dart';
import 'partido_state.dart';

class PartidoBloc extends Bloc<PartidoEvent, PartidoState> {
  final Future<Partido> Function(String id) loadPartido;

  PartidoBloc({required this.loadPartido, Partido? initialPartido})
      : super(initialPartido != null
            ? PartidoState.enCurso(partido: initialPartido)
            : const PartidoState.inicial()) {
    on<PartidoLoadRequested>(_onLoadRequested);
    on<PartidoCambioPortero>(_onCambioPortero);
    on<PartidoSieteMetrosRegistrado>(_onSieteMetrosRegistrado);
  }

  Future<void> _onLoadRequested(
    PartidoLoadRequested event,
    Emitter<PartidoState> emit,
  ) async {
    emit(const PartidoState.cargando());
    try {
      final partido = await loadPartido(event.partidoId);
      emit(PartidoState.enCurso(partido: partido));
    } catch (_) {
      emit(const PartidoState.fallo(mensaje: 'Error al cargar el partido.'));
    }
  }

  void _onCambioPortero(
    PartidoCambioPortero event,
    Emitter<PartidoState> emit,
  ) {
    final partidoActual = state.partido;
    if (partidoActual == null) return;

    final partidoActualizado = partidoActual.cambiarPortero(
      equipoId: event.equipoId,
      nuevoPorteroId: event.nuevoPorteroId,
    );

    emit(PartidoState.enCurso(partido: partidoActualizado));
  }

  void _onSieteMetrosRegistrado(
    PartidoSieteMetrosRegistrado event,
    Emitter<PartidoState> emit,
  ) {
    final partidoActual = state.partido;
    if (partidoActual == null) return;

    final partidoActualizado = partidoActual.registrarSieteMetros(
      equipoPorteroId: event.equipoPorteroId,
      porteroId: event.porteroId,
      equipoLanzadorId: event.equipoLanzadorId,
      lanzadorId: event.lanzadorId,
      esGol: event.esGol,
      amonestacion: event.amonestacion,
    );

    emit(PartidoState.enCurso(partido: partidoActualizado));
  }
}
