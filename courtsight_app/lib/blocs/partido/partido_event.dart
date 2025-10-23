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
