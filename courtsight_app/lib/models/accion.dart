import 'package:equatable/equatable.dart';

enum AccionTipo {
  sieteMetros,
}

class Accion extends Equatable {
  const Accion({
    required this.id,
    required this.tipo,
    required this.descripcion,
    required this.timestamp,
    this.equipoId,
    this.porteroId,
    this.lanzadorId,
    this.resultado,
    this.amonestacion = false,
  });

  final String id;
  final AccionTipo tipo;
  final String descripcion;
  final DateTime timestamp;
  final String? equipoId;
  final String? porteroId;
  final String? lanzadorId;
  final String? resultado;
  final bool amonestacion;

  @override
  List<Object?> get props => [
        id,
        tipo,
        descripcion,
        timestamp,
        equipoId,
        porteroId,
        lanzadorId,
        resultado,
        amonestacion,
      ];
}
