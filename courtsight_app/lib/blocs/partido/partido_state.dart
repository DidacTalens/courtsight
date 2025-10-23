import 'package:equatable/equatable.dart';
import 'package:courtsight/models/partido.dart';

enum PartidoStatus { inicial, cargando, enCurso, pausado, finalizado, fallo }

class PartidoState extends Equatable {
  final PartidoStatus status;
  final Partido? partido;
  final String? mensajeError;

  const PartidoState._({
    required this.status,
    this.partido,
    this.mensajeError,
  });

  // Estado inicial antes de la carga
  const PartidoState.inicial() : this._(status: PartidoStatus.inicial);

  // Estado de carga
  const PartidoState.cargando() : this._(status: PartidoStatus.cargando);

  // Estado de partido en curso
  const PartidoState.enCurso({required Partido partido})
      : this._(status: PartidoStatus.enCurso, partido: partido);

  // Estado que contiene el Partido. El status del BLoC se basa en el estado del modelo Partido.
  factory PartidoState.cargado({required Partido partido}) {
    final PartidoStatus status;
    switch (partido.estado) {
      case EstadoPartido.enCurso:
        status = PartidoStatus.enCurso;
        break;
      case EstadoPartido.pausado:
      case EstadoPartido.configuracion:
        status = PartidoStatus.pausado;
        break;
      case EstadoPartido.finalizado:
        status = PartidoStatus.finalizado;
        break;
    }
    return PartidoState._(status: status, partido: partido);
  }

  // Estado de fallo
  const PartidoState.fallo({required String mensaje})
      : this._(status: PartidoStatus.fallo, mensajeError: mensaje);

  // Getters de utilidad
  bool get estaCargado => partido != null;
  bool get enCurso => status == PartidoStatus.enCurso;
  bool get pausado => status == PartidoStatus.pausado;
  bool get tieneError => status == PartidoStatus.fallo;

  @override
  List<Object?> get props => [status, partido, mensajeError];
}
