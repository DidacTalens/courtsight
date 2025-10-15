import 'package:equatable/equatable.dart';

class Parcial extends Equatable {
  final String id;
  final int minutoInicio;
  final int minutoFin;
  final int golesLocal;
  final int golesVisitante;

  const Parcial({
    required this.id,
    required this.minutoInicio,
    required this.minutoFin,
    required this.golesLocal,
    required this.golesVisitante,
  });

  factory Parcial.create({
    required int minutoInicio,
    required int minutoFin,
    int golesLocal = 0,
    int golesVisitante = 0,
  }) {
    return Parcial(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      minutoInicio: minutoInicio,
      minutoFin: minutoFin,
      golesLocal: golesLocal,
      golesVisitante: golesVisitante,
    );
  }

  Parcial copyWith({
    String? id,
    int? minutoInicio,
    int? minutoFin,
    int? golesLocal,
    int? golesVisitante,
  }) {
    return Parcial(
      id: id ?? this.id,
      minutoInicio: minutoInicio ?? this.minutoInicio,
      minutoFin: minutoFin ?? this.minutoFin,
      golesLocal: golesLocal ?? this.golesLocal,
      golesVisitante: golesVisitante ?? this.golesVisitante,
    );
  }

  @override
  List<Object?> get props => [id, minutoInicio, minutoFin, golesLocal, golesVisitante];

  String get rangoTiempo => '$minutoInicio-$minutoFin\'';
  String get marcador => '$golesLocal-$golesVisitante';
}