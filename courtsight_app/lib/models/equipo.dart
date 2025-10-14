import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Equipo extends Equatable {
  final String id;
  final String nombre;
  final String colorUniforme;
  final String colorPortero;
  final bool esLocal;

  const Equipo({
    required this.id,
    required this.nombre,
    required this.colorUniforme,
    required this.colorPortero,
    required this.esLocal,
  });

  factory Equipo.create({
    required String nombre,
    String colorUniforme = '#FF0000',
    String colorPortero = '#00FF00',
    bool esLocal = true,
  }) {
    return Equipo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombre,
      colorUniforme: colorUniforme,
      colorPortero: colorPortero,
      esLocal: esLocal,
    );
  }

  factory Equipo.empty({bool esLocal = true}) {
    return Equipo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: '',
      colorUniforme: esLocal ? '#FF0000' : '#0000FF',
      colorPortero: '#00FF00',
      esLocal: esLocal,
    );
  }

  Equipo copyWith({
    String? id,
    String? nombre,
    String? colorUniforme,
    String? colorPortero,
    bool? esLocal,
  }) {
    return Equipo(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      colorUniforme: colorUniforme ?? this.colorUniforme,
      colorPortero: colorPortero ?? this.colorPortero,
      esLocal: esLocal ?? this.esLocal,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        colorUniforme,
        colorPortero,
        esLocal,
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
    return 'Equipo(id: $id, nombre: $nombre)';
  }
}