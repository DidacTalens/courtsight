import 'package:equatable/equatable.dart';

class JugadorEstadisticas extends Equatable {
  const JugadorEstadisticas({
    this.lanzamientos = 0,
    this.goles = 0,
    this.amonestaciones = 0,
  });

  final int lanzamientos;
  final int goles;
  final int amonestaciones;

  JugadorEstadisticas copyWith({
    int? lanzamientos,
    int? goles,
    int? amonestaciones,
  }) {
    return JugadorEstadisticas(
      lanzamientos: lanzamientos ?? this.lanzamientos,
      goles: goles ?? this.goles,
      amonestaciones: amonestaciones ?? this.amonestaciones,
    );
  }

  JugadorEstadisticas incrementar({
    int lanzamientos = 0,
    int goles = 0,
    int amonestaciones = 0,
  }) {
    return copyWith(
      lanzamientos: this.lanzamientos + lanzamientos,
      goles: this.goles + goles,
      amonestaciones: this.amonestaciones + amonestaciones,
    );
  }

  @override
  List<Object?> get props => [lanzamientos, goles, amonestaciones];
}
