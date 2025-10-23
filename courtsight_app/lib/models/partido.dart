import 'package:equatable/equatable.dart';
import 'equipo.dart';
import 'jugador.dart';
import 'parcial.dart';
import 'accion.dart';
import 'estadisticas.dart';
import 'package:uuid/uuid.dart';

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
  final List<Parcial> parciales;
  final String? equipoEnAtaque;
  final DateTime fechaCreacion;
  final DateTime? fechaFinalizacion;
  final List<Accion> acciones;
  final Map<String, JugadorEstadisticas> estadisticasJugadores;

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
    required this.parciales,
    this.equipoEnAtaque,
    required this.fechaCreacion,
    this.fechaFinalizacion,
    this.acciones = const [],
    this.estadisticasJugadores = const {},
  });

  factory Partido.create({
    required Equipo equipoLocal,
    required Equipo equipoVisitante,
    int duracionMinutos = 60,
  }) {
    final now = DateTime.now();

    // Inicializar parciales de 5 minutos
    final parciales = <Parcial>[];
    for (int i = 0; i < duracionMinutos; i += 5) {
      parciales.add(Parcial.create(
        minutoInicio: i,
        minutoFin: (i + 5).clamp(0, duracionMinutos),
      ));
    }

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
      parciales: parciales,
      equipoEnAtaque: equipoLocal.id,
      fechaCreacion: now,
      acciones: const [],
      estadisticasJugadores: const {},
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
    List<Parcial>? parciales,
    String? equipoEnAtaque,
    DateTime? fechaCreacion,
    DateTime? fechaFinalizacion,
    List<Accion>? acciones,
    Map<String, JugadorEstadisticas>? estadisticasJugadores,
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
      parciales: parciales ?? this.parciales,
      equipoEnAtaque: equipoEnAtaque ?? this.equipoEnAtaque,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaFinalizacion: fechaFinalizacion ?? this.fechaFinalizacion,
      acciones: acciones ?? this.acciones,
      estadisticasJugadores:
          estadisticasJugadores ?? this.estadisticasJugadores,
    );
  }

  Partido cambiarPortero(
      {required String equipoId, required String nuevoPorteroId}) {
    final bool esLocal = equipoLocal.id == equipoId;
    final bool esVisitante = equipoVisitante.id == equipoId;

    if (!esLocal && !esVisitante) {
      return this;
    }

    if (esLocal) {
      return copyWith(
        equipoLocal: equipoLocal.copyWith(porteroActivoId: nuevoPorteroId),
      );
    }

    return copyWith(
      equipoVisitante:
          equipoVisitante.copyWith(porteroActivoId: nuevoPorteroId),
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
        parciales,
        equipoEnAtaque,
        fechaCreacion,
        fechaFinalizacion,
        acciones,
        estadisticasJugadores,
      ];

  // Getters de utilidad
  String get nombreCompleto =>
      '${equipoLocal.nombre} vs ${equipoVisitante.nombre}';

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

  Parcial? get parcialActual {
    return parciales.cast<Parcial?>().firstWhere(
          (parcial) =>
              parcial != null &&
              minutoActual >= parcial.minutoInicio &&
              minutoActual < parcial.minutoFin,
          orElse: () => null,
        );
  }

  Partido registrarSieteMetros({
    required String equipoPorteroId,
    required String porteroId,
    required String equipoLanzadorId,
    required String lanzadorId,
    required bool esGol,
    bool amonestacion = false,
  }) {
    final nuevoUuid = const Uuid();
    final String descripcion = _descripcionSieteMetros(
      equipoPorteroId: equipoPorteroId,
      porteroId: porteroId,
      equipoLanzadorId: equipoLanzadorId,
      lanzadorId: lanzadorId,
      esGol: esGol,
      amonestacion: amonestacion,
    );

    final nuevaAccion = Accion(
      id: nuevoUuid.v4(),
      tipo: AccionTipo.sieteMetros,
      descripcion: descripcion,
      timestamp: DateTime.now(),
      equipoId: equipoLanzadorId,
      porteroId: porteroId,
      lanzadorId: lanzadorId,
      resultado: esGol ? 'Gol' : 'Fallo',
      amonestacion: amonestacion,
    );

    final actualizado = _actualizarEstadisticasSieteMetros(
      porteroId: porteroId,
      lanzadorId: lanzadorId,
      esGol: esGol,
      amonestacion: amonestacion,
    );

    return copyWith(
      acciones: [...acciones, nuevaAccion],
      estadisticasJugadores: actualizado,
    );
  }

  Map<String, JugadorEstadisticas> _actualizarEstadisticasSieteMetros({
    required String porteroId,
    required String lanzadorId,
    required bool esGol,
    required bool amonestacion,
  }) {
    JugadorEstadisticas obtenerStats(String jugadorId) {
      return estadisticasJugadores[jugadorId] ?? const JugadorEstadisticas();
    }

    final Map<String, JugadorEstadisticas> actualizado =
        Map<String, JugadorEstadisticas>.from(estadisticasJugadores);

    actualizado[lanzadorId] = obtenerStats(lanzadorId).incrementar(
      lanzamientos: 1,
      goles: esGol ? 1 : 0,
    );

    if (amonestacion) {
      actualizado[lanzadorId] =
          actualizado[lanzadorId]!.incrementar(amonestaciones: 1);
    }

    actualizado[porteroId] =
        obtenerStats(porteroId).incrementar(lanzamientos: 1);

    return actualizado;
  }

  String _descripcionSieteMetros({
    required String equipoPorteroId,
    required String porteroId,
    required String equipoLanzadorId,
    required String lanzadorId,
    required bool esGol,
    required bool amonestacion,
  }) {
    final Equipo equipoPortero =
        equipoLocal.id == equipoPorteroId ? equipoLocal : equipoVisitante;
    final Equipo equipoLanzador =
        equipoLocal.id == equipoLanzadorId ? equipoLocal : equipoVisitante;

    final Jugador? portero = equipoPortero.roster.firstWhere(
      (j) => j.id == porteroId,
      orElse: () => Jugador.create(nombre: 'Portero', dorsal: ''),
    );
    final Jugador? lanzador = equipoLanzador.roster.firstWhere(
      (j) => j.id == lanzadorId,
      orElse: () => Jugador.create(nombre: 'Jugador', dorsal: ''),
    );

    final resultado = esGol ? 'Gol' : 'Fallo';
    final amonestacionTexto = amonestacion ? ' con Amonestación' : '';

    return '7m $resultado - ${equipoLanzador.nombre} (${lanzador?.dorsal} ${lanzador?.nombre}) vs ${equipoPortero.nombre} (${portero?.dorsal} ${portero?.nombre})$amonestacionTexto';
  }

  @override
  String toString() {
    return 'Partido(id: $id, $nombreCompleto, estado: ${estado.displayName})';
  }
}
