import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:courtsight/models/jugador.dart';

class Equipo extends Equatable {
  final String id;
  final String nombre;
  final String colorUniforme;
  final String colorPortero;
  final bool esLocal;
  final List<Jugador> roster;

  const Equipo({
    required this.id,
    required this.nombre,
    required this.colorUniforme,
    required this.colorPortero,
    required this.esLocal,
    this.roster = const [],
  });

  factory Equipo.create({
    required String nombre,
    String colorUniforme = '#FF0000',
    String colorPortero = '#00FF00',
    bool esLocal = true,
    List<Jugador> roster = const [],
  }) {
    return Equipo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombre,
      colorUniforme: colorUniforme,
      colorPortero: colorPortero,
      esLocal: esLocal,
      roster: List<Jugador>.unmodifiable(roster),
    );
  }

  factory Equipo.empty({bool esLocal = true}) {
    return Equipo.create(
      nombre: '',
      colorUniforme: esLocal ? '#FF0000' : '#0000FF',
      colorPortero: '#00FF00',
      esLocal: esLocal,
      roster: const [],
    );
  }

  Equipo copyWith({
    String? id,
    String? nombre,
    String? colorUniforme,
    String? colorPortero,
    bool? esLocal,
    List<Jugador>? roster,
  }) {
    return Equipo(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      colorUniforme: colorUniforme ?? this.colorUniforme,
      colorPortero: colorPortero ?? this.colorPortero,
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
