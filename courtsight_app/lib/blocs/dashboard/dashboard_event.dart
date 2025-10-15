import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardLoadRequested extends DashboardEvent {
  const DashboardLoadRequested();
}

class DashboardPartidoSeleccionado extends DashboardEvent {
  final String partidoId;

  const DashboardPartidoSeleccionado(this.partidoId);

  @override
  List<Object?> get props => [partidoId];
}
