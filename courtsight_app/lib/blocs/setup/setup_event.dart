import 'package:equatable/equatable.dart';

enum SetupTeam { local, visitante }

enum UniformSlot { jugadores, portero }

abstract class SetupEvent extends Equatable {
  const SetupEvent();

  @override
  List<Object?> get props => [];
}

class SetupTeamNameChanged extends SetupEvent {
  const SetupTeamNameChanged({
    required this.team,
    required this.nombre,
  });

  final SetupTeam team;
  final String nombre;

  @override
  List<Object?> get props => [team, nombre];
}

class SetupTeamColorChanged extends SetupEvent {
  const SetupTeamColorChanged({
    required this.team,
    required this.slot,
    required this.hexColor,
  });

  final SetupTeam team;
  final UniformSlot slot;
  final String hexColor;

  @override
  List<Object?> get props => [team, slot, hexColor];
}
