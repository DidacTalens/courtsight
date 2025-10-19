import 'package:equatable/equatable.dart';

class Jugador extends Equatable {
  const Jugador({
    required this.id,
    required this.nombre,
    required this.dorsal,
  });

  factory Jugador.create({
    String nombre = '',
    String dorsal = '',
  }) {
    return Jugador(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombre,
      dorsal: dorsal,
    );
  }

  factory Jugador.empty() {
    return Jugador.create();
  }

  final String id;
  final String nombre;
  final String dorsal;

  Jugador copyWith({
    String? id,
    String? nombre,
    String? dorsal,
  }) {
    return Jugador(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      dorsal: dorsal ?? this.dorsal,
    );
  }

  @override
  List<Object?> get props => [id, nombre, dorsal];
}
