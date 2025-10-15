import 'package:equatable/equatable.dart';
import 'package:courtsight/models/models.dart';

enum DashboardStatus { inicial, cargando, cargado, fallo }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final List<Partido> partidos;
  final String? mensajeError;

  const DashboardState._({
    required this.status,
    this.partidos = const [],
    this.mensajeError,
  });

  const DashboardState.inicial()
      : this._(status: DashboardStatus.inicial);

  const DashboardState.cargando()
      : this._(status: DashboardStatus.cargando);

  const DashboardState.cargado({required List<Partido> partidos})
      : this._(status: DashboardStatus.cargado, partidos: partidos);

  const DashboardState.fallo({required String mensaje})
      : this._(status: DashboardStatus.fallo, mensajeError: mensaje);

  bool get estaCargando => status == DashboardStatus.cargando;
  bool get estaCargado => status == DashboardStatus.cargado;
  bool get tieneError => status == DashboardStatus.fallo && mensajeError != null;

  @override
  List<Object?> get props => [status, partidos, mensajeError];
}
