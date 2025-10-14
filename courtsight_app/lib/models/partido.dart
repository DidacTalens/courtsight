import 'package:equatable/equatable.dart';
import 'equipo.dart';

enum EstadoPartido {
  configuracion,
  enCurso,
  pausado,
  finalizado;

  String get displayName {
    switch (this) {
      case EstadoPartido.configuracion:
        return 'Configuración';
      case EstadoPartido.enCurso:
        return 'En Curso';
      case EstadoPartido.pausado:
        return 'Pausado';
      case EstadoPartido.finalizado:
        return 'Finalizado';
    }
  }
}

class Partido extends Equatable {
  final String id;
  final DateTime fecha;
  final Equipo equipoLocal;
  final Equipo equipoVisitante;
  final EstadoPartido estado;
  final int duracionMinutos;
  final int tiempoTranscurrido; // En segundos
  final int marcadorLocal;
  final int marcadorVisitante;
  final String? equipoEnAtaque;
  final DateTime fechaCreacion;
  final DateTime? fechaFinalizacion;

  const Partido({
    required this.id,
    required this.fecha,
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.estado,
    required this.duracionMinutos,
    required this.tiempoTranscurrido,
    required this.marcadorLocal,
    required this.marcadorVisitante,
    this.equipoEnAtaque,
    required this.fechaCreacion,
    this.fechaFinalizacion,
  });

  factory Partido.create({
    required Equipo equipoLocal,
    required Equipo equipoVisitante,
    int duracionMinutos = 60,
  }) {
    final now = DateTime.now();
    return Partido(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fecha: now,
      equipoLocal: equipoLocal,
      equipoVisitante: equipoVisitante,
      estado: EstadoPartido.configuracion,
      duracionMinutos: duracionMinutos,
      tiempoTranscurrido: 0,
      marcadorLocal: 0,
      marcadorVisitante: 0,
      equipoEnAtaque: equipoLocal.id,
      fechaCreacion: now,
    );
  }

  Partido copyWith({
    String? id,
    DateTime? fecha,
    Equipo? equipoLocal,
    Equipo? equipoVisitante,
    EstadoPartido? estado,
    int? duracionMinutos,
    int? tiempoTranscurrido,
    int? marcadorLocal,
    int? marcadorVisitante,
    String? equipoEnAtaque,
    DateTime? fechaCreacion,
    DateTime? fechaFinalizacion,
  }) {
    return Partido(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      equipoLocal: equipoLocal ?? this.equipoLocal,
      equipoVisitante: equipoVisitante ?? this.equipoVisitante,
      estado: estado ?? this.estado,
      duracionMinutos: duracionMinutos ?? this.duracionMinutos,
      tiempoTranscurrido: tiempoTranscurrido ?? this.tiempoTranscurrido,
      marcadorLocal: marcadorLocal ?? this.marcadorLocal,
      marcadorVisitante: marcadorVisitante ?? this.marcadorVisitante,
      equipoEnAtaque: equipoEnAtaque ?? this.equipoEnAtaque,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaFinalizacion: fechaFinalizacion ?? this.fechaFinalizacion,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fecha,
        equipoLocal,
        equipoVisitante,
        estado,
        duracionMinutos,
        tiempoTranscurrido,
        marcadorLocal,
        marcadorVisitante,
        equipoEnAtaque,
        fechaCreacion,
        fechaFinalizacion,
      ];

  // Getters de utilidad
  String get nombreCompleto => '${equipoLocal.nombre} vs ${equipoVisitante.nombre}';
  
  int get minutoActual => tiempoTranscurrido ~/ 60;
  
  int get segundoActual => tiempoTranscurrido % 60;
  
  String get tiempoFormateado {
    final minutos = minutoActual.toString().padLeft(2, '0');
    final segundos = segundoActual.toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }
  
  String get marcadorFormateado => '$marcadorLocal - $marcadorVisitante';
  
  bool get estaEnCurso => estado == EstadoPartido.enCurso;
  
  bool get estaFinalizado => estado == EstadoPartido.finalizado;
  
  bool get estaPausado => estado == EstadoPartido.pausado;
  
  bool get equipoLocalAtacando => equipoEnAtaque == equipoLocal.id;

  @override
  String toString() {
    return 'Partido(id: $id, $nombreCompleto, estado: ${estado.displayName})';
  }
}