import 'package:equatable/equatable.dart';
import 'package:courtsight/models/equipo.dart';

class SetupState extends Equatable {
  const SetupState({
    required this.equipoLocal,
    required this.equipoVisitante,
  });

  factory SetupState.inicial() {
    return SetupState(
      equipoLocal: Equipo.empty(esLocal: true),
      equipoVisitante: Equipo.empty(esLocal: false),
    );
  }

  final Equipo equipoLocal;
  final Equipo equipoVisitante;

  SetupState copyWith({
    Equipo? equipoLocal,
    Equipo? equipoVisitante,
  }) {
    return SetupState(
      equipoLocal: equipoLocal ?? this.equipoLocal,
      equipoVisitante: equipoVisitante ?? this.equipoVisitante,
    );
  }

  @override
  List<Object?> get props => [equipoLocal, equipoVisitante];
}
