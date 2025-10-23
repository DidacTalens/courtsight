import 'package:equatable/equatable.dart';

abstract class PartidoEvent extends Equatable {
  const PartidoEvent();

  @override
  List<Object?> get props => [];
}

class PartidoLoadRequested extends PartidoEvent {
  final String partidoId;

  const PartidoLoadRequested({required this.partidoId});

  @override
  List<Object?> get props => [partidoId];
}

// Evento específico para cambiar de portero
class PartidoCambioPortero extends PartidoEvent {
  final String equipoId;
  final String nuevoPorteroId;

  const PartidoCambioPortero({
    required this.equipoId,
    required this.nuevoPorteroId,
  });

  @override
  List<Object?> get props => [equipoId, nuevoPorteroId];
}

class PartidoSieteMetrosRegistrado extends PartidoEvent {
  final String equipoPorteroId;
  final String porteroId;
  final String equipoLanzadorId;
  final String lanzadorId;
  final bool esGol;
  final bool amonestacion;

  const PartidoSieteMetrosRegistrado({
    required this.equipoPorteroId,
    required this.porteroId,
    required this.equipoLanzadorId,
    required this.lanzadorId,
    required this.esGol,
    this.amonestacion = false,
  });

  @override
  List<Object?> get props => [
        equipoPorteroId,
        porteroId,
        equipoLanzadorId,
        lanzadorId,
        esGol,
        amonestacion,
      ];
}
