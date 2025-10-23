import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:courtsight/models/jugador.dart';

class Equipo extends Equatable {
  final String id;
  final String nombre;
  final String colorUniforme;
  final String colorPortero;
  final String porteroActivoId;
  final bool esLocal;
  final List<Jugador> roster;

  const Equipo({
    required this.id,
    required this.nombre,
    required this.colorUniforme,
    required this.colorPortero,
    required this.porteroActivoId,
    required this.esLocal,
    this.roster = const [],
  });

  static final Uuid _uuid = const Uuid();

  factory Equipo.create({
    required String nombre,
    String colorUniforme = '#FF0000',
    String colorPortero = '#00FF00',
    required String porteroActivoId,
    bool esLocal = true,
    List<Jugador> roster = const [],
  }) {
    return Equipo(
      id: _uuid.v4(),
      nombre: nombre,
      colorUniforme: colorUniforme,
      colorPortero: colorPortero,
      porteroActivoId: porteroActivoId,
      esLocal: esLocal,
      roster: List<Jugador>.unmodifiable(roster),
    );
  }

  factory Equipo.empty({bool esLocal = true}) {
    return Equipo.create(
      nombre: '',
      colorUniforme: esLocal ? '#FF0000' : '#0000FF',
      colorPortero: '#00FF00',
      porteroActivoId: '',
      esLocal: esLocal,
      roster: const [],
    );
  }

  Equipo copyWith({
    String? id,
    String? nombre,
    String? colorUniforme,
    String? colorPortero,
    String? porteroActivoId,
    bool? esLocal,
    List<Jugador>? roster,
  }) {
    return Equipo(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      colorUniforme: colorUniforme ?? this.colorUniforme,
      colorPortero: colorPortero ?? this.colorPortero,
      porteroActivoId: porteroActivoId ?? this.porteroActivoId,
      esLocal: esLocal ?? this.esLocal,
      roster: roster != null ? List<Jugador>.unmodifiable(roster) : this.roster,
    );
  }

  String get _rosterSignature => roster
      .map((jugador) => '${jugador.id}:${jugador.nombre}:${jugador.dorsal}')
      .join('|');

  @override
  List<Object?> get props => [
        id,
        nombre,
        colorUniforme,
        colorPortero,
        porteroActivoId,
        esLocal,
        _rosterSignature,
      ];

  // Getters de utilidad
  Color get color {
    try {
      return Color(int.parse(colorUniforme.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.red;
    }
  }

  Color get colorPorteroColor {
    try {
      return Color(int.parse(colorPortero.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.green;
    }
  }

  @override
  String toString() {
    return 'Equipo(id: $id, nombre: $nombre, roster: ${roster.length})';
  }
}
